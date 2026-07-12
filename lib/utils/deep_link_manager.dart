import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:card_coin/app.dart';
import 'package:card_coin/cache/bean/user_info_bean.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/progress_dialog/progress_dialog.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/http/result_data.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';

// 1️⃣ 定义事件类
class ReloadMainDataEvent {}

class RefreshMyAssetEvent {}

// 2️⃣ 创建全局 EventBus
final eventBus = EventBus();

/// 全局 DeepLink 管理类（单例）
class DeepLinkManager {
  // 单例实例
  static final DeepLinkManager _instance = DeepLinkManager._internal();
  factory DeepLinkManager() => _instance;
  DeepLinkManager._internal();

  // 初始化 app_links
  final AppLinks _appLinks = AppLinks();
  // 热启动链接监听订阅（全局保存）
  StreamSubscription<Uri?>? _hotLinkSubscription;
  // 暂停标志：扫卡期间禁止处理任何 DeepLink
  bool _suspended = false;
  // 互斥标志：防止并发处理导致重复跳转
  bool _isHandling = false;
  // 当前处理期间收到的新链接（处理完成后立即执行，不丢弃）
  Uri? _pendingUri;
  // 防止 init() 被重复调用
  bool _initialized = false;
  // 冷启动 URI 去重：app_links 可能通过 getInitialAppLink 和 uriLinkStream 双重投递，
  // 记录冷启动 URI 和时间，10 秒内忽略 stream 中相同的 URI 避免重复处理打断导航
  Uri? _coldStartUri;
  DateTime? _coldStartTime;

  /// 暂停 DeepLink 处理（扫卡前调用）
  void suspend() => _suspended = true;

  /// 恢复 DeepLink 处理（扫卡完成后调用）
  void resume() => _suspended = false;

  /// 初始化全局监听（App 启动时调用一次）
  Future<void> init() async {
    if (_initialized) {
      print('[DeepLink] init: already initialized, skipping');
      return;
    }
    _initialized = true;
    final _t0 = DateTime.now().millisecondsSinceEpoch;
    print('[TIMING][DeepLink] init start, t=$_t0');

    // 1. 处理冷启动链接
    Uri? initialUri;
    const _channel = MethodChannel('com.walletconnect.flutterwallet/methods');

    if (Platform.isAndroid) {
      // ① 首选：MethodChannel
      try {
        print(
            '[TIMING][DeepLink] calling MethodChannel initialLink, t=${DateTime.now().millisecondsSinceEpoch - _t0}ms');
        final String? linkStr = await _channel
            .invokeMethod<String?>('initialLink')
            .timeout(const Duration(milliseconds: 800), onTimeout: () => null);
        print(
            '[TIMING][DeepLink] MethodChannel returned: $linkStr, t=${DateTime.now().millisecondsSinceEpoch - _t0}ms');
        if (linkStr != null && linkStr.isNotEmpty) {
          initialUri = Uri.tryParse(linkStr);
        }
      } catch (e) {
        print('[DeepLink] init: MethodChannel error: $e');
      }

      // ② Fallback：app_links
      if (initialUri == null) {
        try {
          print(
              '[TIMING][DeepLink] calling getInitialAppLink, t=${DateTime.now().millisecondsSinceEpoch - _t0}ms');
          initialUri = await _appLinks
              .getInitialAppLink()
              .timeout(const Duration(seconds: 2), onTimeout: () => null);
          print(
              '[TIMING][DeepLink] getInitialAppLink returned: $initialUri, t=${DateTime.now().millisecondsSinceEpoch - _t0}ms');
        } catch (e) {
          print('[DeepLink] init: getInitialAppLink error: $e');
        }
      }
    } else {
      initialUri = await _appLinks.getInitialAppLink();
      print('[DeepLink] init: getInitialAppLink returned: $initialUri');
    }

    if (initialUri != null && _isTargetHttpsLink(initialUri)) {
      _coldStartUri = initialUri;
      _coldStartTime = DateTime.now();
      _handleDeepLink(initialUri, isColdStart: true);
    } else {
      print('[DeepLink] init: no valid initial link (uri=$initialUri)');
    }

    // 2. 全局监听热启动链接（全程不取消，除非 App 退出）
    _hotLinkSubscription ??= _appLinks.uriLinkStream.listen((Uri? uri) {
      print('[DeepLink] uriLinkStream: $uri');
      if (uri == null || !_isTargetHttpsLink(uri)) return;
      // 过滤冷启动 URI 的重复投递（app_links 在 Android 上可能双重投递）
      if (_coldStartUri != null &&
          _coldStartTime != null &&
          uri.toString() == _coldStartUri.toString() &&
          DateTime.now().difference(_coldStartTime!).inSeconds < 10) {
        print(
            '[DeepLink] uriLinkStream: skip (same as cold start URI within 10s)');
        return;
      }
      _handleDeepLink(uri); // 热启动：isColdStart 默认 false
    });
  }

  /// 判断是否是目标 https 链接
  bool _isTargetHttpsLink(Uri uri) {
    return uri.scheme == 'https' && uri.host == 'asset.dropromo.com';
  }

  /// 统一处理 DeepLink（冷/热启动通用，全局跳转）
  void _handleDeepLink(Uri uri, {bool isColdStart = false}) {
    // 扫卡期间禁止任何跳转（Android NFC 会让 App 短暂后台，恢复时 app_links 重投 URI）
    if (_suspended) {
      print('DeepLinkManager: 扫卡中，忽略 URI（$uri）');
      return;
    }
    // 通过全局导航键获取 NavigatorState，无需当前页面 context

    // ========== 核心：统一跳转规则（适配任意页面） ==========
    // switch (path) {
    //   // 示例1：跳卡片详情页（清空之前的栈，只保留详情页/首页）
    //   case '/open/page':
    //   case '/open':
    //   case '/card/':
    //   case '/card/123': // 支持带 ID 的路径

    _onRegister(uri, isColdStart: isColdStart);
    // String cardId = params['cardId'] ??
    //     (path.split('/').length > 2 ? path.split('/')[2] : '');
    // navigator.pushAndRemoveUntil(
    //   MaterialPageRoute(builder: (context) => CardDetailPage(cardId: cardId)),
    //   (route) => route.isFirst, // 保留栈底的首页（可选，根据业务调整）
    // );
    //   break;

    // // 示例2：跳下载页（直接打开，保留当前栈）
    // case '/download':
    // navigator.push(
    //   MaterialPageRoute(builder: (context) => DownloadPage(version: version)),
    // );
    //   break;

    // // 示例3：跳首页（清空所有栈，回到首页）
    // case '/register':
    // default:
    //   // navigator.pushAndRemoveUntil(
    //   //   MaterialPageRoute(builder: (context) => const HomePage()),
    //   //   (route) => false, // 清空所有栈
    //   // );
    //   break;
    // }
  }

  /// 取消全局监听（App 退出时调用，可选）
  void dispose() {
    _hotLinkSubscription?.cancel();
    _hotLinkSubscription = null;
  }

  Future<void> _login(
    String accountType,
    String account,
    String credential,
  ) async {
    if (navigatorKey.currentContext == null) {
      return;
    }
    ProgressDialog pr = ProgressDialog(navigatorKey.currentContext!);
    await pr.show();

    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String? deviceName;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionCode = packageInfo.buildNumber;
    String versionName = packageInfo.version;
    if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      deviceName = androidDeviceInfo.model;
    } else if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      deviceName = iosDeviceInfo.model;
    }

    var params = {
      "credential": credential,
      "identifierCarrier": accountType,
      "identityType": "PASSWORD",
      "isoCode": '86',
      "identifier": account,
      'platform': Platform.isAndroid ? 'android' : 'ios',
      'deviceId': '123456',
      'deviceName': deviceName,
      'versionCode': versionCode,
      'versionName': versionName,
    };

    ResultData result = await HttpManager.getInstance()
        .post(NetworkAddress.loginMultipleUrl, null, data: params);

    pr.hide();
    if (result.isSuccess) {
      var userInfo = UserInfo.fromJson(result.data);
      LocalStorage.saveUserInfo(userInfo);
      Navigator.pushNamedAndRemoveUntil(
          navigatorKey.currentContext!, 'cardBaseMainPage', (route) => false,
          arguments: {'userInfo': userInfo});
    } else {
      print('error :${result.message}');
      showToast(result.message, position: const ToastPosition(offset: 150));
    }
  }

  Future<void> _onRegister(Uri uri, {bool isColdStart = false}) async {
    print(
        '[DeepLink] _onRegister called: uri=$uri, _isHandling=$_isHandling, isColdStart=$isColdStart');
    if (_isHandling) {
      _pendingUri = uri;
      print('[DeepLink] busy, saved as pending: $uri');
      return;
    }
    _isHandling = true;
    try {
      await _doRegister(uri, isColdStart: isColdStart);
      // 处理完成后，若有积压的新链接，立即处理（只保留最新的一个）
      // pending URI 都是后续热启动触发的，isColdStart = false
      while (_pendingUri != null) {
        final pending = _pendingUri!;
        _pendingUri = null;
        await _doRegister(pending);
      }
    } finally {
      _isHandling = false;
      _pendingUri = null;
    }
  }

  Future<void> _doRegister(Uri uri, {bool isColdStart = false}) async {
    final _t0 = DateTime.now().millisecondsSinceEpoch;
    print(
        '[TIMING][DeepLink] _doRegister start, isColdStart=$isColdStart, t=$_t0');

    if (isColdStart) {
      const maxContextWait = Duration(seconds: 5);
      const interval = Duration(milliseconds: 100);
      var waited = Duration.zero;
      while (navigatorKey.currentContext == null && waited < maxContextWait) {
        await Future.delayed(interval);
        waited += interval;
      }
      if (navigatorKey.currentContext == null) {
        print('[DeepLink] _doRegister: context still null, abort');
        return;
      }
      print(
          '[TIMING][DeepLink] context ready, t=${DateTime.now().millisecondsSinceEpoch - _t0}ms');

      // 2. 在推入骨架屏之前，先检查栈顶——
      //    若 SplashPage 已在我们到达之前完成导航（竞争窗口），
      //    则直接推入骨架屏即可，无需轮询等待。
      const _mainRoutes = {
        'cardBaseMainPage',
        'scanLoginPage',
        'mainPage',
        'multipleLoginPage',
      };
      String? preCheckTop;
      navigatorKey.currentState?.popUntil((route) {
        preCheckTop = route.settings.name;
        return true;
      });
      final splashAlreadyDone =
          preCheckTop != null && _mainRoutes.contains(preCheckTop);

      // 推入骨架屏（无论哪种情况都推，覆盖空白期）
      navigatorKey.currentState?.push(MaterialPageRoute<void>(
        settings: const RouteSettings(name: '_deepLinkLoading'),
        builder: (_) => const _DeepLinkLoadingPage(),
      ));
      print(
          '[TIMING][DeepLink] skeleton pushed, splashAlreadyDone=$splashAlreadyDone, t=${DateTime.now().millisecondsSinceEpoch - _t0}ms');

      if (!splashAlreadyDone) {
        // 3a. SplashPage 仍在运行：轮询等待它完成
        //    • 骨架屏在顶 → SplashPage 仍在加载，继续等
        //    • 主路由出现 → SplashPage 清除了骨架屏，补推后 break
        const maxTotalWait = Duration(milliseconds: 500); // 超时后直接推目标页
        const pollInterval = Duration(milliseconds: 50);
        var totalWaited = Duration.zero;
        while (totalWaited < maxTotalWait) {
          String? topName;
          navigatorKey.currentState?.popUntil((route) {
            topName = route.settings.name;
            return true;
          });
          if (topName == '_deepLinkLoading') {
            await Future.delayed(pollInterval);
            totalWaited += pollInterval;
            continue;
          }
          if (topName != null && _mainRoutes.contains(topName)) {
            print(
                '[TIMING][DeepLink] splash done detected, topName=$topName, t=${DateTime.now().millisecondsSinceEpoch - _t0}ms');
            navigatorKey.currentState?.push(MaterialPageRoute<void>(
              settings: const RouteSettings(name: '_deepLinkLoading'),
              builder: (_) => const _DeepLinkLoadingPage(),
            ));
            break;
          }
          await Future.delayed(pollInterval);
          totalWaited += pollInterval;
        }
      }
      // 3b. SplashPage 已完成：骨架屏直接盖在主路由之上，跳过轮询
      //    仅等待主页 initState 完成
      await Future.delayed(const Duration(milliseconds: 300));
    } else {
      // 热启动只等一帧，避免在 errorTipPage 出现之前就完成导航
      await Future.delayed(const Duration(milliseconds: 80));
    }

// 所有 query 参数
    final params = uri.queryParameters;

// 单独取值
    final target = params['target'] ?? "";
    final uid = params['uid'];
    final taskItemId = params['taskItemId'];
    Map<String, dynamic>? arguments;
    //  showToast(
    //     "uri: == ${uri.toString()}, target:${target}, uid:${uid}, taskItemId:${taskItemId}");
    // 2. 获取当前路由栈的顶部路由名称
    String? currentTopRouteName;
    navigatorKey.currentState?.popUntil((route) {
      currentTopRouteName = route.settings.name;
      return true;
    });
    print(
        '[DeepLink] _doRegister after delay: target=$target currentTop=$currentTopRouteName');

    // 如果 target 不存在于路由表，直接放弃（避免触发 onGenerateRoute 的 errorTipPage 重定向）
    if (!AppRoute.isRouteExist(target)) {
      print('[DeepLink] ABORT: target "$target" not in route table');
      return;
    }
    if (currentTopRouteName == target) {
      if (currentTopRouteName == "cardBaseMainPage") {
        eventBus.fire(ReloadMainDataEvent());
      }
      print('[DeepLink] SKIP: already on target "$target"');
      return;
    }
    print(
        '[DeepLink] proceeding to push target="$target" from currentTop="$currentTopRouteName"');
    if (currentTopRouteName == "errorTipPage") {
      navigatorKey.currentState?.pop();
      await Future.delayed(const Duration(milliseconds: 80));
      String? newTop;
      navigatorKey.currentState?.popUntil((route) {
        newTop = route.settings.name;
        return true;
      });
      if (newTop == target) {
        print('[DeepLink] popped errorTipPage, already on target=$target');
        return;
      }
    }
    if (uid != null && taskItemId != null) {
      arguments = {
        'uid': uid,
        'taskItemId': taskItemId,
        'fromDeepLink': isColdStart,
      };
      HttpManager.getInstance().post(NetworkAddress.taskItemCompleted, null,
          data: {'uid': uid, 'taskItemId': taskItemId});
      if (target == "registerPage") {
        // registerPage 使用 pushNamed（需要 await 等待注册结果），
        // 但 pushNamed 不会清除栈中的骨架屏 _deepLinkLoading，
        // 导致用户从 registerPage 返回时看到骨架屏。
        // 修复：先显式弹出骨架屏，再 push registerPage。
        String? topBeforePush;
        navigatorKey.currentState?.popUntil((route) {
          topBeforePush = route.settings.name;
          return true;
        });
        if (topBeforePush == '_deepLinkLoading') {
          navigatorKey.currentState?.pop();
          await Future.delayed(const Duration(milliseconds: 50));
        }
        var result1 = await navigatorKey.currentState!
            .pushNamed(target, arguments: arguments);
        print('register result: $result1');
        if (result1 != null) {
          Map<String, dynamic> loginMap = result1 as Map<String, dynamic>;
          String phoneNum = loginMap['phoneNum'];
          String password = loginMap['password'];
          _login('MOBILE', '86$phoneNum', password);
        }
      } else if (target == "cardBaseMainPage") {
        // 清栈跳主页，不需要等待返回
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
            'cardBaseMainPage', (route) => false,
            arguments: arguments);
      } else {
        try {
          print(
              '[DeepLink] pushNamedAndRemoveUntil target=$target (has uid/taskItemId)');
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            target,
            (route) => route.settings.name == 'cardBaseMainPage',
            arguments: arguments,
          );
          print('[DeepLink] pushed $target (via pushNamedAndRemoveUntil)');
        } catch (e, s) {
          print('[DeepLink] pushNamed($target) failed: $e\n$s');
        }
      }
    } else {
      arguments = {'fromDeepLink': isColdStart};
      try {
        print(
            '[DeepLink] pushNamedAndRemoveUntil target=$target (no uid/taskItemId, isColdStart=$isColdStart)');
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          target,
          (route) => route.settings.name == 'cardBaseMainPage',
          arguments: arguments,
        );
        print(
            '[DeepLink] pushed $target (no uid/taskItemId, via pushNamedAndRemoveUntil)');
      } catch (e, s) {
        print('[DeepLink] pushNamed($target) failed: $e\n$s');
      }
    }
  }
}

// ──────────────────────────────────────────────
// DeepLink 冷启动骨架过渡屏
// 在 SplashPage 完成 → 目标页推入之间，作为视觉缓冲，避免白屏闪烁。
// pushNamedAndRemoveUntil 会自动将本页从栈中移除。
// ──────────────────────────────────────────────

class _DeepLinkLoadingPage extends StatelessWidget {
  const _DeepLinkLoadingPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient:
                Theme.of(context).extension<GradientTheme>()!.primaryGradient,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SkeletonBox(width: 160, height: 22),
            const SizedBox(height: 24),
            const _SkeletonBox(height: 14),
            const SizedBox(height: 8),
            const _SkeletonBox(height: 14, width: 280),
            const SizedBox(height: 8),
            const _SkeletonBox(height: 14, width: 240),
            const SizedBox(height: 24),
            const _SkeletonBox(height: 120, radius: 12),
            const SizedBox(height: 24),
            const _SkeletonBox(height: 14),
            const SizedBox(height: 8),
            const _SkeletonBox(height: 14, width: 200),
            const SizedBox(height: 8),
            const _SkeletonBox(height: 14, width: 260),
          ],
        ),
      ),
    );
  }
}

/// 带呼吸动画的骨架占位块
class _SkeletonBox extends StatefulWidget {
  final double height;
  final double? width;
  final double radius;

  const _SkeletonBox({
    this.height = 16,
    this.width,
    this.radius = 6,
  });

  @override
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<_SkeletonBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.35, end: 0.8).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        height: widget.height,
        width: widget.width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300]!.withOpacity(_anim.value),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

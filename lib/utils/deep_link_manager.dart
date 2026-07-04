import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:card_coin/app.dart';
import 'package:card_coin/cache/bean/user_info_bean.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/custom_widget/progress_dialog/progress_dialog.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/http/result_data.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
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

  /// 暂停 DeepLink 处理（扫卡前调用）
  void suspend() => _suspended = true;

  /// 恢复 DeepLink 处理（扫卡完成后调用）
  void resume() => _suspended = false;

  /// 初始化全局监听（App 启动时调用一次）
  Future<void> init() async {
    // 1. 处理冷启动链接
    final Uri? initialUri = await _appLinks.getInitialAppLink();
    // showToast("_hotLinkSubscription initialUri res: " + initialUri.toString());
    if (initialUri != null && _isTargetHttpsLink(initialUri)) {
      _handleDeepLink(initialUri); // 冷启动也走统一处理逻辑
    }

    // 2. 全局监听热启动链接（全程不取消，除非 App 退出）
    _hotLinkSubscription ??= _appLinks.uriLinkStream.listen((Uri? uri) {
      // showToast("_hotLinkSubscription hot res: " + uri.toString());
      if (uri != null && _isTargetHttpsLink(uri)) {
        _handleDeepLink(uri); // 热启动链接统一处理
      }
    });
  }

  /// 判断是否是目标 https 链接
  bool _isTargetHttpsLink(Uri uri) {
    return uri.scheme == 'https' && uri.host == 'asset.dropromo.com';
  }

  /// 统一处理 DeepLink（冷/热启动通用，全局跳转）
  void _handleDeepLink(Uri uri) {
    // 扫卡期间禁止任何跳转（Android NFC 会让 App 短暂后台，恢复时 app_links 重投 URI）
    if (_suspended) {
      print('DeepLinkManager: 扫卡中，忽略 URI（$uri）');
      return;
    }
    // 通过全局导航键获取 NavigatorState，无需当前页面 context

    // showToast("_handleDeepLink path = ${path}, params:${params}");
    // ========== 核心：统一跳转规则（适配任意页面） ==========
    // switch (path) {
    //   // 示例1：跳卡片详情页（清空之前的栈，只保留详情页/首页）
    //   case '/open/page':
    //   case '/open':
    //   case '/card/':
    //   case '/card/123': // 支持带 ID 的路径

    _onRegister(uri);
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

  Future<void> _onRegister(Uri uri) async {
    if (navigatorKey.currentContext == null) {
      // showToast("currentContext == null,");
      return;
    }

    await Future.delayed(const Duration(milliseconds: 1000));

// 所有 query 参数
    final params = uri.queryParameters;

// 单独取值
    final target = params['target'] ?? "";
    final uid = params['uid'];
    final taskItemId = params['taskItemId'];
    Map<String, String>? arguments;
    //  showToast(
    //     "uri: == ${uri.toString()}, target:${target}, uid:${uid}, taskItemId:${taskItemId}");
    // 2. 获取当前路由栈的顶部路由名称
    String? currentTopRouteName;
    navigatorKey.currentState!.popUntil((route) {
      // 获取当前路由的名称
      currentTopRouteName = route.settings.name;
      // 返回 true 表示停止遍历（只取栈顶的第一个路由）
      return true;
    });
    // showToast("currentRouteName:${currentTopRouteName}");

    // 3. 对比当前路由名称和目标路由名称
    if (!AppRoute.isRouteExist(target) &&
        currentTopRouteName == "errorTipPage") {
      print('当前页面已是页面报错，无需跳转');
      return; // 已在目标页面，直接返回
    }
    if (currentTopRouteName == target) {
      if (currentTopRouteName == "cardBaseMainPage") {
        // 发广播弹起扫卡
        eventBus.fire(ReloadMainDataEvent());
      }

      print('当前页面已是 $target，无需跳转');
      return; // 已在目标页面，直接返回
    }
    if (currentTopRouteName == "errorTipPage") {
      Navigator.of(navigatorKey.currentContext!).pop();
    }
    if (uid != null && taskItemId != null) {
      arguments = {'uid': uid, 'taskItemId': taskItemId};
      HttpManager.getInstance().post(NetworkAddress.taskItemCompleted, null,
          data: {'uid': uid, 'taskItemId': taskItemId});
      // if (reslut.isSuccess) {
      //   print('任务完成上报成功');
      // } else {
      //   print('任务完成上报失败: ${reslut.message}');
      // }
      if (target == "registerPage") {
        var result1 = await Navigator.of(navigatorKey.currentContext!)
            .pushNamed(target, arguments: arguments);
        print('register result: $result1');
        if (result1 != null) {
          Map<String, dynamic> loginMap = result1 as Map<String, dynamic>;
          String phoneNum = loginMap['phoneNum'];
          String password = loginMap['password'];
          _login('MOBILE', '86$phoneNum', password);
        }
      } else {
        if (target == "cardBaseMainPage") {
          await Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!,
              'cardBaseMainPage', (route) => false,
              arguments: arguments);
        } else {
          var result21 = await Navigator.of(navigatorKey.currentContext!)
              .pushNamed(target, arguments: arguments);
          print('splash_target result: $result21');
        }
      }
    } else {
      var result21 = await Navigator.of(navigatorKey.currentContext!)
          .pushNamed(target, arguments: arguments);
      print('splash_target result: $result21');
    }
  }
}

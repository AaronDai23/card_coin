import 'dart:io';

import 'package:card_coin/bean/update_info_bean.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/card_base/pages/main_page/tab_pages/tab_wallet_page/my_card_page/action.dart';
import 'package:card_coin/global_store/store.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/result_data.dart';
import 'package:card_coin/utils/deep_link_manager.dart';
import 'package:card_coin/widget/app_config.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:card_coin/widget/upgrade_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../app.dart';
import '../../../common/common_action/action.dart';
import '../../../custom_widget/load_image.dart';
import '../../../http/http_manager.dart';
import '../../bean/more_menu_info.dart';
import '../../bean/notice_message_bean.dart';
import '../../bean/page_categroy_item.dart';
import '../../utils/routes_util.dart';
import '../../widgets/pop_window.dart';
import 'action.dart';
import 'state.dart';

const double categoryItemHeight = 60.0;
const double categoryItemWidth = 160.0;

Effect<MainState>? buildEffect() {
  return combineEffects(<Object, Effect<MainState>>{
    Lifecycle.initState: _initLifecycle,
    MainAction.showMenu: _onShowMenu,
    MainAction.reload: _onInit,
    CommonAction.languageChanged: _onInit,
    MainAction.jump: _onJump,
    MainAction.menuItemClick: _onMenuItemClick,
    MainAction.loadUnreadCount: _onLoadUnreadCount,
    MainAction.upgrade: _onUpgrade,
    MainAction.upgradeApp: _onUpgradeApp,
    MainAction.notificationback: (action, ctx) =>
        ctx.dispatch(MainActionCreator.onJump(0)),
  });
}

void _initLifecycle(Action action, Context<MainState> ctx) {
  final tickerProvider = ctx.stfState as TickerProvider;
  ctx.state.tickerProvider = tickerProvider;

  ctx.state.menuController = AnimationController(
    vsync: tickerProvider,
    duration: const Duration(milliseconds: 300),
  );

  ctx.state.animation = Tween<double>(
    begin: 0,
    end: 1 / 360 * 315,
  ).animate(ctx.state.menuController!);

  ctx.state.tabController = TabController(
    vsync: tickerProvider,
    length: ctx.state.tabList.length,
  );
  ctx.dispatch(MainActionCreator.onReload());

  // 监听全局事件
  eventBus.on<ReloadMainDataEvent>().listen((event) {
    ctx.broadcast(MyCardActionCreator.onScanCardClick());
  });
}

Future<void> _onInit(Action action, Context<MainState> ctx) async {
  final currentCardUid = await LocalStorage.getCardUuid() ?? '';
  ctx.dispatch(MainActionCreator.onUpdateCardId(currentCardUid));

  Map<String, dynamic> params = {};
  await HttpManager.getInstance()
      .get(NetworkAddress.bannerMoreUrl, queryParameters: params)
      .then((result) {
    if (result.isSuccess) {
      print('load side success');
      if (result.data != null && result.data != '') {
        var moreMenuInfo = MoreMenuInfo.fromJson(result.data);
        ctx.dispatch(MainActionCreator.onUpdateCategoryList(moreMenuInfo));
      }
    } else {
      print('load side failure');
    }
  });

  ctx.dispatch(MainActionCreator.onLoadUnreadCount());
  ctx.dispatch(MainActionCreator.onUpGrade());
  var result = await HttpManager.getInstance()
      .get(NetworkAddress.mainTabsUrl, queryParameters: params);
  if (result.isSuccess) {
    List<dynamic> buttons = result.data;
    List<PageCategoryItem> list =
        buttons.map((e) => PageCategoryItem.fromJson(e)).toList();

    // 更新 state.tabList
    // 如果 TabController 已经存在，更新长度
    if (ctx.state.tabController == null ||
        ctx.state.tabController!.length != list.length) {
      ctx.state.tabController?.dispose();
      ctx.state.tabController = TabController(
        vsync: ctx.state.tickerProvider!,
        length: list.length,
      );
    }

    ctx.dispatch(MainActionCreator.onLoadSuccess(list));
  } else {
    final list = buildFallbackMainTabs();

    if (ctx.state.tabController == null ||
        ctx.state.tabController!.length != list.length) {
      ctx.state.tabController?.dispose();
      ctx.state.tabController = TabController(
        vsync: ctx.state.tickerProvider!,
        length: list.length,
      );
    }

    ctx.dispatch(MainActionCreator.onLoadSuccess(list));
  }
}

Future<void> _onJump(Action action, Context<MainState> ctx) async {
  final int targetIndex = action.payload;
  if (targetIndex < 0 || targetIndex >= ctx.state.tabList.length) {
    return;
  }

  final targetTab = ctx.state.tabList[targetIndex];
  if (_requiresCardUid(targetTab)) {
    final uid = await LocalStorage.getCardUuid() ?? '';
    if (uid.isEmpty) {
      final isZh =
          (ctx.state.languageLocale?.languageCode.toLowerCase() ?? '') == 'zh';
      final tip =
          isZh ? '请先在首页拍卡后，再切换到该页面' : 'Please tap card on Home page first';
      final homeIndex = _findHomeTabIndex(ctx.state.tabList);
      await showDialog(
          context: ctx.context,
          builder: (context) {
            return ZenggeTextAlertDialog(
              tip,
              enableCancel: false,
            );
          });
      ctx.state.tabController?.animateTo(homeIndex);
      ctx.dispatch(MainActionCreator.onApplyJump(homeIndex));
      return;
    }
    ctx.dispatch(MainActionCreator.onUpdateCardId(uid));
  }

  ctx.dispatch(MainActionCreator.onApplyJump(targetIndex));

  // When entering My Asset tab, force refresh so button layout follows latest pageFieldConfig cache.
  if (targetTab.target == 'myAssetPage') {
    eventBus.fire(RefreshMyAssetEvent());
  }
}

bool _requiresCardUid(PageCategoryItem tab) {
  return tab.target == 'myAssetPage';
}

int _findHomeTabIndex(List<PageCategoryItem> tabList) {
  final index = tabList.indexWhere((tab) {
    final code = tab.code?.toUpperCase() ?? '';
    final category = tab.category?.toUpperCase() ?? '';
    return tab.target == 'tabWalletPage' ||
        code == 'WALLET' ||
        category == 'HOME';
  });
  return index >= 0 ? index : 0;
}

void _onLoadUnreadCount(Action action, Context<MainState> ctx) {
  if (ctx.state.taskItemId != null) {
    return; // 外部跳转的不需要请求，不然又提示弹窗了。
  }
  HttpManager.getInstance()
      .get(NetworkAddress.messageUnreadCountUrl)
      .then((result) {
    if (result.isSuccess) {
      var unReadInfo = UnReadCountInfo.fromJson(result.data);
      int unReadCount = unReadInfo.unReadCount!;
      ctx.state.unReadCount = unReadCount;
      ctx.broadcast(
          MainActionCreator.onUpdateUnReadCount(unReadInfo.unReadCount!));
      if (unReadInfo.result?.popup ?? false) {
        showDialog(
            context: ctx.context,
            builder: (context) {
              return ZenggeTextAlertDialog(
                unReadInfo.result!.content ?? '',
                titleText: unReadInfo.result!.title ?? '',
                enableCancel: true,
                confirmText: unReadInfo.result!.actionButton ?? '',
              );
            }).then((isConfirm) {
          if (isConfirm) {
            String targetName = unReadInfo.result!.actions ?? '';
            String type = unReadInfo.result!.actionType ?? '';
            String title = unReadInfo.result!.title ?? '';
            RoutesUtil.pushName(targetName, type: type, title: title);
          }
        });
      }
    }
  });
}

void _onMenuItemClick(Action action, Context<MainState> ctx) {
  MoreMenuItem menuItem = action.payload;

  RoutesUtil.pushName(menuItem.target ?? '',
      type: menuItem.type ?? '',
      needToken: menuItem.token ?? false,
      title: menuItem.name ?? '',
      content: menuItem.description ?? '');
}

void _onShowMenu(Action action, Context<MainState> ctx) {
  ctx.state.menuController?.forward();
  showPopWindow<Map<String, dynamic>?>(
      context: ctx.context,
      padding: const EdgeInsets.only(right: 8.0),
      direction: PopDirection.bottomRight,
      useAnimation: true,
      childWidth: categoryItemWidth,
      childHeight: ctx.state.menuInfo!.items!.length * categoryItemHeight,
      routeObserver: routeObserver,
      targetWidgetKey: ctx.state.showPopWinKey,
      child: Card(
        color: Colors.white,
        elevation: 6.0,
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.zero,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: ctx.state.menuInfo!.items!
                .map(
                  (e) => Container(
                    padding: const EdgeInsets.all(0.0),
                    height: categoryItemHeight,
                    width: categoryItemWidth,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(ctx.context).pop();
                          ctx.dispatch(MainActionCreator.onMenuItemClick(e));
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          children: [
                            LoadImage(
                              e.fileUrl!,
                              width: 30.0,
                              height: 30.0,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                                child: Text(
                              e.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      )).then((result) {
    print('result :$result');
    ctx.state.menuController?.reverse();
    if (result == null) return;
  });
}

Future<void> _onUpgrade(Action action, Context<MainState> ctx) async {
  if (Platform.isAndroid) {
    var appConfig = AppConfig.of(navigatorKey.currentContext!);
    var marketCode = appConfig.stringResource.marketCode;
    // final type = appConfig.appInternalId.name.toUpperCase();
    Map<String, dynamic> params;
    if (marketCode.isNotEmpty) {
      params = {'source': marketCode};
    } else {
      params = {};
    }
    var date1 = DateTime.now();
    print('upgrade http1 :$date1');

    ResultData result = await HttpManager.getInstance()
        .get(NetworkAddress.appUpgradeUrl, queryParameters: params);
    if (result.isSuccess) {
      var date2 = DateTime.now();
      print('upgrade http2 :$date2');
      try {
        var updateInfo = UpdateInfo.fromJson(result.data);
        if (updateInfo.appTypeName!
                .toUpperCase()
                .contains("Lite".toUpperCase()) &&
            (AppConfig.of(navigatorKey.currentContext!).isProApp != false)) {
          return;
        }

        if (updateInfo.appTypeName!
                .toUpperCase()
                .contains("pro".toUpperCase()) &&
            (AppConfig.of(navigatorKey.currentContext!).isProApp == false)) {
          return;
        }
        var packageInfo = await PackageInfo.fromPlatform();
        var buildNumber = int.parse(packageInfo.buildNumber);
        if (buildNumber < updateInfo.versionCode!) {
          if (updateInfo.status == 'ACTIVE') {
            if (((updateInfo.forceUpgrade ?? false) &&
                marketCode != 'GOOGLE')) {
              ctx.dispatch(MainActionCreator.onUpgradeApp(updateInfo));
            } else {
              var languageResource =
                  GlobalStore.store.getState().languageResource!;
              // var languageResource = ctx.state.languageResource;
              var result = await showDialog(
                  context: ctx.context,
                  builder: (context) {
                    return ZenggeTextAlertDialog(
                      '${languageResource.appVersion}：\n${updateInfo.description}',
                      titleText:
                          '${languageResource.versionAvailable} ${updateInfo.versionName ?? ''}',
                      enableCancel: true,
                      confirmText: languageResource.upgradeNow,
                      cancelText: languageResource.cancel,
                    );
                  });
              if (result != null && result) {
                if (marketCode == 'GOOGLE') {
                  launchUrlString(updateInfo.fileFullPath!);
                } else {
                  ctx.dispatch(MainActionCreator.onUpgradeApp(updateInfo));
                }

                return;
              }
            }
          }
        }
      } catch (error) {
        print('upgrade failure:$error');
      }
    } else {
      print('upgrade failure:${result.message}');
    }
  }
}

Future<void> _onUpgradeApp(Action action, Context<MainState> ctx) async {
  UpdateInfo updateInfo = action.payload;

  showDialog<bool>(
    context: ctx.context,
    builder: (BuildContext context) {
      return WillPopScope(
          child: SimpleDialog(
            contentPadding: const EdgeInsets.all(12.0),
            title: Text(
              'Updating…',
              style: TextStyle(color: Colors.grey[800]),
            ),
            children: <Widget>[
              UpgradeDialog(updateInfo.fileFullPath!),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
          onWillPop: () async => false);
    },
  ).then((val) {
    print(val);
  });
}

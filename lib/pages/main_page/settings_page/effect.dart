import 'dart:async';
import 'dart:convert';

import 'package:card_coin/app.dart';
import 'package:card_coin/bean/health_check_bean.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/card_base/bean/page_categroy_item.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/utils/runnable/bean/pin_code_info.dart';
import 'package:card_coin/utils/runnable/card_common_status_runnable.dart';
import 'package:card_coin/utils/runnable/create_pin_runnable.dart';
import 'package:card_coin/utils/runnable/query_pin_status_runnable.dart';
import 'package:card_coin/utils/runnable/unlock_card_runnable.dart';
import 'package:card_coin/utils/scan_util.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';

import 'action.dart';
import 'state.dart';

const String _settingsSideMenuCacheKey = 'wallet_settings_side_menu_cache_v1';
const String _settingsSideMenuCacheTimeKey =
    'wallet_settings_side_menu_cache_time_v1';
const Duration _settingsSideMenuCacheTtl = Duration(days: 1);
List<PageCategoryItem>? _cachedSettingsMenu;

Effect<SettingsState>? buildEffect() {
  return combineEffects(<Object, Effect<SettingsState>>{
    Lifecycle.initState: _onInit,
    SettingsAction.listItemClick: _onListItemClick,
    SettingsAction.createPinCode: _onCreatePinCode,
    SettingsAction.unlockCard: _onUnlockCard,
  });
}

Future<void> _onInit(Action action, Context<SettingsState> ctx) async {
  final Map<String, dynamic> params = {};
  final requestFuture = HttpManager.getInstance().get(
      NetworkAddress.advertisementPageCategorySide,
      queryParameters: params);

  bool hasVisibleData = ctx.state.list.isNotEmpty;

  if (!hasVisibleData && (_cachedSettingsMenu?.isNotEmpty ?? false)) {
    ctx.dispatch(SettingsActionCreator.onLoadSuccess(_cachedSettingsMenu!));
    hasVisibleData = true;
  }

  if (!hasVisibleData) {
    final isCacheValid = await _isSettingsMenuCacheValid();
    if (isCacheValid) {
      final cachedMenuJson =
          await LocalStorage.getString(_settingsSideMenuCacheKey);
      final cachedList = _parseSettingsMenu(cachedMenuJson);
      if (cachedList.isNotEmpty) {
        _cachedSettingsMenu = cachedList;
        ctx.dispatch(SettingsActionCreator.onLoadSuccess(cachedList));
        hasVisibleData = true;
      }
    }
  }

  final result = await requestFuture;
  if (result.isSuccess) {
    List buttons = result.data;
    List<PageCategoryItem> list =
        buttons.map((e) => PageCategoryItem.fromJson(e)).toList();
    _cachedSettingsMenu = list;
    ctx.dispatch(SettingsActionCreator.onLoadSuccess(list));
    unawaited(LocalStorage.saveString(_settingsSideMenuCacheKey,
        json.encode(list.map((e) => e.toJson()).toList())));
    unawaited(LocalStorage.saveString(_settingsSideMenuCacheTimeKey,
        DateTime.now().millisecondsSinceEpoch.toString()));
  } else {
    if (!hasVisibleData && ctx.state.list.isEmpty) {
      ctx.dispatch(SettingsActionCreator.onLoadFailure(result.message));
    }
  }
}

Future<bool> _isSettingsMenuCacheValid() async {
  final cachedTimeString =
      await LocalStorage.getString(_settingsSideMenuCacheTimeKey);
  final cachedTime = int.tryParse(cachedTimeString ?? '');
  if (cachedTime == null) {
    return false;
  }
  final cacheAge = DateTime.now().millisecondsSinceEpoch - cachedTime;
  return cacheAge <= _settingsSideMenuCacheTtl.inMilliseconds;
}

List<PageCategoryItem> _parseSettingsMenu(String? cachedMenuJson) {
  if (cachedMenuJson == null || cachedMenuJson.isEmpty) {
    return [];
  }
  try {
    final dynamic raw = json.decode(cachedMenuJson);
    if (raw is List) {
      return raw
          .whereType<Map<String, dynamic>>()
          .map((e) => PageCategoryItem.fromJson(e))
          .toList();
    }
  } catch (_) {}
  return [];
}

Future<void> _onListItemClick(Action action, Context<SettingsState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  PageCategoryItem menuItem = action.payload;
  print("menuItem:${menuItem.type}");
  if (menuItem.type != 'ACTIVITY') {
    return;
  }

  PageRoutes pageRoutes = AppRoute.global as PageRoutes;
  var canPush = pageRoutes.pages.keys.contains(menuItem.target);
  if (!canPush) {
    showToast(languageResource.getUnsupportActivity(menuItem.target ?? ''));
    return;
  }

  print("unlockPinCode-_onListItemClick");
  if (menuItem.target == 'setPinCodePage') {
    String? cardNo = await LocalStorage.getCardNo(ctx.state.cardId);
    print("objectToJson$cardNo");
    var response = await ScanUtil.chipScanWithRunnable(
        CardCommonStatusRunnable(),
        checkLock: true,
        expectedCardId: ctx.state.cardId,
        cardNo: cardNo);
    if (response.isSuccess) {
      if (response.data is CardHealthCommonStatus) {
        var healthStatus = response.data as CardHealthCommonStatus;
        if (healthStatus.isLock) {
          await showDialog(
              context: ctx.context,
              builder: (_) {
                return const ZenggeTextAlertDialog(
                  "Card is locked,please unlock the card first.",
                  enableCancel: false,
                  confirmText: "I know",
                  // cancelText: "Cancel",
                );
              });

          return;
        }
      }
      var pinCodeInfo = PinCodeInfo(
          isOpen: response.data!.pinSet, pinCount: response.data!.pinRemaining);
      Navigator.of(ctx.context).pushNamed('setPinCodePage',
          arguments: {'pinCodeInfo': pinCodeInfo, 'cardId': ctx.state.cardId});
    } else {
      if (response.message != "Session invalidated by user") {
        if (response.message!.length < 50) {
          await ScanUtil.unlockTip(response, ctx.context, ctx.state.cardId);
        }
      }
    }
  } else if (menuItem.target == 'unlockPinCodePage') {
    // ctx.dispatch(SettingsActionCreator.onUnlockCard());
    String? cardNo = await LocalStorage.getCardNo(ctx.state.cardId);
    var response = await ScanUtil.chipScanWithRunnable(QueryPinStatusRunnable(),
        checkLock: true, expectedCardId: ctx.state.cardId, cardNo: cardNo);
    print("unlockPinCode-response0000:${response.message}");
    if (response.isSuccess) {
      await showDialog(
          context: ctx.context,
          builder: (_) {
            return ZenggeTextAlertDialog(
              languageResource.notNeedUnlock,
              enableCancel: false,
              confirmText: "I know",
              // cancelText: "Cancel",
            );
          });
    } else {
      if (response.sw1 == 0xAA && response.sw2 == 0x23) {
        Navigator.of(ctx.context).pushNamed('unlockPinCodePage',
            arguments: {'cardId': ctx.state.cardId});
      } else {
        print("unlockPinCode-response:${response.message}");
        if (response.message != "Session invalidated by user") {
          showToast(response.message ?? '');
        }
      }
    }
  } else if (menuItem.target == 'deviceSettingsPage') {
    Navigator.of(ctx.context).pushNamed('deviceSettingsPage', arguments: {
      'cardId': ctx.state.cardId,
      'cardInfo': ctx.state.cardInfo
    });
  } else if (menuItem.target == 'backupDataPage') {
    Navigator.of(ctx.context).pushNamed('backupDataPage', arguments: {
      'cardId': ctx.state.cardId,
      'cardDetail': ctx.state.cardInfo.cardDetail!
    });
  } else if (menuItem.target == 'addressBookPage') {
    Navigator.of(ctx.context)
        .pushNamed('addressBookPage', arguments: {'cardId': ctx.state.cardId});
  } else if (menuItem.target == 'checkCardPage') {
    Navigator.of(ctx.context).pushNamed('checkCardPage', arguments: {
      'cardId': ctx.state.cardId,
      'cardInfo': ctx.state.cardInfo,
      'from': 0
    });
  } else if (menuItem.target == 'assetSettingsPage') {
    Navigator.of(ctx.context).pushNamed('assetSettingsPage',
        arguments: {'cardId': ctx.state.cardId});
  }
}

Future<void> _onCreatePinCode(Action action, Context<SettingsState> ctx) async {
  String? cardNo = await LocalStorage.getCardNo(ctx.state.cardId);
  var result = await ScanUtil.chipScanWithRunnable(
      CreatePinRunnable([1, 2, 3, 4, 5, 6]),
      expectedCardId: ctx.state.cardId,
      cardNo: cardNo);

  if (result.isSuccess) {
    print('puk:${result.data}');
  } else {
    if (result.message!.length < 50) {
      await ScanUtil.unlockTip(result, ctx.context, ctx.state.cardId);
    }
  }
}

Future<void> _onUnlockCard(Action action, Context<SettingsState> ctx) async {
  String? cardNo = await LocalStorage.getCardNo(ctx.state.cardId);
  var result = await ScanUtil.chipScanWithRunnable(
      UnlockCardRunnable(
          pukCode: [0x9B, 0x42, 0x62, 0x00, 0x3F, 0xBE, 0xEF, 0xDB],
          pinCode: [6, 5, 4, 3, 2, 1]),
      checkLock: true,
      expectedCardId: ctx.state.cardId,
      cardNo: cardNo);
  if (result.isSuccess) {
    print('puk:${result.data}');
  } else {
    print('error:${result.message}');
    if (result.message!.length < 50) {
      await ScanUtil.unlockTip(result, ctx.context, ctx.state.cardId);
    }
  }
}

import 'dart:convert';

import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/card_base/pages/settings_page/action.dart';
import 'package:card_coin/global_store/action.dart';
import 'package:card_coin/global_store/store.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/pages/app_version_page/bean/language_model.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'action.dart';
import 'state.dart';

// 与 AppVersionPage 共用同一份缓存 key
const _kLanguageListCacheKey = 'change_language_page_language_list_cache_v1';

Effect<ChangeLanguageState>? buildEffect() {
  return combineEffects(<Object, Effect<ChangeLanguageState>>{
    Lifecycle.initState: _onInit,
    ChangeLanguageAction.action: _onAction,
    ChangeLanguageAction.selectLan: _selectLan,
  });
}

Future<void> _onInit(Action action, Context<ChangeLanguageState> ctx) async {
  // 先读本地缓存，有数据则立即渲染（秒开）
  final cachedJson = await LocalStorage.getString(_kLanguageListCacheKey);
  if (cachedJson != null) {
    try {
      final List rawList = jsonDecode(cachedJson) as List;
      final languageList = rawList
          .map((e) => LanguageModel.fromJson(e as Map<String, dynamic>))
          .toList();
      ctx.dispatch(ChangeLanguageActionCreator.onLoadSuccess(languageList));
    } catch (_) {}
  }

  // 后台刷新，完成后更新界面及缓存
  final result =
      await HttpManager.getInstance().get(NetworkAddress.languageListUrl);
  if (result.isSuccess && result.data != null) {
    final List list = result.data as List;
    final languageList = list
        .map((e) => LanguageModel.fromJson(e as Map<String, dynamic>))
        .toList();
    await LocalStorage.saveString(_kLanguageListCacheKey, jsonEncode(list));
    ctx.dispatch(ChangeLanguageActionCreator.onLoadSuccess(languageList));
  } else if (cachedJson == null) {
    ctx.dispatch(ChangeLanguageActionCreator.onLoadFailure());
  }
}

void _onAction(Action action, Context<ChangeLanguageState> ctx) {}

Future<void> _selectLan(Action action, Context<ChangeLanguageState> ctx) async {
  int index = action.payload;
  var languageMode = ctx.state.languageList[index];
  var locale = languageMode.languageLocale;
  LocalStorage.saveLocale(locale);
  ctx.dispatch(SettingsActionCreator.onUpdateCurrentIndexLan(index));
  GlobalStore.store.dispatch(GlobalActionCreator.onChangeLanguage(locale));
  Navigator.of(ctx.context).pop();
}

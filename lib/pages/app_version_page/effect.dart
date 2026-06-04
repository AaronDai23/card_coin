import 'dart:convert';

import 'package:fish_redux/fish_redux.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../cache/local_storage.dart';
import '../../global_store/action.dart';
import '../../global_store/store.dart';
import '../../http/address.dart';
import '../../http/http_manager.dart';
import '../../http/result_data.dart';
import '../../utils/dialogs.dart';
import 'action.dart';
import 'bean/language_model.dart';
import 'state.dart';

const _kLanguageListCacheKey = 'app_version_page_language_list_cache_v1';

Effect<AppVersionState>? buildEffect() {
  return combineEffects(<Object, Effect<AppVersionState>>{
    Lifecycle.initState: _onInit,
    AppVersionAction.action: _onAction,
    AppVersionAction.selectLanguage: _onSelectLanguage
  });
}

Future<void> _onInit(Action action, Context<AppVersionState> ctx) async {
  // 并行获取本地数据（均为本地操作，速度快）
  final packageInfoFuture = PackageInfo.fromPlatform();
  final userInfoFuture = LocalStorage.getUserInfo();
  final cachedJsonFuture = LocalStorage.getString(_kLanguageListCacheKey);

  final packageInfo = await packageInfoFuture;
  final userInfo = await userInfoFuture;
  final cachedJson = await cachedJsonFuture;

  ctx.dispatch(AppVersionActionCreator.onInit(userInfo, packageInfo));

  // 有缓存 → 立即渲染，秒开
  if (cachedJson != null) {
    try {
      final List rawList = jsonDecode(cachedJson) as List;
      final languageList = rawList
          .map((e) => LanguageModel.fromJson(e as Map<String, dynamic>))
          .toList();
      ctx.dispatch(AppVersionActionCreator.onLoadSuccess(languageList));
    } catch (_) {}
  }

  // 后台静默刷新语言列表
  _fetchAndCacheLanguageList(ctx, showErrorIfNoCache: cachedJson == null);
}

Future<void> _fetchAndCacheLanguageList(
  Context<AppVersionState> ctx, {
  bool showErrorIfNoCache = false,
}) async {
  final ResultData result =
      await HttpManager.getInstance().get(NetworkAddress.languageListUrl);
  if (result.isSuccess && result.data != null) {
    final List list = result.data as List;
    final languageList = list
        .map((e) => LanguageModel.fromJson(e as Map<String, dynamic>))
        .toList();
    // 更新缓存
    await LocalStorage.saveString(_kLanguageListCacheKey, jsonEncode(list));
    ctx.dispatch(AppVersionActionCreator.onLoadSuccess(languageList));
  } else if (showErrorIfNoCache) {
    ctx.dispatch(AppVersionActionCreator.onLoadFailure(result.message));
  }
}

void _onAction(Action action, Context<AppVersionState> ctx) {}

Future<void> _onSelectLanguage(
    Action action, Context<AppVersionState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  List<String> items =
      ctx.state.languageList.map((e) => e.localeName ?? '').toList();
  String curLange = ctx.state.languageList[ctx.state.currentIndex].localeName!;
  var selectIndex = await Dialogs.showListTitle(
      ctx.context, languageResource.changeLanguage, items,
      selected: curLange);
  if (selectIndex != null) {
    var languageMode = ctx.state.languageList[selectIndex];
    var locale = languageMode.languageLocale;
    LocalStorage.saveLocale(locale);
    ctx.dispatch(AppVersionActionCreator.onUpdateCurrentIndex(selectIndex));
    GlobalStore.store.dispatch(GlobalActionCreator.onChangeLanguage(locale));
  }
}

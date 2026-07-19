import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:card_coin/cache/bean/user_info_bean.dart';
import 'package:card_coin/pages/app_version_page/bean/language_model.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart' hide Action;
import 'package:flutter/material.dart' hide Action;
import 'package:image_compression/image_compression.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import '../../../app.dart';
import '../../../cache/local_storage.dart';
import '../../../common/common_action/action.dart';
import '../../../custom_widget/progress_dialog/progress_dialog.dart';
import '../../../http/address.dart';
import '../../../http/http_manager.dart';
import '../../../utils/dialogs.dart';
import '../../bean/link_bean.dart';
import '../../bean/page_categroy_item.dart';
import '../../widgets/count_down_button.dart';
import '../../widgets/show_zengge_bottom_sheet.dart';
import 'action.dart';
import 'state.dart';

const String _settingsSideMenuCacheKey = 'cardbase_settings_side_menu_cache_v1';

Effect<SettingsState>? buildEffect() {
  return combineEffects(<Object, Effect<SettingsState>>{
    SettingsAction.loginOutClick: _onLoginOutClick,
    SettingsAction.itemClick: _onItemClick,
    SettingsAction.editNameClick: _onEditNameClick,
    SettingsAction.editAvatarClick: _onEditAvatarClick,
    Lifecycle.initState: _onInit,
    CommonAction.languageChanged: _onInit,
    SettingsAction.loadData: _onInit,
    SettingsAction.cancelAccount: _onCancelAccount,
    SettingsAction.networkCheck: _onNetworkCheck,
    SettingsAction.writeNtag: _onWriteNtag,
  });
}

Future<void> _onInit(Action action, Context<SettingsState> ctx) async {
  Map<String, dynamic> params = {};

  // 先尝试用本地缓存秒开页面，避免等待加密请求导致首屏白等。
  bool hasCachedMenu = false;
  final String? cachedMenuJson =
      await LocalStorage.getString(_settingsSideMenuCacheKey);
  if (cachedMenuJson != null && cachedMenuJson.isNotEmpty) {
    try {
      final dynamic raw = json.decode(cachedMenuJson);
      if (raw is List) {
        final List<PageCategoryItem> cachedList = raw
            .whereType<Map<String, dynamic>>()
            .map((e) => PageCategoryItem.fromJson(e))
            .toList();
        if (cachedList.isNotEmpty) {
          hasCachedMenu = true;
          ctx.dispatch(SettingsActionCreator.onLoadSuccess(cachedList));
        }
      }
    } catch (_) {}
  }

  // 首屏只等待菜单接口，尽快可见；非关键数据在后台增量更新。
  var menuResult = await HttpManager.getInstance()
      .get(NetworkAddress.pageCategorySideUrl, queryParameters: params);
  if (menuResult.isSuccess) {
    List buttons = menuResult.data;
    List<PageCategoryItem> list =
        buttons.map((e) => PageCategoryItem.fromJson(e)).toList();
    // 刷新成功后落地缓存，供下次秒开。
    unawaited(LocalStorage.saveString(_settingsSideMenuCacheKey,
        json.encode(list.map((e) => e.toJson()).toList())));
    ctx.dispatch(SettingsActionCreator.onLoadSuccess(list));
  } else {
    // 已有缓存时不切到失败页，避免从已可见页面回退到错误态。
    if (!hasCachedMenu) {
      ctx.dispatch(SettingsActionCreator.onLoadFailure(menuResult.message));
    }
  }

  _loadSettingsNonCriticalData(ctx);
}

void _loadSettingsNonCriticalData(Context<SettingsState> ctx) {
  final Map<String, dynamic> params = {};

  HttpManager.getInstance()
      .post(NetworkAddress.domainUrl, null, data: params)
      .then((domainResult) {
    if (domainResult.isSuccess && domainResult.data != null) {
      var domainResponse = LinkDomainResponse.fromJson(domainResult.data);
      ctx.state.domain = domainResponse.domain ?? '';
    }
  }).catchError((_) {});

  HttpManager.getInstance()
      .get(NetworkAddress.languageListUrl)
      .then((languageResult) {
    if (languageResult.isSuccess && languageResult.data != null) {
      List list = languageResult.data;
      var languageList = list.map((e) => LanguageModel.fromJson(e)).toList();
      int index = languageList.indexWhere((element) =>
          element.languageCode == ctx.state.languageLocale!.languageCode);
      if (index < 0) {
        index = 0;
      }
      ctx.state.currentIndexLan = index;
      ctx.state.languageList = languageList;
      ctx.dispatch(SettingsActionCreator.onUpdateCurrentIndexLan(index));
    }
  }).catchError((_) {});
}

Future<void> _onNetworkCheck(Action action, Context<SettingsState> ctx) async {
  Navigator.of(ctx.context).pushNamed('networkCheckPage');
}

Future<void> _onWriteNtag(Action action, Context<SettingsState> ctx) async {
  Navigator.of(ctx.context).pushNamed('writeNtagPage');
}

Future<void> _onEditNameClick(Action action, Context<SettingsState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  var nickName = await showDialog(
      context: ctx.context,
      builder: (_) {
        return ZenggeInputAlertDialog(
          titleText: languageResource.updateNickname,
          initText: ctx.state.userInfo.customer?.nickName ?? '',
          maxLength: 50,
          enableCancel: true,
        );
      });
  if (nickName != null) {
    ProgressDialog pr = ProgressDialog(ctx.context);
    pr.showNoMask();
    var result = await HttpManager.getInstance().post(
        NetworkAddress.updateNicknameUrl, null,
        data: {'nickName': nickName});
    pr.hide();
    if (result.isSuccess) {
      var userInfo = LocalStorage.getCacheUserInfo()!;
      userInfo.customer!.nickName = nickName;
      LocalStorage.saveUserInfo(userInfo);
      ctx.dispatch(SettingsActionCreator.onRefreshUserInfo(userInfo));
    } else {
      showToast(result.message);
    }
  }
}

Future<void> _onEditAvatarClick(
    Action action, Context<SettingsState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  int? index = await showMenuSelectBottomSheet(
    context: ctx.context,
    list: [
      Text(
        languageResource.ablumn,
      ),
      Text(
        languageResource.takePhoto,
      )
    ],
  );

  ImageSource imageSource;
  if (index != null) {
    if (index == 0) {
      imageSource = ImageSource.gallery;
    } else if (index == 1) {
      imageSource = ImageSource.camera;
    } else {
      return;
    }
  } else {
    return;
  }

  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: imageSource);
  if (image != null) {
    final file = File(image.path);

    var aspectRatio = 1.0;

    var cropImage = await Navigator.of(ctx.context).pushNamed('cropImagePage',
        arguments: {"file": file, 'aspectRatio': aspectRatio});

    if (cropImage != null) {
      String imageUrl = cropImage as String;

      var imageFile = File(imageUrl);
      final logoInput = ImageFile(
        rawBytes: imageFile.readAsBytesSync(),
        filePath: imageFile.path,
      );
      final logoOutput =
          await compressInQueue(ImageFileConfiguration(input: logoInput));
      final logoImageData = base64Encode(logoOutput.rawBytes);
      ProgressDialog pr = ProgressDialog(ctx.context);
      pr.showNoMask();
      var result = await HttpManager.getInstance()
          .post(NetworkAddress.avatarLinkUrl, null, data: logoImageData);
      pr.hide();
      if (result.isSuccess) {
        String imagePath = result.data;
        var userInfo = LocalStorage.getCacheUserInfo()!;
        userInfo.customer?.avatar = imagePath;
        LocalStorage.saveUserInfo(userInfo);
        ctx.dispatch(SettingsActionCreator.onRefreshUserInfo(userInfo));
      } else {
        showToast(result.message);
      }
    }
  }
}

Future<void> _onItemClick(Action action, Context<SettingsState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  PageCategoryItem menuItem = action.payload;
  print("menuItem:${menuItem.type}");
  if (menuItem.type == 'ACTIVITY') {
    PageRoutes pageRoutes = AppRoute.global as PageRoutes;
    var canPush = pageRoutes.pages.keys.contains(menuItem.target);
    if (canPush) {
      print("menuItem-target:${menuItem.target}");
      Navigator.of(ctx.context).pushNamed(menuItem.target ?? '',
          arguments: {'title': menuItem.name}).then((value) {
        if (value is UserInfo) {
          ctx.dispatch(SettingsActionCreator.onRefreshUserInfo(value));
          ctx.dispatch(SettingsActionCreator.onLoadData());
        }
      });
    } else {
      showToast(languageResource.getUnsupportActivity(menuItem.target ?? ''));
    }
  } else if (menuItem.type == 'HREF') {
    var uri = Uri.tryParse(menuItem.target!);
    if (uri != null) {
      String pageUrl = menuItem.target!;
      if (menuItem.token ?? false) {
        var userInfo = LocalStorage.getCacheUserInfo();
        if (menuItem.target!.contains("?")) {
          pageUrl = '$pageUrl&token=${userInfo?.accessToken ?? ''}';
        } else {
          pageUrl = '$pageUrl?token=${userInfo?.accessToken ?? ''}';
        }
      }
      Navigator.of(ctx.context).pushNamed('webviewPage',
          arguments: {'pageUrl': pageUrl, 'title': menuItem.name});
    } else {
      showToast(languageResource.linkFormatError);
    }
  } else if (menuItem.type == 'LANGUAGE') {
    ctx.dispatch(SettingsActionCreator.onSelectLanguage());
  }
}

Future<void> _onCancelAccount(Action action, Context<SettingsState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  var result = await showDialog(
      barrierDismissible: false,
      context: ctx.context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: CupertinoAlertDialog(
            title: Text(
              languageResource.tip,
              style: TextStyle(color: Colors.grey[800]),
            ),
            content: Text(
              languageResource.cancelAccountTip,
              style: TextStyle(color: Colors.grey[800]),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  languageResource.cancel,
                  style: TextStyle(color: Colors.grey[800]),
                ),
                onPressed: () {
                  //关闭对话框并返回true
                  Navigator.of(context).pop();
                },
              ),
              CountDownButton(
                text: languageResource.confirm,
                onPressed: () {
                  //关闭对话框并返回true
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      });

  if (result == true) {
    ProgressDialog pr = ProgressDialog(ctx.context);
    await pr.show();
    var cancelResult = await HttpManager.getInstance()
        .post(NetworkAddress.cancellationAccountUrl, null);
    pr.hide();
    if (cancelResult.isSuccess) {
      LocalStorage.cleanUserInfo();
      ctx.broadcast(CommonActionCreator.onLoginOut());
      Navigator.pushNamedAndRemoveUntil(
          ctx.context, 'scanLoginPage', (route) => false);
    } else {
      showToast(cancelResult.message);
    }
  }
}

void _onLoginOutClick(Action action, Context<SettingsState> ctx) async {
  var result = await Dialogs.showHintDialog(
    "Login Out",
    "Sure to login out?",
    ctx.context,
  );
  if (result == true) {
    LocalStorage.cleanUserInfo();
    ctx.broadcast(CommonActionCreator.onLoginOut());
    Navigator.pushNamedAndRemoveUntil(
        ctx.context, 'scanLoginPage', (route) => false);
  }
}

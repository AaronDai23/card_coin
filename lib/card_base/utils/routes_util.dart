import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../../app.dart';
import '../../cache/local_storage.dart';
import '../../generated/l10n.dart';
import '../../widget/custom_alert_dialog.dart';

enum RoutePageType { activity, href }

class RoutesUtil {
  ///  [type] 页面类型 ACTIVITY:原生页面    HREF：Webveiw页面
  static Future<void> pushName(String targetName,
      {required String type,
      bool needToken = false,
      String title = '',
      String content = '',
      bool isReplace = false}) async {
    if (type == 'ACTIVITY') {
      PageRoutes pageRoutes = AppRoute.global as PageRoutes;
      var canPush = pageRoutes.pages.keys.contains(targetName);
      if (canPush) {
        if (isReplace) {
          Navigator.of(navigatorKey.currentContext!)
              .pushReplacementNamed(targetName);
        } else {
          await Navigator.of(navigatorKey.currentContext!)
              .pushNamed(targetName, arguments: {'title': title});
        }
      } else {
        showToast(S.current.unsupportActivity(targetName));
      }
    } else if (type == 'HREF') {
      var uri = Uri.tryParse(targetName);
      if (uri != null) {
        String pageUrl = targetName;
        if (needToken) {
          var userInfo = LocalStorage.getCacheUserInfo();
          if (pageUrl.contains("?")) {
            pageUrl = '$pageUrl&token=${userInfo?.accessToken ?? ''}';
          } else {
            pageUrl = '$pageUrl?token=${userInfo?.accessToken ?? ''}';
          }
        }
        Navigator.of(navigatorKey.currentContext!).pushNamed('webviewPage',
            arguments: {'pageUrl': pageUrl, 'title': title});
      } else {
        showToast(S.current.linkFormatError);
      }
    } else if (type == 'POPUP') {
      showDialog(
          context: navigatorKey.currentContext!,
          builder: (_) {
            return ZenggeTextAlertDialog(
              content,
              titleText: title,
            );
          });
    } else if (type == 'RICH_TEXT') {
      Navigator.of(navigatorKey.currentContext!).pushNamed('htmlTextPage',
          arguments: {'title': title, 'textContent': content});
    }
  }
}

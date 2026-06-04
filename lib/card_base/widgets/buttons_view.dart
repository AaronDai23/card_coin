import 'dart:convert';

import 'package:card_coin/global_store/state.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:oktoast/oktoast.dart';

import '../../app.dart';
import '../../cache/local_storage.dart';
import '../../global_store/store.dart';
import '../bean/page_button_info.dart';

class ButtonsView extends StatefulWidget {
  final String routeName;

  const ButtonsView({Key? key, required this.routeName}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ButtonsViewState();
  }
}

class _ButtonsViewState extends State<ButtonsView> {
  PageButtonInfo? _pageButtonInfo;

  @override
  void initState() {
    List<PageButtonInfo>? buttons = LocalStorage.getCacheButtonList();
    if (buttons?.isNotEmpty ?? false) {
      _pageButtonInfo = buttons!
          .firstWhereOrNull((element) => element.activity == widget.routeName);
    }
    super.initState();
  }

  _buttonClick(ButtonItem buttonItem) {
    if (buttonItem.targetType == 'ACTIVITY') {
      PageRoutes pageRoutes = AppRoute.global as PageRoutes;
      var canPush = pageRoutes.pages.keys.contains(buttonItem.target);
      if (canPush) {
        Navigator.of(context).pushNamed(buttonItem.target ?? '');
      } else {
        GlobalState globalState = GlobalStore.store.getState();
        showToast(globalState.languageResource!.getUnsupportActivity(buttonItem.target??''));
      }
    } else if (buttonItem.targetType == 'HREF') {
      var uri = Uri.tryParse(buttonItem.target!);
      if (uri != null) {
        String pageUrl = buttonItem.target!;
        if (buttonItem.token ?? false) {
          var userInfo = LocalStorage.getCacheUserInfo();
          if (buttonItem.target!.contains("?")) {
            pageUrl = '$pageUrl&token=${userInfo?.accessToken ?? ''}';
          } else {
            pageUrl = '$pageUrl?token=${userInfo?.accessToken ?? ''}';
          }
        }
        Navigator.of(context).pushNamed('webviewPage',
            arguments: {'pageUrl': pageUrl, 'title': buttonItem.name});
      } else {
        GlobalState globalState = GlobalStore.store.getState();
        showToast(globalState.languageResource!.linkFormatError);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pageButtonInfo != null) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: _pageButtonInfo!.buttons!.map((e) {
            print('pageButtonInfo:${json.encode(e.toJson())}');

            String colorStr =
                '0xFF${e.backgroundColor?.substring(1) ?? '000000'}';
            double border = double.parse(e.border ?? '0.0');
            Color backgroundColor = Color(int.parse(colorStr));
            double radius;
            if (e.shape == 'RECTANGLE') {
              radius = 6.0;
            } else {
              radius = 30.0;
            }

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                    onPressed: () => _buttonClick(e),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                            side: border == 0
                                ? BorderSide.none
                                : BorderSide(width: double.parse(e.border ?? '0')),
                            borderRadius: BorderRadius.circular(radius))),
                    child: Text(e.name ?? "")),
              ),
            );
          }).toList(),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}

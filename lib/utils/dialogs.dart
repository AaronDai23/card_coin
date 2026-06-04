import 'package:card_coin/utils/string_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

import '../global_store/state.dart';
import '../global_store/states/app_language_resource.dart';
import '../global_store/store.dart';

class Dialogs {
  static Widget warningDialog(BuildContext context, String content,
      VoidCallback onConfirm, VoidCallback onCancel) {
    GlobalState globalState = GlobalStore.store.getState();
    return CupertinoAlertDialog(
        title: Image.asset(
          "assets/images/warning.png",
          width: 48,
          height: 48,
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Column(
            children: <Widget>[
              Text(
                content,
                style: TextStyle(color: Colors.grey[800], fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          CupertinoButton(
            onPressed: onConfirm,
            child: Text(
              globalState.languageResource!.confirm,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          CupertinoButton(
            onPressed: onCancel,
            child: Text(
              globalState.languageResource!.cancel,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ]);
  }

  static Future<int?> showListTitle(
      BuildContext context, String title, List<String> items,
      {String? selected}) {
    return showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Text(title, style: TextStyle(color: Colors.grey[800])),
              children: items.map((item) {
                return SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, items.indexOf(item));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: selected == item
                        ? Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(item,
                                    style: TextStyle(color: Colors.grey[800])),
                              ),
                              Icon(
                                Icons.done,
                                color: Colors.grey[800],
                              ),
                              const SizedBox(
                                width: 20,
                              )
                            ],
                          )
                        : Text(item, style: TextStyle(color: Colors.grey[800])),
                  ),
                );
              }).toList());
        });
  }

  static Future<int?> showListIconTitle(
      BuildContext context, String title, List<String> items,
      {String? selected}) {
    return showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Text(title, style: TextStyle(color: Colors.grey[800])),
              children: items.map((item) {
                return SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, items.indexOf(item));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: selected == item
                        ? Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(item,
                                    style: TextStyle(color: Colors.grey[800])),
                              ),
                              Icon(
                                Icons.done,
                                color: Colors.grey[800],
                              ),
                              const SizedBox(
                                width: 20,
                              )
                            ],
                          )
                        : Text(item, style: TextStyle(color: Colors.grey[800])),
                  ),
                );
              }).toList());
        });
  }

  static Future<T?> showWidgetDialog<T>(
      {required String title,
      required BuildContext context,
      required Widget content,
      String? yesBtnTxt}) {
    return showDialog<T>(
      context: context,
      builder: (context) {
        GlobalState globalState = GlobalStore.store.getState();
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: TextStyle(color: Colors.grey[800]),
          ),
          content: content,
          actions: <Widget>[
            TextButton(
              child: Text(
                globalState.languageResource!.cancel,
                style: TextStyle(color: Colors.grey[800]),
              ),
              onPressed: () => Navigator.of(context).pop(false), // 关闭对话框
            ),
            TextButton(
              child: Text(
                yesBtnTxt ?? globalState.languageResource!.confirm,
                style: TextStyle(color: Colors.grey[800]),
              ),
              onPressed: () {
                //关闭对话框并返回true
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> showHintDialog(
      String title, String content, BuildContext context) {
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        GlobalState globalState = GlobalStore.store.getState();
        return WillPopScope(
          onWillPop: () async => false,
          child: CupertinoAlertDialog(
            title: Text(
              title,
              style: TextStyle(color: Colors.grey[800]),
            ),
            content: Text(
              content,
              style: TextStyle(color: Colors.grey[800]),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  globalState.languageResource!.cancel,
                  style: TextStyle(color: Colors.grey[800]),
                ),
                onPressed: () {
                  //关闭对话框并返回true
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  globalState.languageResource!.confirm,
                  style: TextStyle(color: Colors.grey[800]),
                ),
                onPressed: () {
                  //关闭对话框并返回true
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<String?> showInputDialog(
      {required BuildContext context,
      String initText = '',
      required int maxLength,
      bool digitsOnly = false,
      MaxLengthEnforcement maxLengthEnforcement =
          MaxLengthEnforcement.enforced}) {
    final controller = TextEditingController()..text = initText;
    String? errorText;
    return showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            child: StatefulBuilder(
              builder: (_, setState) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DefaultTextStyle(
                      style: DialogTheme.of(context).titleTextStyle ??
                          Theme.of(context).textTheme.titleMedium!,
                      child: Semantics(
                        child: const Text("其它金额"),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: TextField(
                          maxLength: maxLength,
                          keyboardType: TextInputType.number,
                          maxLengthEnforcement: maxLengthEnforcement,
                          inputFormatters: digitsOnly
                              ? [FilteringTextInputFormatter.digitsOnly]
                              : null,
                          autofocus: true,
                          onChanged: (value) {
                            if (errorText != null && value.isNotEmpty) {
                              setState(() => errorText = null);
                            }
                          },
                          controller: controller,
                          decoration: InputDecoration(
                              errorText: errorText, hintText: '请输入金额'),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("取消")),
                        TextButton(
                            onPressed: () {
                              if (controller.text.isEmpty) {
                                setState(() => errorText = "金额不能为空");
                                return;
                              }
                              Navigator.of(context).pop(controller.text);
                            },
                            child: const Text("确定")),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Future<String?> showNickInputDialog(
      {required AppLanguageResource languageResource,
      required BuildContext context,
      String initText = '',
      required int maxLength,
      bool digitsOnly = false,
      MaxLengthEnforcement maxLengthEnforcement =
          MaxLengthEnforcement.enforced}) {
    final controller = TextEditingController()..text = initText;
    String? errorText;
    return showDialog(
        context: context,
        builder: (_) {
          var walletNickName = languageResource.walletNickName;
          var inputWalletNickName = languageResource.pleaseInputWalletNickName;
          return Dialog(
            child: StatefulBuilder(
              builder: (_, setState) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DefaultTextStyle(
                      style: DialogTheme.of(context).titleTextStyle ??
                          Theme.of(context).textTheme.titleLarge!,
                      child: Semantics(
                        child: Text(walletNickName),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: TextField(
                          maxLength: maxLength,
                          keyboardType: TextInputType.text,
                          maxLengthEnforcement: maxLengthEnforcement,
                          inputFormatters: digitsOnly
                              ? [FilteringTextInputFormatter.digitsOnly]
                              : null,
                          autofocus: true,
                          onChanged: (value) {
                            if (errorText != null && value.isNotEmpty) {
                              setState(() => errorText = null);
                            }
                          },
                          controller: controller,
                          decoration: InputDecoration(
                              errorText: errorText,
                              hintText: inputWalletNickName),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(languageResource.cancel)),
                        TextButton(
                            onPressed: () {
                              if (controller.text.isEmpty) {
                                setState(() => errorText =
                                    languageResource.nickNameEmptyTip);
                                return;
                              }
                              Navigator.of(context).pop(controller.text);
                            },
                            child: Text(languageResource.confirm)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  /// 弹出输入 PIN 的对话框，并返回 List<int>
  /// 返回 null 表示用户取消
  static Future<List<int>?> showPinInputDialog({
    required AppLanguageResource languageResource,
    required BuildContext context,
    required String title,
    String? hint,
  }) async {
    // 弹出对话框
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return _PinInputDialog(
          title: title,
          hint: hint ?? 'Please enter Pin code',
          languageResource: languageResource,
        );
      },
    );

    // 用户取消
    if (result == null || result.isEmpty) return null;

    // 转 List<int>
    final List<int> pinCode =
        result.split('').map((e) => int.parse(e)).toList();

    String pinCodeStr = pinCode.join();

    if (pinCodeStr.isEmpty) {
      showToast(languageResource.enterPukCode);
      return [];
    }

    if (pinCodeStr.length != 6) {
      showToast(languageResource.pinCodeDigitsTips);
      return [];
    }

    if (!StringUtils.isNumeric(pinCodeStr)) {
      showToast(languageResource.pinCodeNumTips);
      return [];
    }
    return pinCode;
  }
}

/////////==================私有 Pin 输入对话框 =============/////////
class _PinInputDialog extends StatefulWidget {
  final String title;
  final String hint;
  final AppLanguageResource languageResource;

  const _PinInputDialog({
    Key? key,
    required this.title,
    required this.hint,
    required this.languageResource,
  }) : super(key: key);

  @override
  State<_PinInputDialog> createState() => _PinInputDialogState();
}

class _PinInputDialogState extends State<_PinInputDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _obscureText = true; // 默认隐藏

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        obscureText: _obscureText,
        decoration: InputDecoration(
          hintText: widget.hint,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.languageResource.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: Text(widget.languageResource.confirm),
        ),
      ],
    );
  }
}

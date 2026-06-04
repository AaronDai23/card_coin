import 'package:card_coin/global_store/store.dart';
import 'package:flutter/material.dart';

class _DialogContainer extends StatelessWidget {
  final String titleText;
  final String subTitleText;
  final InlineSpan? subTitleSpan;
  final String confirmText;
  final String cancelText;
  final Widget content;
  final bool enableCancel;
  final bool enableActions;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const _DialogContainer(
      {this.titleText = '',
      this.enableCancel = false,
      this.enableActions = true,
      this.onConfirm,
      this.onCancel,
      this.subTitleText = '',
      this.subTitleSpan,
      this.confirmText = '',
      this.cancelText = '',
      required this.content});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    var languageResource = GlobalStore.store.getState().languageResource!;
    return AlertDialog(
      insetPadding:
          const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      title: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (titleText.isNotEmpty)
              Text(
                titleText,
                style: const TextStyle(fontSize: 18.0),
              ),
            if (titleText.isNotEmpty &&
                (subTitleText.isNotEmpty || subTitleSpan != null))
              const SizedBox(height: 8),
            if (subTitleSpan != null)
              Text.rich(subTitleSpan!)
            else if (subTitleText.isNotEmpty)
              Text(
                subTitleText,
                style: themeData.textTheme.titleSmall
                    ?.copyWith(color: Colors.grey),
              ),
          ],
        ),
      ),
      semanticLabel: '',
      content: content,
      actions: enableActions
          ? [
              Visibility(
                  visible: enableCancel,
                  child: TextButton(
                    onPressed: () => onCancel == null
                        ? Navigator.of(context).pop()
                        : onCancel?.call(),
                    child: Text(cancelText == ''
                        ? languageResource.cancel
                        : cancelText),
                  )),
              TextButton(
                  onPressed: () => onConfirm?.call(),
                  child: Text(confirmText == ''
                      ? languageResource.confirm
                      : confirmText))
            ]
          : null,
    );
  }
}

class ZenggeTextAlertDialog extends StatelessWidget {
  final String? titleText;
  final String subTitleText;
  final TextSpan? subTitleSpan;
  final bool enableCancel;
  final String contentText;
  final String textButtonText;
  final String confirmText;
  final String cancelText;
  final bool enableActions;
  final VoidCallback? onTextButtonClick;

  const ZenggeTextAlertDialog(this.contentText,
      {super.key,
      this.titleText,
      this.subTitleText = '',
      this.subTitleSpan,
      this.confirmText = '',
      this.cancelText = '',
      this.textButtonText = '',
      this.enableCancel = false,
      this.enableActions = true,
      this.onTextButtonClick});

  @override
  Widget build(BuildContext context) {
    String title;
    if (titleText == null) {
      var languageResource = GlobalStore.store.getState().languageResource!;
      title = languageResource.tip;
    } else {
      title = titleText!;
    }

    return _DialogContainer(
        titleText: title,
        subTitleText: subTitleText,
        enableActions: enableActions,
        enableCancel: enableCancel,
        confirmText: confirmText,
        cancelText: cancelText,
        subTitleSpan: subTitleSpan,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contentText,
                style: const TextStyle(color: Colors.grey),
              ),
              Visibility(
                  visible: onTextButtonClick != null,
                  child: TextButton(
                    onPressed: () => onTextButtonClick?.call(),
                    child: Text(textButtonText),
                  ))
            ],
          ),
        ));
  }
}

class ZenggeInputAlertDialog extends StatefulWidget {
  final String titleText;
  final String subTitleText;
  final String initText;
  final String? hintText;
  final bool enableCancel;
  final int? maxLength;
  final TextInputType? keyboardType;
  final bool enableInputEmpty;

  const ZenggeInputAlertDialog(
      {super.key,
      required this.titleText,
      this.maxLength,
      this.keyboardType,
      this.initText = '',
      this.subTitleText = '',
      this.hintText,
      this.enableCancel = false,
      this.enableInputEmpty = false});

  @override
  State<StatefulWidget> createState() {
    return _ZenggeInputAlertDialogState();
  }
}

class _ZenggeInputAlertDialogState extends State<ZenggeInputAlertDialog> {
  late TextEditingController controller;
  final FocusNode _focusNode = FocusNode();
  String _lastText = '';
  bool _isDeleting = false;
  String? errorText;
  String content = "";

  @override
  void initState() {
    controller = TextEditingController(text: widget.initText);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTextChanged(String text) {
    setState(() {
      if (widget.maxLength != null && text.length >= widget.maxLength!) {
        errorText = 'The maximum number of characters';
      } else {
        if (errorText != null) {
          errorText = null;
        }
      }
    });
    if (text.length < _lastText.length) {
      // Detect deletion
      if (!_isDeleting) {
        _isDeleting = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          _isDeleting = false;
        });
      } else {
        // Prevent deletion if it's too fast
        controller.text = _lastText;
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
      }
    }
    _lastText = text;
  }

  @override
  Widget build(BuildContext context) {
    // 在需要弹出键盘的地方使用这个配置

    return Container(
      child: _DialogContainer(
          titleText: widget.titleText,
          subTitleText: widget.subTitleText,
          enableCancel: widget.enableCancel,
          onConfirm: () {
            if (!widget.enableInputEmpty && controller.text.trim().isEmpty) {
              setState(() {
                errorText = 'Please enter content';
              });
              return;
            }
            Navigator.of(context).pop(controller.text);
          },
          // onCancel: (){
          //   Navigator.of(context).pop();
          // },
          content: TextField(
            autofocus: true,
            controller: controller,
            maxLength: widget.maxLength,
            keyboardType: widget.keyboardType,
            focusNode: _focusNode,
            onChanged: _handleTextChanged,
            // inputFormatters: [
            //   RegexFormatter(regex: RegexUtil.regexFirstNotNull),
            // ],
            style: const TextStyle(color: Colors.grey),
            decoration: InputDecoration(
              errorText: errorText,
              hintText: widget.hintText,
              counterText: widget.maxLength == null
                  ? ""
                  : (controller.text.isEmpty
                      ? ""
                      : " ${controller.text.length}/${widget.maxLength!}"),
            ),
          )),
    );
  }
}

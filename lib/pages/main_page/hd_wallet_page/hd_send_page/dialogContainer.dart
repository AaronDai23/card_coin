import 'package:flutter/material.dart';

class DialogContainer extends StatelessWidget {
  final String titleText;
  final String confirmText;
  final String cancelText;
  final Widget content;
  final bool enableCancel;
  final bool enableActions;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const DialogContainer(
      {super.key,
      this.titleText = '',
      this.enableCancel = true,
      this.enableActions = true,
      this.onConfirm,
      this.onCancel,
      this.confirmText = '',
      this.cancelText = '',
      required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding:
          const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      title: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: titleText != '',
                child: Text(titleText, style: const TextStyle(fontSize: 20.0))),
            const SizedBox(
              height: 8.0,
            )
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
                    child: Text(cancelText == '' ? 'Cancel' : cancelText),
                  )),
              TextButton(
                  onPressed: () => onConfirm?.call(),
                  child: Text(confirmText == '' ? 'Confirm' : confirmText))
            ]
          : null,
    );
  }
}

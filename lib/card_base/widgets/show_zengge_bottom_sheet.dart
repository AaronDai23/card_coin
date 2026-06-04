import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'custom_bottom_dialog.dart';

void showCustomBottomSheet({
  required BuildContext context,
  required List<Widget> children,
  bool enableActionButton = false,
  String buttonText = '',
  String title = '',
  VoidCallback? onBacktrack,
  VoidCallback? onConfirm,
  bool isHideHeader = false,
}) {
  showMaterialModalBottomSheet(
      context: context,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.8),
      backgroundColor: Colors.transparent,
      builder: (_) {
        return NormalCustomListBottomSheet(
          controller: ModalScrollController.of(context),
          context: context,
          isHideHeader: isHideHeader,
          title: title,
          onBacktrack: onBacktrack,
          onConfirm: onConfirm,
          enableActionButton: enableActionButton,
          buttonText: buttonText,
          children: children,
        );
      });
}

void showSingleChoiceBottomSheet(
    {required BuildContext context,
    required List<String> list,
    int? initIndex,
    bool enableActionButton = false,
    String buttonText = '',
    String title = '',
    ValueChanged<int?>? onConfirm,
    ValueChanged<int?>? onRadioValueChanged}) {
  showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.8),
      builder: (_) {
        return NormalSingleChoiceBottomSheet(
          title: title,
          initIndex: initIndex,
          enableActionButton: enableActionButton,
          controller: ModalScrollController.of(context),
          context: context,
          onConfirm: onConfirm,
          onRadioValueChanged: onRadioValueChanged,
          buttonText: buttonText,
          list: list,
        );
      });
}

void showMultiSelectBottomSheet({
  required BuildContext context,
  required List<String> list,
  bool enableActionButton = false,
  String buttonText = '',
  String title = '',
  ValueChanged<List<int>>? onConfirm,
}) async {
  showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.8),
      builder: (_) {
        return NormalMultiSelectBottomSheet(
          title: title,
          context: context,
          controller: ModalScrollController.of(context),
          enableActionButton: enableActionButton,
          onConfirm: onConfirm,
          buttonText: buttonText,
          list: list,
        );
      });
}

Future<int?> showListSelectBottomSheet({
  required BuildContext context,
  required List<ListSelectBottomSheetItem> list,
  int? currentIndex,
  String title = '',
}) async {
  return showMaterialModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.5),
      builder: (_) {
        return NormalListSelectBottomSheet(
          title: title,
          context: context,
          currentIndex: currentIndex,
          controller: ModalScrollController.of(context),
          list: list,
        );
      });
}

Future<int?> showListSelectBottomIconSheet({
  required BuildContext context,
  required List<ListSelectBottomSheetIconItem> list,
  int? currentIndex,
  String title = '',
}) async {
  return showMaterialModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.5),
      builder: (_) {
        return NormalListSelectBottomIconSheet(
          title: title,
          context: context,
          currentIndex: currentIndex,
          controller: ModalScrollController.of(context),
          list: list,
        );
      });
}

Future<T?> showPageBottomSheet<T>(
    {required BuildContext context, required Widget page}) {
  return showMaterialModalBottomSheet<T>(
      context: context,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.8),
      builder: (_) {
        return SafeArea(child: page);
      });
}

Future<T?> showRoundPageBottomSheet<T>(
    {required BuildContext context,
    required Widget page,
    double radius = 32.0}) {
  return showMaterialModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.8),
      builder: (_) {
        return SafeArea(
            child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
          ),
          child: page,
        ));
      });
}

Future<int?> showMenuSelectBottomSheet({
  required BuildContext context,
  required List<Widget> list,
  Widget? title,
  int? isCheck,
}) async {
  return showMaterialModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.5),
      builder: (_) {
        return MenuSelectBottomSheet(
          title: title,
          list: list,
          isCheck: isCheck,
        );
      });
}

Future<int?> showContentBottomSheet(
    {required BuildContext context,
    required String title,
    required String subTitle,
    required String cancel,
    required Widget content}) async {
  return showMaterialModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.8),
      builder: (_) {
        return ContentBottomSheet(
          title: title,
          subTitle: subTitle,
          cancel: cancel,
          content: content,
        );
      });
}

Future<int?> showCustomMenuBottomSheet(
    {required BuildContext context, required Widget child}) async {
  return showMaterialModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.8),
      builder: (_) {
        return CustomMenuBottomSheet(
          child: child,
        );
      });
}

Future<T?> showTopSheet<T>({
  required BuildContext context,
  required Widget child,
  Duration transitionDuration = const Duration(milliseconds: 500),
  bool barrierDismissible = true,
}) async {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    transitionDuration: transitionDuration,
    barrierLabel: MaterialLocalizations.of(context).dialogLabel,
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (context, _, __) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(16.0),
                bottomLeft: Radius.circular(16.0)),
            color: const Color(0xFF121216),
            child: SafeArea(child: child),
          ),
        ],
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ).drive(Tween<Offset>(
          begin: const Offset(0, -1.0),
          end: Offset.zero,
        )),
        child: child,
      );
    },
  );
}

import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    ResetInfoState state, Dispatch dispatch, ViewService viewService) {
  var languageResource = state.languageResource!;
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: Text(languageResource.deviceSetting),
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            ResetTitle(
              title: languageResource.cardId,
              subtitle: state.cardNo,
            ),
            const SizedBox(height: 10),
            ResetTitle(
              title: languageResource.version,
              subtitle: state.cardInfo.cardVersion,
            ),
            const SizedBox(height: 10),
            if (state.cardInfo.keyPairGenerated)
              ResetTitle(
                onTap: () {
                  dispatch(ResetInfoActionCreator.onResetFactorySettings());
                },
                title: languageResource.resetFactory,
                titleStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                subtitle: languageResource.resetFactoryTips,
              ),
          ],
        ),
      ),
    ),
  );
}

class ResetTitle extends StatelessWidget {
  const ResetTitle({
    super.key,
    required this.title,
    this.titleStyle = const TextStyle(
      color: Color(0xff929292),
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    this.subtitle,
    this.subtitleStyle = const TextStyle(
      color: Color(0xff929292),
      fontSize: 12,
    ),
    this.contentPadding,
    this.onTap,
  });

  final String title;
  final TextStyle titleStyle;
  final String? subtitle;
  final TextStyle subtitleStyle;
  final EdgeInsetsGeometry? contentPadding;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: contentPadding ?? EdgeInsets.zero,
      title: Text(title, style: titleStyle),
      subtitle: subtitle == null ? null : Text(subtitle!, style: subtitleStyle),
    );
  }
}

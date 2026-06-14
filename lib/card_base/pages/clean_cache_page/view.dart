import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    CleanCacheState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: const Text('Clear Cache'),
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'This will remove all local cached data except login status.',
              style: TextStyle(
                color: Color(0xff929292),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'It includes language cache, card cache, and local crypto cache.',
              style: TextStyle(
                color: Color(0xff929292),
                fontSize: 14,
              ),
            ),
            const Spacer(),
            CCButton(
              color: Colors.black,
              onPressed: state.isClearing
                  ? null
                  : () {
                      dispatch(CleanCacheActionCreator.onClearCache());
                    },
              child: Center(
                child: state.isClearing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Start Clear',
                        style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

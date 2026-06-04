import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'state.dart';

Widget buildView(
    HtmlTextState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(viewService.context)
                .extension<GradientTheme>()!
                .primaryGradient,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            Text(
              state.title ?? '',
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Html(data: state.textContent ?? '')
          ],
        ),
      ));
}

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Page;

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MultipleLoginPage extends Page<MultipleLoginState, Map<String, dynamic>> {
  MultipleLoginPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<MultipleLoginState>(
                adapter: null,
                slots: <String, Dependent<MultipleLoginState>>{
                }),
            middleware: <Middleware<MultipleLoginState>>[
            ],);

  @override
  ComponentState<MultipleLoginState> createState() {
    return ControllerComponentState();
  }

}

class ControllerComponentState extends ComponentState<MultipleLoginState>
    with SingleTickerProviderStateMixin {}

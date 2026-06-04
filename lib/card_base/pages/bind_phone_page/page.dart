import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Page;

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class BindPhonePage extends Page<BindPhoneState, Map<String, dynamic>> {
  BindPhonePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<BindPhoneState>(
                adapter: null,
                slots: <String, Dependent<BindPhoneState>>{
                }),
            middleware: <Middleware<BindPhoneState>>[
            ],);

  @override
  ComponentState<BindPhoneState> createState() {
    return ControllerComponentState();
  }
}

class ControllerComponentState extends ComponentState<BindPhoneState>
    with SingleTickerProviderStateMixin {}

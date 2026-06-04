import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Page;

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class HdRechargeMainPage
    extends Page<HdRechargeMainState, Map<String, dynamic>> {
  HdRechargeMainPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<HdRechargeMainState>(
              adapter: null, slots: <String, Dependent<HdRechargeMainState>>{}),
          middleware: <Middleware<HdRechargeMainState>>[],
        );

  @override
  ComponentState<HdRechargeMainState> createState() {
    return ControllerComponentState();
  }
}

class ControllerComponentState extends ComponentState<HdRechargeMainState>
    with TickerProviderStateMixin {}

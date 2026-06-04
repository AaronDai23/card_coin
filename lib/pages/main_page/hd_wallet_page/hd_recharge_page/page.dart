import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class HdRechargePage extends Page<HdRechargeState, Map<String, dynamic>> {
  HdRechargePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<HdRechargeState>(
                adapter: null,
                slots: <String, Dependent<HdRechargeState>>{
                }),
            middleware: <Middleware<HdRechargeState>>[
            ],);

}

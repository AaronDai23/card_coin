import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class WithdrawLightningPage extends Page<WithdrawLightningState, Map<String, dynamic>> {
  WithdrawLightningPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<WithdrawLightningState>(
                adapter: null,
                slots: <String, Dependent<WithdrawLightningState>>{
                }),
            middleware: <Middleware<WithdrawLightningState>>[
            ],);

}

import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class InvestmentBalancePage extends Page<InvestmentBalanceState, Map<String, dynamic>> {
  InvestmentBalancePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<InvestmentBalanceState>(
                adapter: null,
                slots: <String, Dependent<InvestmentBalanceState>>{
                }),
            middleware: <Middleware<InvestmentBalanceState>>[
            ],);

}

import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class InvestmentWithdrawalPage extends Page<InvestmentWithdrawalState, Map<String, dynamic>> {
  InvestmentWithdrawalPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<InvestmentWithdrawalState>(
                adapter: null,
                slots: <String, Dependent<InvestmentWithdrawalState>>{
                }),
            middleware: <Middleware<InvestmentWithdrawalState>>[
            ],);

}

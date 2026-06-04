import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class InvestmentCoinPage extends Page<InvestmentCoinState, Map<String, dynamic>> {
  InvestmentCoinPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<InvestmentCoinState>(
                adapter: null,
                slots: <String, Dependent<InvestmentCoinState>>{
                }),
            middleware: <Middleware<InvestmentCoinState>>[
            ],);

}

import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class InvestmentHistoryPage extends Page<InvestmentHistoryState, Map<String, dynamic>> {
  InvestmentHistoryPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<InvestmentHistoryState>(
                adapter: null,
                slots: <String, Dependent<InvestmentHistoryState>>{
                }),
            middleware: <Middleware<InvestmentHistoryState>>[
            ],);

}

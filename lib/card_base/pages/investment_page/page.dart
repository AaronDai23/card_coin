import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class InvestmentPage extends Page<InvestmentState, Map<String, dynamic>> {
  InvestmentPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<InvestmentState>(
                adapter: null,
                slots: <String, Dependent<InvestmentState>>{
                }),
            middleware: <Middleware<InvestmentState>>[
            ],);

}

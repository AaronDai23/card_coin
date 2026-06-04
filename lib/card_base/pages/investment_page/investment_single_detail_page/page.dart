import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class InvestmentSingleDetailPage extends Page<InvestmentSingleDetailState, Map<String, dynamic>> {
  InvestmentSingleDetailPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<InvestmentSingleDetailState>(
                adapter: null,
                slots: <String, Dependent<InvestmentSingleDetailState>>{
                }),
            middleware: <Middleware<InvestmentSingleDetailState>>[
            ],);

}

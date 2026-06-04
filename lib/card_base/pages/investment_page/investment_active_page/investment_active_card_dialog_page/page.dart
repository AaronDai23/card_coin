import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class InvestmentActiveCardDialogPage extends Page<InvestmentActiveCardDialogState, Map<String, dynamic>> {
  InvestmentActiveCardDialogPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<InvestmentActiveCardDialogState>(
                adapter: null,
                slots: <String, Dependent<InvestmentActiveCardDialogState>>{
                }),
            middleware: <Middleware<InvestmentActiveCardDialogState>>[
            ],);

}

import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class InvestmentProcessPage
    extends Page<InvestmentProcessState, Map<String, dynamic>> {
  InvestmentProcessPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<InvestmentProcessState>(
              adapter: null,
              slots: <String, Dependent<InvestmentProcessState>>{}),
          middleware: <Middleware<InvestmentProcessState>>[],
        );
}

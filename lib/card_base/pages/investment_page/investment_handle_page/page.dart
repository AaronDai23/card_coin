import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class InvestmentHandlePage
    extends Page<InvestmentHandleState, Map<String, dynamic>> {
  InvestmentHandlePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<InvestmentHandleState>(
              adapter: null,
              slots: <String, Dependent<InvestmentHandleState>>{}),
          middleware: <Middleware<InvestmentHandleState>>[],
        );
}

import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CashOutHistoryPage
    extends Page<CashOutHistoryState, Map<String, dynamic>> {
  CashOutHistoryPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<CashOutHistoryState>(),
          middleware: <Middleware<CashOutHistoryState>>[],
        );
}

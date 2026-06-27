import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CashOutPage extends Page<CashOutState, Map<String, dynamic>> {
  CashOutPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<CashOutState>(
            adapter: null,
            slots: <String, Dependent<CashOutState>>{},
          ),
          middleware: <Middleware<CashOutState>>[],
        );
}

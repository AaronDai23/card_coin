import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CashOutDetailPage extends Page<CashOutDetailState, Map<String, dynamic>> {
  CashOutDetailPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<CashOutDetailState>(
            adapter: null,
            slots: <String, Dependent<CashOutDetailState>>{},
          ),
          middleware: <Middleware<CashOutDetailState>>[],
        );
}

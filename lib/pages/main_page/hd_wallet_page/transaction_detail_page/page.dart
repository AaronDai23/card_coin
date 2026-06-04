import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class TransactionDetailPage
    extends Page<TransactionDetailState, Map<String, dynamic>> {
  TransactionDetailPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<TransactionDetailState>(
              adapter: null,
              slots: <String, Dependent<TransactionDetailState>>{}),
          middleware: <Middleware<TransactionDetailState>>[],
        );
}

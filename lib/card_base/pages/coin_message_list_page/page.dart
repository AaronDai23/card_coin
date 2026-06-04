import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CoinMessageListPage
    extends Page<CoinMessageListState, Map<String, dynamic>> {
  CoinMessageListPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<CoinMessageListState>(
              adapter: null,
              slots: <String, Dependent<CoinMessageListState>>{}),
          middleware: <Middleware<CoinMessageListState>>[],
        );
}

import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ConvertHistoryPage extends Page<ConvertHistoryState, Map<String, dynamic>> {
  ConvertHistoryPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<ConvertHistoryState>(),
          middleware: <Middleware<ConvertHistoryState>>[],
        );
}

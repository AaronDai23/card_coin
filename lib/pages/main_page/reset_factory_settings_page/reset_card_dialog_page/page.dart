import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ResetCardDialogPage extends Page<ResetCardDialogState, Map<String, dynamic>> with WidgetsBindingObserverMixin {
  ResetCardDialogPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<ResetCardDialogState>(
            adapter: null,
            slots: <String, Dependent<ResetCardDialogState>>{},
          ),
          middleware: <Middleware<ResetCardDialogState>>[],
        );
}

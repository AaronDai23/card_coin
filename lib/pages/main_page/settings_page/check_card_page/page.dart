import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CheckCardPage extends Page<CheckCardState, Map<String, dynamic>> {
  CheckCardPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<CheckCardState>(
              adapter: null, slots: <String, Dependent<CheckCardState>>{}),
          middleware: <Middleware<CheckCardState>>[],
        );
}

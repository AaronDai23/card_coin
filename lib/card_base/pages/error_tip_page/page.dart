import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ErrorTipPage extends Page<ErrorTipState, Map<String, dynamic>> {
  ErrorTipPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<ErrorTipState>(
              adapter: null, slots: <String, Dependent<ErrorTipState>>{}),
          middleware: <Middleware<ErrorTipState>>[],
        );
}

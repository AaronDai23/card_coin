import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class AddBlessPage extends Page<AddBlessState, Map<String, dynamic>> {
  AddBlessPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<AddBlessState>(
              adapter: null, slots: <String, Dependent<AddBlessState>>{}),
          middleware: <Middleware<AddBlessState>>[],
        );
}

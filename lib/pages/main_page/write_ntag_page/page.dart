import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class WriteNtagPage extends Page<WriteNtagState, Map<String, dynamic>> {
  WriteNtagPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<WriteNtagState>(
            adapter: null,
            slots: <String, Dependent<WriteNtagState>>{},
          ),
          middleware: <Middleware<WriteNtagState>>[],
        );
}

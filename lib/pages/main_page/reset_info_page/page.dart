import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ResetInfoPage extends Page<ResetInfoState, Map<String, dynamic>> {
  ResetInfoPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<ResetInfoState>(
            adapter: null,
            slots: <String, Dependent<ResetInfoState>>{},
          ),
          middleware: <Middleware<ResetInfoState>>[],
        );
}

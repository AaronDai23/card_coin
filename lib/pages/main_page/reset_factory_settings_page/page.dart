import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ResetFactorySettingsPage extends Page<ResetFactorySettingsState, Map<String, dynamic>> {
  ResetFactorySettingsPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<ResetFactorySettingsState>(
            adapter: null,
            slots: <String, Dependent<ResetFactorySettingsState>>{},
          ),
          middleware: <Middleware<ResetFactorySettingsState>>[],
        );
}

import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class BackupDataPage extends Page<BackupDataState, Map<String, dynamic>> {
  BackupDataPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<BackupDataState>(
            adapter: null,
            slots: <String, Dependent<BackupDataState>>{},
          ),
          middleware: <Middleware<BackupDataState>>[],
        );
}

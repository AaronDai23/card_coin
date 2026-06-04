import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CreateBackupPage extends Page<CreateBackupState, Map<String, dynamic>> {
  CreateBackupPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<CreateBackupState>(
            adapter: null,
            slots: <String, Dependent<CreateBackupState>>{},
          ),
          middleware: <Middleware<CreateBackupState>>[],
        );
}

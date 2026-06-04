import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class AppVersionPage extends Page<AppVersionState, Map<String, dynamic>> {
  AppVersionPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<AppVersionState>(
                adapter: null,
                slots: <String, Dependent<AppVersionState>>{
                }),
            middleware: <Middleware<AppVersionState>>[
            ],);

}

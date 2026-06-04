import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class SetPasswordPage extends Page<SetPasswordState, Map<String, dynamic>> {
  SetPasswordPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<SetPasswordState>(
                adapter: null,
                slots: <String, Dependent<SetPasswordState>>{
                }),
            middleware: <Middleware<SetPasswordState>>[
            ],);

}

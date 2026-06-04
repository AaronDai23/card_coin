import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class EmailActivatePage extends Page<EmailActivateState, Map<String, dynamic>> {
  EmailActivatePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<EmailActivateState>(
                adapter: null,
                slots: <String, Dependent<EmailActivateState>>{
                }),
            middleware: <Middleware<EmailActivateState>>[
            ],);

}

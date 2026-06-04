import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class EmailPasswordPage extends Page<EmailPasswordState, Map<String, dynamic>> {
  EmailPasswordPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<EmailPasswordState>(
                adapter: null,
                slots: <String, Dependent<EmailPasswordState>>{
                }),
            middleware: <Middleware<EmailPasswordState>>[
            ],);

}

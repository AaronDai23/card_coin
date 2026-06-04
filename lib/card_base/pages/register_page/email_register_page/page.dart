import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class EmailRegisterPage extends Page<EmailRegisterState, Map<String, dynamic>> {
  EmailRegisterPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<EmailRegisterState>(
                adapter: null,
                slots: <String, Dependent<EmailRegisterState>>{
                }),
            middleware: <Middleware<EmailRegisterState>>[
            ],);

}

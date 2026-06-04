import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class EmailOtpPage extends Page<EmailOtpState, Map<String, dynamic>> {
  EmailOtpPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<EmailOtpState>(
                adapter: null,
                slots: <String, Dependent<EmailOtpState>>{
                }),
            middleware: <Middleware<EmailOtpState>>[
            ],);

}

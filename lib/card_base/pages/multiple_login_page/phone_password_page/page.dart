import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PhonePasswordPage extends Page<PhonePasswordState, Map<String, dynamic>> {
  PhonePasswordPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<PhonePasswordState>(
                adapter: null,
                slots: <String, Dependent<PhonePasswordState>>{
                }),
            middleware: <Middleware<PhonePasswordState>>[
            ],);

}

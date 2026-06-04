import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PhoneRegisterPage extends Page<PhoneRegisterState, Map<String, dynamic>> {
  PhoneRegisterPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<PhoneRegisterState>(
                adapter: null,
                slots: <String, Dependent<PhoneRegisterState>>{
                }),
            middleware: <Middleware<PhoneRegisterState>>[
            ],);

}

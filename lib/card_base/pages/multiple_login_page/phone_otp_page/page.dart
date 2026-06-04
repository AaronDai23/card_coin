import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PhoneOtpPage extends Page<PhoneOtpState, Map<String, dynamic>> {
  PhoneOtpPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<PhoneOtpState>(
                adapter: null,
                slots: <String, Dependent<PhoneOtpState>>{
                }),
            middleware: <Middleware<PhoneOtpState>>[
            ],);

}

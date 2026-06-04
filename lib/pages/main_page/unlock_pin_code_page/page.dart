import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class UnlockPinCodePage extends Page<UnlockPinCodeState, Map<String, dynamic>> {
  UnlockPinCodePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<UnlockPinCodeState>(
                adapter: null,
                slots: <String, Dependent<UnlockPinCodeState>>{
                }),
            middleware: <Middleware<UnlockPinCodeState>>[
            ],);

}

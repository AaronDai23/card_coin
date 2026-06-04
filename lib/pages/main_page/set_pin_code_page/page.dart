import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class SetPinCodePage extends Page<SetPinCodeState, Map<String, dynamic>> {
  SetPinCodePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<SetPinCodeState>(
                adapter: null,
                slots: <String, Dependent<SetPinCodeState>>{
                }),
            middleware: <Middleware<SetPinCodeState>>[
            ],);

}

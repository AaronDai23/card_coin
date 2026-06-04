import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CancelPinCodePage extends Page<CancelPinCodeState, Map<String, dynamic>> {
  CancelPinCodePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<CancelPinCodeState>(
                adapter: null,
                slots: <String, Dependent<CancelPinCodeState>>{
                }),
            middleware: <Middleware<CancelPinCodeState>>[
            ],);

}

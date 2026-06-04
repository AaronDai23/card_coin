import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PinCodeInfoPage extends Page<PinCodeInfoState, Map<String, dynamic>> {
  PinCodeInfoPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<PinCodeInfoState>(
                adapter: null,
                slots: <String, Dependent<PinCodeInfoState>>{
                }),
            middleware: <Middleware<PinCodeInfoState>>[
            ],);

}

import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class HdSendMainPage extends Page<HdSendMainState, Map<String, dynamic>> {
  HdSendMainPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<HdSendMainState>(
                adapter: null,
                slots: <String, Dependent<HdSendMainState>>{
                }),
            middleware: <Middleware<HdSendMainState>>[
            ],);

}

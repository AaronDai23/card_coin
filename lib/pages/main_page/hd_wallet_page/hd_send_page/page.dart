import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class HdSendPage extends Page<HdSendState, Map<String, dynamic>> {
  HdSendPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<HdSendState>(
                adapter: null,
                slots: <String, Dependent<HdSendState>>{
                }),
            middleware: <Middleware<HdSendState>>[
            ],);

}

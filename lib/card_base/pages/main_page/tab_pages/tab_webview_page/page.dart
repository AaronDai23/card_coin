import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class TabWebviewPage extends Page<TabWebviewState, Map<String, dynamic>> {
  TabWebviewPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<TabWebviewState>(
                adapter: null,
                slots: <String, Dependent<TabWebviewState>>{
                }),
            middleware: <Middleware<TabWebviewState>>[
            ],);

}

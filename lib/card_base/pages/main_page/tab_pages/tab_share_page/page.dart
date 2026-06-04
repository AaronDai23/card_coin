import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class TabSharePage extends Page<TabShareState, Map<String, dynamic>> {
  TabSharePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<TabShareState>(
                adapter: null,
                slots: <String, Dependent<TabShareState>>{
                }),
            middleware: <Middleware<TabShareState>>[
            ],);

}

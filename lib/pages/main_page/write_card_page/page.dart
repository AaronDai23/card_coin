import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class WriteCardPage extends Page<WriteCardState, Map<String, dynamic>> {
  WriteCardPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<WriteCardState>(
                adapter: null,
                slots: <String, Dependent<WriteCardState>>{
                }),
            middleware: <Middleware<WriteCardState>>[
            ],);

}

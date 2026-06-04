import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class AddCardPage extends Page<AddCardState, Map<String, dynamic>> {
  AddCardPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<AddCardState>(
                adapter: null,
                slots: <String, Dependent<AddCardState>>{
                }),
            middleware: <Middleware<AddCardState>>[
            ],);

}

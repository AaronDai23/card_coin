import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class SelectedActivatePage extends Page<SelectedActivateState, Map<String, dynamic>> {
  SelectedActivatePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<SelectedActivateState>(
                adapter: null,
                slots: <String, Dependent<SelectedActivateState>>{
                }),
            middleware: <Middleware<SelectedActivateState>>[
            ],);

}

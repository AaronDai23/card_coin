import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class AllActivatePage extends Page<AllActivateState, Map<String, dynamic>> {
  AllActivatePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<AllActivateState>(
                adapter: null,
                slots: <String, Dependent<AllActivateState>>{
                }),
            middleware: <Middleware<AllActivateState>>[
            ],);

}

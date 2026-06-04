import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ActivateDetailPage extends Page<ActivateDetailState, Map<String, dynamic>> {
  ActivateDetailPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<ActivateDetailState>(
                adapter: null,
                slots: <String, Dependent<ActivateDetailState>>{
                }),
            middleware: <Middleware<ActivateDetailState>>[
            ],);

}

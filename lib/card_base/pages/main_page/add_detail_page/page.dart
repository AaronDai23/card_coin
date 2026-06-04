import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class AddDetailPage extends Page<AddDetailState, Map<String, dynamic>> {
  AddDetailPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<AddDetailState>(
                adapter: null,
                slots: <String, Dependent<AddDetailState>>{
                }),
            middleware: <Middleware<AddDetailState>>[
            ],);

}

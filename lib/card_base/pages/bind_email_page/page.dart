import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class BindEmailPage extends Page<BindEmailState, Map<String, dynamic>> {
  BindEmailPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<BindEmailState>(
                adapter: null,
                slots: <String, Dependent<BindEmailState>>{
                }),
            middleware: <Middleware<BindEmailState>>[
            ],);

}

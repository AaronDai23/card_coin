import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class SelectFiatPage extends Page<SelectFiatState, Map<String, dynamic>> {
  SelectFiatPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<SelectFiatState>(
                adapter: null,
                slots: <String, Dependent<SelectFiatState>>{
                }),
            middleware: <Middleware<SelectFiatState>>[
            ],);

}

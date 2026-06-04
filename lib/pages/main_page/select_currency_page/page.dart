import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class SelectCurrencyPage extends Page<SelectCurrencyState, Map<String, dynamic>> {
  SelectCurrencyPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<SelectCurrencyState>(
                adapter: null,
                slots: <String, Dependent<SelectCurrencyState>>{
                }),
            middleware: <Middleware<SelectCurrencyState>>[
            ],);

}

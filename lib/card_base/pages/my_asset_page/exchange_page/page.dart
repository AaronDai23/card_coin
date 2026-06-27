import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ExchangePage extends Page<ExchangeState, Map<String, dynamic>> {
  ExchangePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<ExchangeState>(
                adapter: null,
                slots: <String, Dependent<ExchangeState>>{
                }),
            middleware: <Middleware<ExchangeState>>[
            ],);

}


import 'package:fish_redux/fish_redux.dart';

import 'adapter/adapter.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CardManagerPage extends Page<CardManagerState, Map<String, dynamic>> {
  CardManagerPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<CardManagerState>(
                adapter: const NoneConn<CardManagerState>() + adapter,
                slots: <String, Dependent<CardManagerState>>{
                }),
            middleware: <Middleware<CardManagerState>>[
            ],);

}

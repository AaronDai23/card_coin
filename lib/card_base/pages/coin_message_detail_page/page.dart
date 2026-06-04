import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CoinMessageDetailPage extends Page<CoinMessageDetailState, Map<String, dynamic>> {
  CoinMessageDetailPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<CoinMessageDetailState>(
                adapter: null,
                slots: <String, Dependent<CoinMessageDetailState>>{
                }),
            middleware: <Middleware<CoinMessageDetailState>>[
            ],);

}

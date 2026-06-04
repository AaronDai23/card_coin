import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class LightningNetDetailPage extends Page<LightningNetDetailState, Map<String, dynamic>> {
  LightningNetDetailPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<LightningNetDetailState>(
                adapter: null,
                slots: <String, Dependent<LightningNetDetailState>>{
                }),
            middleware: <Middleware<LightningNetDetailState>>[
            ],);

}

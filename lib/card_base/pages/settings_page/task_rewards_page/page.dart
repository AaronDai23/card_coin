import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class LightningRewardsPage
    extends Page<TaskRewardsState, Map<String, dynamic>> {
  LightningRewardsPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<TaskRewardsState>(
              adapter: null, slots: <String, Dependent<TaskRewardsState>>{}),
          middleware: <Middleware<TaskRewardsState>>[],
        );
}

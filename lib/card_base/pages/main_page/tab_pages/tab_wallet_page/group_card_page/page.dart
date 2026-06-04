import 'package:fish_redux/fish_redux.dart';

import 'adapter/adapter.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class GroupCardPage extends Page<GroupCardState, Map<String, dynamic>> {
  GroupCardPage()
      : super(
            initState: initState,
            wrapper: keepAliveClientWrapper,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<GroupCardState>(
                adapter: const NoneConn<GroupCardState>() + adapter,
                slots: <String, Dependent<GroupCardState>>{
                }),
            middleware: <Middleware<GroupCardState>>[
            ],);

}

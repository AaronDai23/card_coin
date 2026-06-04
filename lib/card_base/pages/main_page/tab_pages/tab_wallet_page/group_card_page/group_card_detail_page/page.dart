import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class GroupCardDetailPage extends Page<GroupCardDetailState, Map<String, dynamic>> {
  GroupCardDetailPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<GroupCardDetailState>(
                adapter: null,
                slots: <String, Dependent<GroupCardDetailState>>{
                }),
            middleware: <Middleware<GroupCardDetailState>>[
            ],);

}

import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MemberPointsPage extends Page<MemberPointsState, Map<String, dynamic>> {
  MemberPointsPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<MemberPointsState>(
                adapter: null,
                slots: <String, Dependent<MemberPointsState>>{
                }),
            middleware: <Middleware<MemberPointsState>>[
            ],);

}

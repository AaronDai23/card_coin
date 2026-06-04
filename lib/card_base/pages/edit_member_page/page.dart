import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class EditMemberPage extends Page<EditMemberState, Map<String, dynamic>> {
  EditMemberPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<EditMemberState>(
                adapter: null,
                slots: <String, Dependent<EditMemberState>>{
                }),
            middleware: <Middleware<EditMemberState>>[
            ],);

}

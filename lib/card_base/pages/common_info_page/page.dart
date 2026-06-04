import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CommonInfoPage extends Page<CommonInfoState, Map<String, dynamic>> {
  CommonInfoPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<CommonInfoState>(
                adapter: null,
                slots: <String, Dependent<CommonInfoState>>{
                }),
            middleware: <Middleware<CommonInfoState>>[
            ],);

}

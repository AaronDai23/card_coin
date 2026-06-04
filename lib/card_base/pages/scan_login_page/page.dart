import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ScanLoginPage extends Page<ScanLoginState, Map<String, dynamic>> {
  ScanLoginPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<ScanLoginState>(
                adapter: null,
                slots: <String, Dependent<ScanLoginState>>{
                }),
            middleware: <Middleware<ScanLoginState>>[
            ],);

}

import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class NetworkCheckPage extends Page<NetworkCheckState, Map<String, dynamic>> {
  NetworkCheckPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<NetworkCheckState>(
                adapter: null,
                slots: <String, Dependent<NetworkCheckState>>{
                }),
            middleware: <Middleware<NetworkCheckState>>[
            ],);

}

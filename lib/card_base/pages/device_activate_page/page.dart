import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class DeviceActivatePage extends Page<DeviceActivateState, Map<String, dynamic>> {
  DeviceActivatePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<DeviceActivateState>(
                adapter: null,
                slots: <String, Dependent<DeviceActivateState>>{
                }),
            middleware: <Middleware<DeviceActivateState>>[
            ],);

}

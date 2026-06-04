import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PackageActivatePage extends Page<PackageActivateState, Map<String, dynamic>> {
  PackageActivatePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<PackageActivateState>(
                adapter: null,
                slots: <String, Dependent<PackageActivateState>>{
                }),
            middleware: <Middleware<PackageActivateState>>[
            ],);

}

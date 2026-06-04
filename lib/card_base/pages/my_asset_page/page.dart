import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MyAssetPage extends Page<MyAssetState, Map<String, dynamic>> {
  MyAssetPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<MyAssetState>(
              adapter: null, slots: <String, Dependent<MyAssetState>>{}),
          middleware: <Middleware<MyAssetState>>[],
        );
}

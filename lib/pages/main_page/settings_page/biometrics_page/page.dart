import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class BiometricsPage extends Page<BiometricsState, Map<String, dynamic>> {
  BiometricsPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<BiometricsState>(
              adapter: null, slots: <String, Dependent<BiometricsState>>{}),
          middleware: <Middleware<BiometricsState>>[],
        );
}

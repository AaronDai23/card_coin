import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CropImagePage extends Page<CropImageState, Map<String, dynamic>> {
  CropImagePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<CropImageState>(
              adapter: null, slots: <String, Dependent<CropImageState>>{}),
          middleware: <Middleware<CropImageState>>[],
        );
}

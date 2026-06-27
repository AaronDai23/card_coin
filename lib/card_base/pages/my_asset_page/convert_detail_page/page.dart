import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ConvertDetailPage extends Page<ConvertDetailState, Map<String, dynamic>> {
  ConvertDetailPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<ConvertDetailState>(
            adapter: null,
            slots: <String, Dependent<ConvertDetailState>>{},
          ),
          middleware: <Middleware<ConvertDetailState>>[],
        );
}

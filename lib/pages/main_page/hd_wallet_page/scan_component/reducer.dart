import 'package:fish_redux/fish_redux.dart';

import 'state.dart';

Reducer<ScanState>? buildReducer() {
  return asReducer(
    <Object, Reducer<ScanState>>{
      // ScanAction.action: _onAction,
    },
  );
}

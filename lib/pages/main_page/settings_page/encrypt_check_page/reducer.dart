import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<EncryptCheckState>? buildReducer() {
  return asReducer(
    <Object, Reducer<EncryptCheckState>>{
      EncryptCheckAction.updateData: _onUpdateData,
    },
  );
}

EncryptCheckState _onUpdateData(EncryptCheckState state, Action action) {
  final EncryptCheckState newState = state.clone()
    ..appData = action.payload['appData']
    ..cardData = action.payload['cardData'];
  return newState;
}

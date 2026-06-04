import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;

import 'action.dart';
import 'state.dart';
Reducer<ScanQrcodeState>? buildReducer() {
  return asReducer(
    <Object, Reducer<ScanQrcodeState>>{
      ScanQrcodeAction.turnFlash: _onTurnFlash,
    },
  );
}

ScanQrcodeState _onTurnFlash(ScanQrcodeState state, Action action) {
  final ScanQrcodeState newState = state.clone();
  if (newState.lightIcon == Icons.flash_on) {
    newState.lightIcon = Icons.flash_off;
  } else {
    newState.lightIcon = Icons.flash_on;
  }
  return newState;
}

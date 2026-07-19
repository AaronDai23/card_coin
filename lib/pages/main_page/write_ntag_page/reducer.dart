import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<WriteNtagState>? buildReducer() {
  return asReducer(<Object, Reducer<WriteNtagState>>{
    WriteNtagAction.loadSuccess: _onLoadSuccess,
    WriteNtagAction.loadFailed: _onLoadFailed,
    WriteNtagAction.updateLock: _onUpdateLock,
    WriteNtagAction.updateStatus: _onUpdateStatus,
    WriteNtagAction.updateScanning: _onUpdateScanning,
    WriteNtagAction.updateScanResult: _onUpdateScanResult,
  });
}

WriteNtagState _onLoadSuccess(WriteNtagState state, Action action) {
  final map = action.payload as Map<String, String>;
  return state.clone()
    ..domainUrl = map['domainUrl'] ?? ''
    ..ndefAAR = map['ndefAAR'] ?? ''
    ..scannedUid = ''
    ..fullNdefUrl = ''
    ..loadStatus = LoadType.loadSuccess
    ..errorMsg = '';
}

WriteNtagState _onLoadFailed(WriteNtagState state, Action action) {
  return state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload as String? ?? 'Load failed';
}

WriteNtagState _onUpdateLock(WriteNtagState state, Action action) {
  return state.clone()..lockAfterWrite = action.payload as bool;
}

WriteNtagState _onUpdateStatus(WriteNtagState state, Action action) {
  return state.clone()..statusMessage = action.payload as String;
}

WriteNtagState _onUpdateScanning(WriteNtagState state, Action action) {
  return state.clone()..isScanning = action.payload as bool;
}

WriteNtagState _onUpdateScanResult(WriteNtagState state, Action action) {
  final map = action.payload as Map<String, String>;
  return state.clone()
    ..scannedUid = map['scannedUid'] ?? ''
    ..fullNdefUrl = map['fullNdefUrl'] ?? '';
}

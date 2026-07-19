import 'package:fish_redux/fish_redux.dart';

enum WriteNtagAction {
  loadConfig,
  loadSuccess,
  loadFailed,
  startWrite,
  cancelScan,
  updateLock,
  updateStatus,
  updateScanning,
  updateScanResult,
}

class WriteNtagActionCreator {
  static Action onLoadConfig() {
    return const Action(WriteNtagAction.loadConfig);
  }

  static Action onLoadSuccess({
    required String domainUrl,
    required String ndefAAR,
  }) {
    return Action(WriteNtagAction.loadSuccess, payload: <String, String>{
      'domainUrl': domainUrl,
      'ndefAAR': ndefAAR,
    });
  }

  static Action onLoadFailed(String message) {
    return Action(WriteNtagAction.loadFailed, payload: message);
  }

  static Action onStartWrite() {
    return const Action(WriteNtagAction.startWrite);
  }

  static Action onCancelScan() {
    return const Action(WriteNtagAction.cancelScan);
  }

  static Action onUpdateLock(bool value) {
    return Action(WriteNtagAction.updateLock, payload: value);
  }

  static Action onUpdateStatus(String message) {
    return Action(WriteNtagAction.updateStatus, payload: message);
  }

  static Action onUpdateScanning(bool scanning) {
    return Action(WriteNtagAction.updateScanning, payload: scanning);
  }

  static Action onUpdateScanResult({
    required String scannedUid,
    required String fullNdefUrl,
  }) {
    return Action(WriteNtagAction.updateScanResult, payload: <String, String>{
      'scannedUid': scannedUid,
      'fullNdefUrl': fullNdefUrl,
    });
  }
}

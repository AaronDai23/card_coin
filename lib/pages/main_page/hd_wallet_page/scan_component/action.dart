import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum ScanAction { scanCard }

class ScanActionCreator {
  static Action onScanCard() {
    return const Action(ScanAction.scanCard);
  }
}

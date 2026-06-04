import 'package:fish_redux/fish_redux.dart';

enum CropImageAction { crop }

class CropImageActionCreator {
  static Action onCrop() {
    return const Action(CropImageAction.crop);
  }
}

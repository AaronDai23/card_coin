import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Effect<ScanQrcodeState>? buildEffect() {
  return combineEffects(<Object, Effect<ScanQrcodeState>>{
    ScanQrcodeAction.toggleTorchMode: _onToggleTorchMode,
    ScanQrcodeAction.pickImage: _onPickImage,
  });
}

void _onToggleTorchMode(Action action, Context<ScanQrcodeState> ctx) {
  ctx.state.controller.toggleTorchMode();
}

Future<void> _onPickImage(Action action, Context<ScanQrcodeState> ctx) async {
  // final ImagePicker _picker = ImagePicker();
  // final XFile res = await _picker.pickImage(source: ImageSource.gallery);
  // if (res == null) return;
  // String? result = await Scan.parse(res.path);
  // Navigator.pop(ctx.context, result);
}
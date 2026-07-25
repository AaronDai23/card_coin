import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Effect<CropImageState>? buildEffect() {
  return combineEffects(<Object, Effect<CropImageState>>{
    Lifecycle.dispose: _dispose,
    CropImageAction.crop: _onCrop,
  });
}

void _onCrop(Action action, Context<CropImageState> ctx) {
  ctx.state.cropController.crop();
}

void _dispose(Action action, Context<CropImageState> ctx) {
  // Only remove the original pick temp file. The cropped path is returned to
  // the caller and must remain until they finish uploading/compressing.
  try {
    ctx.state.file.deleteSync();
  } catch (_) {}
}

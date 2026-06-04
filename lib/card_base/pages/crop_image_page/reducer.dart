import 'package:fish_redux/fish_redux.dart';

import 'state.dart';

Reducer<CropImageState>? buildReducer() {
  return asReducer(
    <Object, Reducer<CropImageState>>{
//      CropImageAction.crop: _onCrop,
    },
  );
}

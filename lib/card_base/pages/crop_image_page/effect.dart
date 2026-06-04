
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:image_crop_plus/image_crop_plus.dart';

import 'package:oktoast/oktoast.dart';
import '../../../generated/l10n.dart';
import 'action.dart';
import 'state.dart';

Effect<CropImageState>? buildEffect() {
  return combineEffects(<Object, Effect<CropImageState>>{
    Lifecycle.dispose: _dispose,
    CropImageAction.crop: _onCrop,
  });
}

Future<void> _onCrop(Action action, Context<CropImageState> ctx) async {
  CropState crop = ctx.state.cropKey.currentState as CropState;
  final Rect? area = crop.area;
  final double scale = crop.scale;
  if (area == null) {
    //裁剪结果为空
    // print('裁剪不成功');
  }

  final sample = await ImageCrop.sampleImage(
    file: ctx.state.file,
    preferredWidth: (300 / scale).round(),
    preferredHeight: (400 / scale).round(),
  );

  //裁剪图片
  ImageCrop.cropImage(
    file: sample,
    area: area!,
  ).then((file) async {
    sample.delete();
    // print('crop Image path:${file.path}');
    Navigator.pop(ctx.context, file.path);
  }).catchError((error) {
    showToast(S.current.cutPhoneFailure);
    sample.delete();
    Navigator.pop(ctx.context);
  });
}

// //上传图片到服务器
// Future<String> _upLoadImage(String path) async {
//   var name = path.substring(path.lastIndexOf("/") + 1, path.length);
//   FormData formData = FormData.fromMap(
//       {"image": await MultipartFile.fromFile(path, filename: name)});
//
//   // ResultData res = await HttpManager.getInstance().post(Address.HEAD_IMAGE_API, formData);
//   try {
//     await MagicHomeDataApi.getUserInstance().uploadUserAvatar(path);
//
//     return
//   }catch(e){
//
//   }
//   return res.isSuccess ? Future.value(res.data['headPic']) : Future.error(res.data);
// }

void _dispose(Action action, Context<CropImageState> ctx) {
  ctx.state.file.delete();
  ctx.state.lastCropped?.delete();
}

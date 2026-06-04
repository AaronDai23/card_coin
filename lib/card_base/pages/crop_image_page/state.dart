import 'dart:io';

import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:flutter/material.dart';
import 'package:image_crop_plus/image_crop_plus.dart';

import '../../../global_store/state.dart';


class CropImageState implements GlobalBaseState<CropImageState> {
  late File file;
  late GlobalKey cropKey;
//  File sample;
  File? lastCropped;
  late double aspectRatio;
  @override
  CropImageState clone() {
    return CropImageState()
      ..file = file
      ..cropKey = cropKey
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..aspectRatio = aspectRatio
//      ..sample = sample
      ..lastCropped = lastCropped;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

CropImageState initState(Map<String, dynamic>? args) {
  File file = args!["file"]!;
  double? aspectRatio = args["aspectRatio"];
//  File sample = args["sample"];
  return CropImageState()
    ..file = file
    ..aspectRatio = aspectRatio??1.0
//    ..sample = sample
    ..cropKey = GlobalKey<CropState>();
}

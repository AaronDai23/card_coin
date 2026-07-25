import 'dart:io';
import 'dart:typed_data';

import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';

import '../../../global_store/state.dart';

class CropImageState implements GlobalBaseState<CropImageState> {
  late File file;
  late Uint8List imageBytes;
  late CropController cropController;
  File? lastCropped;
  late double aspectRatio;

  @override
  CropImageState clone() {
    return CropImageState()
      ..file = file
      ..imageBytes = imageBytes
      ..cropController = cropController
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..aspectRatio = aspectRatio
      ..lastCropped = lastCropped;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

CropImageState initState(Map<String, dynamic>? args) {
  final File file = args!["file"]!;
  final double? aspectRatio = args["aspectRatio"];
  return CropImageState()
    ..file = file
    ..imageBytes = file.readAsBytesSync()
    ..aspectRatio = aspectRatio ?? 1.0
    ..cropController = CropController();
}

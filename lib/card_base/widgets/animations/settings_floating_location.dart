import 'package:flutter/material.dart';

class SettingsFloatingLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  final double offsetX;    // X方向的偏移量
  final double offsetY;    // Y方向的偏移量
  SettingsFloatingLocation(this.location,{this.offsetX = 0, this.offsetY = 0});

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
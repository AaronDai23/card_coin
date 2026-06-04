import 'package:flutter/material.dart';

typedef OnWidgetSizeChange = void Function(Size size);

class MeasureSize extends StatefulWidget {
  final Widget child;
  final OnWidgetSizeChange onChange;

  const MeasureSize({super.key, required this.child, required this.onChange});

  @override
  State<MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  final _key = GlobalKey();
  Size? oldSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  @override
  Widget build(BuildContext context) {
    return Container(key: _key, child: widget.child);
  }

  void _afterLayout(_) {
    final context = _key.currentContext;
    if (context == null) return;

    final size = context.size;
    if (oldSize == size || size == null) return;

    oldSize = size;
    widget.onChange(size);
  }
}

import 'package:flutter/material.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';

class CircledContainer extends StatefulWidget {
  final Widget child;
  final double padding;
  final Color? borderColor;
  final double borderWidth;

  const CircledContainer({
    super.key,
    required this.child,
    this.padding = 20,
    this.borderColor,
    this.borderWidth = 2,
  });

  @override
  State<CircledContainer> createState() => _CircledContainerState();
}

class _CircledContainerState extends State<CircledContainer> {
  final GlobalKey _key = GlobalKey();
  Size _size = Size.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getSize());
  }

  void _getSize() {
    final context = _key.currentContext;
    if (context == null) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final newSize = box.size;
    if (_size != newSize) {
      setState(() {
        _size = newSize;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const double diameter = 280;
    final Color resolvedBorderColor =
        widget.borderColor ?? AppThemeConfig.appBarBackground.withOpacity(0.65);
    final Color resolvedBackgroundColor =
        AppThemeConfig.appBarBackground.withOpacity(0.08);

    return Stack(
      alignment: Alignment.center,
      children: [
        if (_size != Size.zero)
          Container(
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              color: resolvedBackgroundColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: resolvedBorderColor,
                width: widget.borderWidth,
              ),
            ),
          ),
        Container(key: _key, child: widget.child),
      ],
    );
  }
}

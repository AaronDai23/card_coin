import 'package:flutter/material.dart';

class CCButton extends StatelessWidget {
  final Widget child;
  final Color? color;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final double borderRadius;
  final double verticalPadding;
  final double horizontalPadding;

  const CCButton(
      {Key? key,
      required this.child,
      this.color,
      this.verticalPadding = 6.0,
      this.onPressed,
      this.onLongPress,
      this.borderRadius = 30.0,
      this.horizontalPadding = 16})
      : super(key: key);

  const CCButton.gray(
      {Key? key,
      required this.child,
      this.color = const Color(0xFF313138),
      this.onPressed,
      this.onLongPress,
      this.borderRadius = 30.0,
      this.horizontalPadding = 16.0,
      this.verticalPadding = 8.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: EdgeInsets.symmetric(
              vertical: verticalPadding, horizontal: horizontalPadding),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius))),
      child: child,
    );
  }
}

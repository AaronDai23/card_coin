import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final Function? onPressed;
  final double borderRadius;
  final Color disabledColor;
  final Color disabledTextColor;
  final double verticalPadding;
  final double fontSize;

  const ButtonWidget({
    Key? key,
    required this.text,
    this.color = Colors.black,
    this.textColor = Colors.white,
    this.fontSize = 14.0,
    this.onPressed,
    this.borderRadius = 8,
    this.disabledColor = Colors.grey,
    this.verticalPadding = 12,
    this.disabledTextColor = Colors.white30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
      ),
      onPressed: () => onPressed?.call(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: fontSize),
        ),
      ),
    );
  }
}

class ZenggeButton extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Color? disableColor;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final double? borderRadius;
  final double? verticalPadding;
  final double? horizontalPadding;
  final Size? minimumSize;

  const ZenggeButton(
      {super.key,
      required this.child,
      this.color,
      this.disableColor,
      this.onPressed,
      this.onLongPress,
      this.borderRadius,
      this.verticalPadding,
      this.horizontalPadding,
      this.minimumSize});

  ZenggeButton.small({
    super.key,
    String text = '',
    this.onPressed,
    this.onLongPress,
    this.borderRadius,
    this.verticalPadding,
    this.horizontalPadding,
    this.color,
  })  : disableColor = Colors.grey,
        minimumSize = const Size(0, 32),
        child = Text(
          text,
          style: const TextStyle(fontSize: 16),
        );

  ZenggeButton.big({
    super.key,
    String text = '',
    this.onPressed,
    this.onLongPress,
    this.borderRadius,
    this.verticalPadding,
    this.horizontalPadding,
    this.color,
  })  : disableColor = Colors.grey,
        minimumSize = const Size(0, 48),
        child = Text(text, style: const TextStyle(fontSize: 16));

  const ZenggeButton.gray({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.borderRadius,
    this.verticalPadding,
    this.horizontalPadding,
    this.minimumSize,
  })  : color = Colors.black,
        disableColor = Colors.grey;

  const ZenggeButton.warn(
      {super.key,
      required this.child,
      this.onPressed,
      this.onLongPress,
      this.borderRadius,
      this.verticalPadding,
      this.horizontalPadding,
      this.minimumSize})
      : color = Colors.red,
        disableColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = color ?? Colors.black;
    Color disableBackgroundColor = disableColor ?? Colors.grey;

    return ElevatedButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.pressed)) {
              return backgroundColor.withOpacity(0.5);
            } else if (states.contains(WidgetState.disabled))
              return disableBackgroundColor;
            else
              return backgroundColor;
          },
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 30.0)),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize:
            minimumSize != null ? WidgetStateProperty.all(minimumSize) : null,
        padding: minimumSize == null
            ? WidgetStateProperty.all(EdgeInsets.symmetric(
                vertical: verticalPadding ?? 10.0,
                horizontal: horizontalPadding ?? 16.0,
              ))
            : WidgetStateProperty.all(EdgeInsets.symmetric(
                vertical: verticalPadding ?? 0,
                horizontal: horizontalPadding ?? 10.0,
              )),
      ),
      child: child,
    );
  }
}

class NavigatorIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget? child;

  const NavigatorIconButton(
      {super.key, this.onPressed, this.onLongPress, this.child});

  const NavigatorIconButton.close({
    super.key,
    this.onPressed,
    this.onLongPress,
    this.child = const Icon(Icons.close, size: 20),
  });

  const NavigatorIconButton.back({
    super.key,
    this.onPressed,
    this.onLongPress,
    this.child = const Icon(Icons.arrow_back_rounded, size: 20),
  });

  const NavigatorIconButton.add({
    super.key,
    this.onPressed,
    this.onLongPress,
    this.child = const Icon(Icons.add, size: 20),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) {
            return const Color(0xFFffffff).withOpacity(0.1);
          },
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(const CircleBorder()),
        minimumSize: WidgetStateProperty.all(const Size(0, 34)),
      ),

      //
      // ElevatedButton.styleFrom(
      //     minimumSize: Size(0, 32),
      //     padding: const EdgeInsets.all(0),
      //     shape: CircleBorder(), backgroundColor: appStyle.somePartColor),
      // color: Color(0xFF444452),
      child: child,
    );
  }
}

class NavigatorTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  final String? text;
  final Color? bgColor;
  final Color? borderColor;
  final Widget? child;

  const NavigatorTextButton(
      {super.key,
      this.onPressed,
      this.onLongPress,
      this.text,
      this.bgColor,
      this.child,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: ElevatedButton.styleFrom(
          backgroundColor: bgColor ?? const Color(0xFFffffff).withOpacity(0.1),
          minimumSize: const Size(0, 34),
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 12.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
      child: child ??
          Text(
            text!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
    );
  }
}

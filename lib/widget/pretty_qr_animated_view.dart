import 'package:flutter/cupertino.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class PrettyQrAnimatedView extends StatefulWidget{
  @protected
  final QrImage qrImage;

  @protected
  final PrettyQrDecoration decoration;

  const PrettyQrAnimatedView({super.key,
    required this.qrImage,
    required this.decoration,
  });

  @override
  State<PrettyQrAnimatedView> createState() => _PrettyQrAnimatedViewState();

}

class _PrettyQrAnimatedViewState extends State<PrettyQrAnimatedView> {
  @protected
  late PrettyQrDecoration previosDecoration;

  @override
  void initState() {
    super.initState();

    previosDecoration = widget.decoration;
  }

  @override
  void didUpdateWidget(
      covariant PrettyQrAnimatedView oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (widget.decoration != oldWidget.decoration) {
      previosDecoration = oldWidget.decoration;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TweenAnimationBuilder<PrettyQrDecoration>(
        tween: PrettyQrDecorationTween(
          begin: previosDecoration,
          end: widget.decoration,
        ),
        curve: Curves.ease,
        duration: const Duration(
          milliseconds: 240,
        ),
        builder: (context, decoration, child) {
          return PrettyQrView(
            qrImage: widget.qrImage,
            decoration: decoration,
          );
        },
      ),
    );
  }
}
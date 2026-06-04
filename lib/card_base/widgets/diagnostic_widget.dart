import 'package:card_coin/custom_widget/load_image.dart';
import 'package:flutter/material.dart';

enum ResultState { normal, processing, pass, fail }

class DiagnosticStatusView extends StatelessWidget {
  final ResultState state;

  const DiagnosticStatusView({super.key, this.state = ResultState.processing});

  @override
  Widget build(BuildContext context) {
    if (state == ResultState.processing) {
      return const SizedBox(
          width: 18.0,
          height: 18.0,
          child: CircularProgressIndicator(
            color: Colors.blue,
            strokeWidth: 3.0,
          ));
    } else if (state == ResultState.pass) {
      return const StatusIcon(true);
    } else if (state == ResultState.fail) {
      return const StatusIcon(false);
    }
    return Container();
  }
}

class StatusIcon extends StatelessWidget {
  final bool isSuccess;
  final double size;

  @override
  Widget build(BuildContext context) {
    return LoadAssetImage(
      isSuccess ? 'md_state_pass' : 'md_state_fail',
      width: size,
      height: size,
    );
  }

  const StatusIcon(this.isSuccess, {super.key, this.size = 24.0});
}

class DiagnosticStatusAnimation extends StatelessWidget {
  final ResultState resultState;
  final double width;
  final double lineWidth;
  final double lineHeight;

  const DiagnosticStatusAnimation(this.resultState, this.width,
      {super.key, this.lineWidth = 10, this.lineHeight = 3});

  @override
  Widget build(BuildContext context) {
    Color lineColor;
    if (resultState == ResultState.processing ||
        resultState == ResultState.normal) {
      lineColor = const Color(0x699D9D9D);
    } else if (resultState == ResultState.pass) {
      lineColor = Colors.blue;
    } else {
      lineColor = Colors.red;
    }

    return Column(
      children: [
        SizedBox(
          height: 24.0,
          child: Visibility(
              visible: resultState == ResultState.pass ||
                  resultState == ResultState.fail,
              child: StatusIcon(
                resultState == ResultState.pass,
                size: 14,
              )),
        ),
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: lineColor, borderRadius: BorderRadius.circular(1.5)),
              width: width,
              height: lineHeight,
            ),
            resultState == ResultState.processing
                ? SlideAnimatedLine(
                    lineWidth: lineWidth,
                    containerWidth: width,
                  )
                : const SizedBox()
          ],
        ),
        const SizedBox(
          height: 24.0,
        )
      ],
    );
  }
}

class SlideAnimatedLine extends StatefulWidget {
  final double lineWidth;
  final double lineHeight;
  final double containerWidth;

  const SlideAnimatedLine(
      {Key? key,
      required this.lineWidth,
      required this.containerWidth,
      this.lineHeight = 3})
      : super(key: key);

  @override
  SlideAnimatedLineState createState() => SlideAnimatedLineState();
}

class SlideAnimatedLineState extends State<SlideAnimatedLine>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> animationSlideUp;

  void _animationStatusChange(AnimationStatus status) {
    ///循环来回滑动效果
    if (status == AnimationStatus.completed) {
      animationController.reverse();
    } else if (status == AnimationStatus.dismissed) {
      animationController.forward();
    }
  }

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    animationController.addStatusListener(_animationStatusChange);

    var percent = (widget.containerWidth - widget.lineWidth) / widget.lineWidth;

    animationSlideUp = Tween(
      begin: const Offset(0.0, 0.0),
      end: Offset(percent, 0.0),
    ).animate(
        CurvedAnimation(parent: animationController, curve: Curves.linear));

    animationController.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animationSlideUp,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(1.5)),
        width: widget.lineWidth,
        height: widget.lineHeight,
      ),
    );
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_animationStatusChange);
    animationController.dispose();
    super.dispose();
  }
}

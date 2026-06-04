import 'package:flutter/material.dart';

class SlideToActButton extends StatefulWidget {
  final double width;
  final double height;
  final VoidCallback onCompleted;
  final Color backgroundColor;
  final Color completedColor;
  final Color sliderColor;
  final String text;
  final String completedText;
  final TextStyle textStyle;
  final TextStyle completedTextStyle;
  final IconData sliderIcon;
  final IconData completedIcon;
  final Widget? sliderIconWidget;
  final Widget? completedIconWidget;
  final Color iconColor;
  final double threshold;

  const SlideToActButton({
    super.key,
    required this.width,
    required this.onCompleted,
    this.height = 34,
    this.backgroundColor = const Color(0xFFEEEEEE),
    this.completedColor = const Color(0xFF4CAF50),
    this.sliderColor = Colors.white,
    this.text = "Slide to Activate",
    this.completedText = "Completed!",
    this.textStyle = const TextStyle(color: Colors.black54, fontSize: 14),
    this.completedTextStyle =
        const TextStyle(color: Colors.white, fontSize: 14),
    this.sliderIcon = Icons.arrow_forward,
    this.completedIcon = Icons.check,
    this.sliderIconWidget,
    this.completedIconWidget,
    this.iconColor = const Color(0xFF2196F3),
    this.threshold = 0.8,
  });

  @override
  State<SlideToActButton> createState() => SlideToActButtonState();
}

class SlideToActButtonState extends State<SlideToActButton>
    with SingleTickerProviderStateMixin {
  late double _dragPosition;
  late bool _completed;
  late AnimationController _resetController;
  late Animation<double> _resetAnimation;

  double get _sliderSize => widget.height;
  double get _maxDragPosition => widget.width - _sliderSize;
  double get _thresholdPosition => widget.width * widget.threshold;

  @override
  void initState() {
    super.initState();
    _dragPosition = 0;
    _completed = false;

    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _resetAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _resetController, curve: Curves.easeOut),
    )..addListener(() {
        setState(() {
          _dragPosition = _maxDragPosition * (1 - _resetAnimation.value);
        });
      });
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  void reset() {
    if (_completed) {
      setState(() {
        _completed = false;
      });
      _resetController.forward(from: 0);
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_completed && !_resetController.isAnimating) {
      setState(() {
        _dragPosition =
            (_dragPosition + details.delta.dx).clamp(0, _maxDragPosition);
      });
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_completed && !_resetController.isAnimating) {
      if (_dragPosition >= _thresholdPosition) {
        setState(() {
          _completed = true;
          _dragPosition = _maxDragPosition;
        });
        widget.onCompleted();
      } else {
        _resetController.forward(from: 0);
      }
    }
  }

  Widget _defaultSliderIcon() {
    return Icon(widget.sliderIcon, color: widget.iconColor);
  }

  Widget _defaultCompletedIcon() {
    return Icon(widget.completedIcon, color: widget.iconColor);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: _completed ? widget.completedColor : widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.height / 2),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            left: _dragPosition.clamp(0, _maxDragPosition),
            child: GestureDetector(
              onHorizontalDragUpdate: _handleDragUpdate,
              onHorizontalDragEnd: _handleDragEnd,
              child: SizedBox(
                width: _sliderSize,
                height: _sliderSize,
                // decoration: BoxDecoration(
                //   color: widget.sliderColor,
                //   borderRadius: BorderRadius.circular(_sliderSize / 2),
                //   boxShadow: [
                //     BoxShadow(
                //       color: Colors.black.withOpacity(0.2),
                //       blurRadius: 6,
                //       offset: const Offset(0, 3),
                //     ),
                //   ],
                // ),
                child: Center(
                  child: _completed
                      ? (widget.completedIconWidget ?? _defaultCompletedIcon())
                      : (widget.sliderIconWidget ?? _defaultSliderIcon()),
                ),
              ),
            ),
          ),
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                key: ValueKey(_completed),
                _completed ? widget.completedText : widget.text,
                style:
                    _completed ? widget.completedTextStyle : widget.textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

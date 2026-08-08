import 'package:flutter/material.dart';

/// Full-screen skeleton with shimmer — used as ScanLogin banner placeholder.
/// Always light (white) theme — does not follow system dark mode.
class BannerSkeletonPlaceholder extends StatelessWidget {
  const BannerSkeletonPlaceholder({super.key});

  static const Color _bg = Color(0xFFFFFFFF);
  static const Color _base = Color(0xFFE0E2E6);
  static const Color _highlight = Color(0xAAFFFFFF);

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: _bg,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 48, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: _ShimmerBox(radius: 20),
              ),
              SizedBox(height: 28),
              _ShimmerBox(height: 18, radius: 9),
              SizedBox(height: 14),
              FractionallySizedBox(
                widthFactor: 0.55,
                child: _ShimmerBox(height: 16, radius: 8),
              ),
              SizedBox(height: 12),
              FractionallySizedBox(
                widthFactor: 0.72,
                child: _ShimmerBox(height: 16, radius: 8),
              ),
              Spacer(flex: 2),
              Row(
                children: [
                  Expanded(
                    child: _ShimmerBox(height: 44, radius: 10),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _ShimmerBox(height: 44, radius: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatefulWidget {
  const _ShimmerBox({
    this.height,
    required this.radius,
  });

  final double? height;
  final double radius;

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1450),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(widget.radius);

    return AnimatedBuilder(
      animation: _controller,
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: BannerSkeletonPlaceholder._base,
          borderRadius: borderRadius,
        ),
      ),
      builder: (context, child) {
        return ClipRRect(
          borderRadius: borderRadius,
          child: ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (rect) {
              final shift = _controller.value * 2 - 1;
              return LinearGradient(
                begin: Alignment(-1.0 + shift, 0),
                end: Alignment(1.0 + shift, 0),
                colors: const [
                  Color(0x00FFFFFF),
                  BannerSkeletonPlaceholder._highlight,
                  Color(0x00FFFFFF),
                ],
                stops: const [0.2, 0.5, 0.8],
              ).createShader(rect);
            },
            child: child,
          ),
        );
      },
    );
  }
}

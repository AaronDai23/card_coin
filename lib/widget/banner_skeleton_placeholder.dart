import 'package:flutter/material.dart';

/// Full-screen skeleton with shimmer — used as ScanLogin banner placeholder.
class BannerSkeletonPlaceholder extends StatelessWidget {
  const BannerSkeletonPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final bg = isDark ? const Color(0xFF121212) : const Color(0xFFF2F3F5);

    return ColoredBox(
      color: bg,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                flex: 5,
                child: _ShimmerBox(radius: 20),
              ),
              const SizedBox(height: 28),
              const _ShimmerBox(height: 18, radius: 9),
              const SizedBox(height: 14),
              const FractionallySizedBox(
                widthFactor: 0.55,
                child: _ShimmerBox(height: 16, radius: 8),
              ),
              const SizedBox(height: 12),
              const FractionallySizedBox(
                widthFactor: 0.72,
                child: _ShimmerBox(height: 16, radius: 8),
              ),
              const Spacer(flex: 2),
              const Row(
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
    this.width,
    this.height,
    required this.radius,
  });

  final double? width;
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
    final isDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final base = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E2E6);
    final highlight =
        isDark ? const Color(0x44FFFFFF) : const Color(0xAAFFFFFF);
    final borderRadius = BorderRadius.circular(widget.radius);

    return AnimatedBuilder(
      animation: _controller,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: base,
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
                colors: [
                  const Color(0x00FFFFFF),
                  highlight,
                  const Color(0x00FFFFFF),
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

import 'package:flutter/material.dart';

class Skeleton extends StatefulWidget {
  const Skeleton({
    super.key,
    this.height,
    this.width,
    this.borderRadius = 12,
  });

  final double? height;
  final double? width;
  final double borderRadius;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final opacity = 0.16 + (_controller.value * 0.16);
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: colorScheme.surfaceVariant.withOpacity(opacity),
          ),
        );
      },
    );
  }
}

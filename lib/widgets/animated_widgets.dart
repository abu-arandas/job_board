import 'package:flutter/material.dart';

class FadeInSlideUp extends StatefulWidget {
  const FadeInSlideUp({
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.offset = 30.0,
  });
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double offset;

  @override
  State<FadeInSlideUp> createState() => _FadeInSlideUpState();
}

class _FadeInSlideUpState extends State<FadeInSlideUp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.offset),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, child) => Transform.translate(
      offset: _slideAnimation.value,
      child: Opacity(opacity: _fadeAnimation.value, child: widget.child),
    ),
  );
}

/// Enhanced animation widget with scale and bounce effects
class FadeInScaleUp extends StatefulWidget {
  const FadeInScaleUp({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.elasticOut,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;

  @override
  State<FadeInScaleUp> createState() => _FadeInScaleUpState();
}

class _FadeInScaleUpState extends State<FadeInScaleUp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 1.0, curve: widget.curve),
      ),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, child) => Transform.scale(
      scale: _scaleAnimation.value,
      child: Opacity(opacity: _fadeAnimation.value, child: widget.child),
    ),
  );
}

/// Staggered animation for lists
class StaggeredFadeInSlideUp extends StatelessWidget {
  const StaggeredFadeInSlideUp({
    super.key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 100),
    this.initialDelay = Duration.zero,
  });

  final List<Widget> children;
  final Duration staggerDelay;
  final Duration initialDelay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;

        return FadeInSlideUp(
          delay: initialDelay + Duration(milliseconds: staggerDelay.inMilliseconds * index),
          child: child,
        );
      }).toList(),
    );
  }
}

class ScaleInAnimation extends StatefulWidget {
  const ScaleInAnimation({
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 400),
    this.delay = Duration.zero,
    this.initialScale = 0.8,
  });
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double initialScale;

  @override
  State<ScaleInAnimation> createState() => _ScaleInAnimationState();
}

class _ScaleInAnimationState extends State<ScaleInAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _scaleAnimation = Tween<double>(
      begin: widget.initialScale,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, child) => Transform.scale(
      scale: _scaleAnimation.value,
      child: Opacity(opacity: _fadeAnimation.value, child: widget.child),
    ),
  );
}

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({required this.child, required this.isLoading, super.key, this.baseColor, this.highlightColor});
  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _animation = Tween<double>(
      begin: -1,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ShimmerLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !oldWidget.isLoading) {
      _controller.repeat();
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    final baseColor = widget.baseColor ?? Colors.grey[300]!;
    final highlightColor = widget.highlightColor ?? Colors.grey[100]!;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [baseColor, highlightColor, baseColor],
          stops: [
            (_animation.value - 1).clamp(0.0, 1.0),
            _animation.value.clamp(0.0, 1.0),
            (_animation.value + 1).clamp(0.0, 1.0),
          ],
        ).createShader(bounds),
        child: widget.child,
      ),
    );
  }
}

class PulseAnimation extends StatefulWidget {
  const PulseAnimation({
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 1000),
    this.minScale = 0.95,
    this.maxScale = 1.05,
  });
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _animation,
    builder: (context, child) => Transform.scale(scale: _animation.value, child: widget.child),
  );
}

class SlideInFromDirection extends StatefulWidget {
  const SlideInFromDirection({
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.direction = SlideDirection.left,
    this.distance = 100.0,
  });
  final Widget child;
  final Duration duration;
  final Duration delay;
  final SlideDirection direction;
  final double distance;

  @override
  State<SlideInFromDirection> createState() => _SlideInFromDirectionState();
}

class _SlideInFromDirectionState extends State<SlideInFromDirection> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    Offset beginOffset;
    switch (widget.direction) {
      case SlideDirection.left:
        beginOffset = Offset(-widget.distance, 0);
        break;
      case SlideDirection.right:
        beginOffset = Offset(widget.distance, 0);
        break;
      case SlideDirection.top:
        beginOffset = Offset(0, -widget.distance);
        break;
      case SlideDirection.bottom:
        beginOffset = Offset(0, widget.distance);
        break;
    }

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, child) => Transform.translate(
      offset: _slideAnimation.value,
      child: Opacity(opacity: _fadeAnimation.value, child: widget.child),
    ),
  );
}

enum SlideDirection { left, right, top, bottom }

class StaggeredList extends StatelessWidget {
  const StaggeredList({
    required this.children,
    super.key,
    this.itemDelay = const Duration(milliseconds: 100),
    this.itemDuration = const Duration(milliseconds: 600),
    this.scrollDirection = Axis.vertical,
  });
  final List<Widget> children;
  final Duration itemDelay;
  final Duration itemDuration;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) => Column(
    children: children.asMap().entries.map((entry) {
      final index = entry.key;
      final child = entry.value;

      return FadeInSlideUp(
        delay: Duration(milliseconds: index * itemDelay.inMilliseconds),
        duration: itemDuration,
        child: child,
      );
    }).toList(),
  );
}

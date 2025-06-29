import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientCard extends StatelessWidget {
  const GradientCard({
    required this.child,
    super.key,
    this.gradient,
    this.padding,
    this.margin,
    this.borderRadius,
    this.boxShadow,
  });
  final Widget child;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) => Container(
    margin: margin,
    decoration: BoxDecoration(
      gradient: gradient ?? AppTheme.primaryGradient,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      boxShadow:
          boxShadow ?? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
    ),
    child: Padding(padding: padding ?? const EdgeInsets.all(16), child: child),
  );
}

class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    super.key,
    this.padding,
    this.margin,
    this.borderRadius,
    this.opacity = 0.1,
    this.blur = 10.0,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double opacity;
  final double blur;

  @override
  Widget build(BuildContext context) => Container(
    margin: margin,
    decoration: BoxDecoration(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
          blurRadius: blur * 2,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
          blurRadius: blur,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(opacity),
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2), width: 1),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
            ),
          ),
          child: Padding(padding: padding ?? const EdgeInsets.all(16), child: child),
        ),
      ),
    ),
  );
}

class PremiumButton extends StatefulWidget {
  const PremiumButton({
    required this.text,
    super.key,
    this.onPressed,
    this.icon,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.borderRadius,
    this.isLoading = false,
    this.isOutlined = false,
    this.elevation = 4,
  });
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool isLoading;
  final bool isOutlined;
  final double elevation;

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _scaleAnimation,
    builder: (context, child) => Transform.scale(
      scale: _scaleAnimation.value,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.isLoading ? null : widget.onPressed,
        child: Container(
          padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            gradient: widget.isOutlined ? null : (widget.gradient ?? AppTheme.primaryGradient),
            color: widget.isOutlined ? Colors.transparent : widget.backgroundColor,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            border: widget.isOutlined ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) : null,
            boxShadow: widget.isOutlined
                ? null
                : [
                    BoxShadow(
                      color: (widget.gradient?.colors.first ?? widget.backgroundColor ?? AppTheme.primaryBlue)
                          .withOpacity(0.3),
                      blurRadius: widget.elevation,
                      offset: Offset(0, widget.elevation / 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(widget.textColor ?? Colors.white),
                  ),
                )
              else if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  color: widget.isOutlined ? Theme.of(context).colorScheme.primary : (widget.textColor ?? Colors.white),
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              if (!widget.isLoading)
                Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.isOutlined
                        ? Theme.of(context).colorScheme.primary
                        : (widget.textColor ?? Colors.white),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.text, required this.color, super.key, this.icon, this.isOutlined = false});
  final String text;
  final Color color;
  final IconData? icon;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: isOutlined ? Colors.transparent : color.withOpacity(0.1),
      border: isOutlined ? Border.all(color: color, width: 1.5) : null,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon, color: color, size: 14), const SizedBox(width: 4)],
        Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ],
    ),
  );
}

class ProgressIndicator extends StatelessWidget {
  const ProgressIndicator({
    required this.progress,
    super.key,
    this.backgroundColor,
    this.progressColor,
    this.height = 8,
    this.borderRadius,
    this.label,
  });
  final double progress;
  final Color? backgroundColor;
  final Color? progressColor;
  final double height;
  final BorderRadius? borderRadius;
  final String? label;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (label != null) ...[Text(label!, style: Theme.of(context).textTheme.bodySmall), const SizedBox(height: 4)],
      Container(
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  progressColor ?? AppTheme.primaryBlue,
                  (progressColor ?? AppTheme.primaryBlue).withOpacity(0.8),
                ],
              ),
              borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
            ),
          ),
        ),
      ),
    ],
  );
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
    this.iconColor,
    this.onTap,
    this.trailing,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (iconColor ?? Theme.of(context).colorScheme.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor ?? Theme.of(context).colorScheme.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    ),
  );
}

class StatCard extends StatelessWidget {
  const StatCard({
    required this.title,
    required this.value,
    required this.icon,
    super.key,
    this.color,
    this.subtitle,
    this.chart,
  });
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final String? subtitle;
  final Widget? chart;

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? Theme.of(context).colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: cardColor, size: 24),
                if (chart != null) Expanded(child: chart!),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: cardColor),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

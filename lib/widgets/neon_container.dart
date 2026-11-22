import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NeonContainer extends StatelessWidget {
  const NeonContainer({
    super.key, required this.child, this.neonColor = AppColors.neonCyan,
    this.width, this.height, this.borderRadius = 16, this.borderWidth = 2,
    this.backgroundColor, this.gradient, this.padding,
  });
  final Widget child;
  final Color neonColor;
  final double? width, height;
  final double borderRadius, borderWidth;
  final Color? backgroundColor;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Container(
    width: width, height: height, padding: padding ?? const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: gradient == null ? (backgroundColor ?? AppColors.navy) : null,
      gradient: gradient,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: neonColor, width: borderWidth),
      boxShadow: [
        BoxShadow(color: neonColor.withOpacity(.6), blurRadius: 20, spreadRadius: 2),
        BoxShadow(color: neonColor.withOpacity(.3), blurRadius: 40, spreadRadius: 4),
      ],
    ),
    child: child,
  );
}

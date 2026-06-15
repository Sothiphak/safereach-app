import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool isPressed;
  final Color? color;
  final BoxBorder? border;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding,
    this.margin,
    this.isPressed = false,
    this.color,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final baseColor = color ?? (isDark ? AppColors.darkBackground : AppColors.background);
    final shadowLight = isDark ? AppColors.darkLightShadow : AppColors.lightShadow;
    final shadowDark = isDark ? AppColors.darkDarkShadow : AppColors.darkShadow;

    return Container(
      margin: margin,
      padding: padding,
      decoration: isPressed
          ? BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: border ?? Border.all(color: isDark ? Colors.black38 : Colors.grey.shade300, width: 0.8),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [Colors.black26, baseColor]
                    : [Colors.grey.shade300, baseColor],
              ),
            )
          : BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: border,
              boxShadow: [
                BoxShadow(
                  color: shadowLight,
                  offset: const Offset(-5, -5),
                  blurRadius: 10,
                ),
                BoxShadow(
                  color: shadowDark,
                  offset: const Offset(5, 5),
                  blurRadius: 10,
                ),
              ],
            ),
      child: child,
    );
  }
}

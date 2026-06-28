import 'package:flutter/material.dart';
import 'neumorphic_button.dart';

class AppButton extends StatelessWidget {
  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isFullWidth = false,
  }) : _isPrimary = true;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isFullWidth = false,
  }) : _isPrimary = false;

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isFullWidth;
  final bool _isPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final buttonColor = _isPrimary ? theme.colorScheme.primary : null;
    final textColor = _isPrimary ? Colors.white : theme.colorScheme.primary;

    final childWidget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 52,
      child: NeumorphicButton(
        borderRadius: 16,
        onTap: onPressed,
        color: buttonColor,
        child: Center(child: childWidget),
      ),
    );
  }
}

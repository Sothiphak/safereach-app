import 'package:flutter/material.dart';

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
    final button = _isPrimary
        ? ElevatedButton.icon(
            onPressed: onPressed,
            icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
            label: Text(label),
          )
        : OutlinedButton.icon(
            onPressed: onPressed,
            icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
            label: Text(label),
          );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 48,
      child: icon == null
          ? (_isPrimary
              ? ElevatedButton(
                  onPressed: onPressed,
                  child: Text(label),
                )
              : OutlinedButton(
                  onPressed: onPressed,
                  child: Text(label),
                ))
          : button,
    );
  }
}

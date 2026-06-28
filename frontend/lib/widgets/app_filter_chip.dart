import 'package:flutter/material.dart';
import 'neumorphic_container.dart';
import 'neumorphic_button.dart';

class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.icon,
    this.selectedColor,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final IconData? icon;
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = selectedColor ?? theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.onSurface;

    final childWidget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: selected
                  ? activeColor
                  : inactiveColor.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: selected ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );

    if (selected) {
      return GestureDetector(
        onTap: () => onSelected(false),
        child: NeumorphicContainer(
          borderRadius: 14,
          isPressed: true,
          color: activeColor.withValues(alpha: 0.08),
          border: Border.all(
            color: activeColor.withValues(alpha: 0.45),
            width: 1.2,
          ),
          child: childWidget,
        ),
      );
    } else {
      return NeumorphicButton(
        borderRadius: 14,
        onTap: () => onSelected(true),
        child: childWidget,
      );
    }
  }
}

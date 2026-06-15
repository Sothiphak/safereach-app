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
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;

    final childWidget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: selected ? activeColor : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: selected ? activeColor : theme.colorScheme.onSurface,
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

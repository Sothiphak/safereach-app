import 'package:flutter/material.dart';
import 'neumorphic_container.dart';

class NeumorphicButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final BoxBorder? border;

  const NeumorphicButton({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = 24,
    this.padding,
    this.margin,
    this.color,
    this.border,
  });

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      setState(() => _isPressed = false);
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 70),
        child: NeumorphicContainer(
          borderRadius: widget.borderRadius,
          padding: widget.padding,
          margin: widget.margin,
          isPressed: _isPressed,
          color: widget.color,
          border: widget.border,
          child: widget.child,
        ),
      ),
    );
  }
}

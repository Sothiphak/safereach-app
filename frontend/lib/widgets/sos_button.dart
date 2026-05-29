import 'dart:math' as math;
import 'package:flutter/material.dart';

class SosButton extends StatefulWidget {
  const SosButton({super.key, required this.onPressed, this.size = 180});

  final VoidCallback onPressed;
  final double size;

  @override
  State<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends State<SosButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Semantics(
      label: 'Emergency SOS Button',
      hint: 'Double tap to activate emergency assistance',
      button: true,
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: BorderRadius.circular(widget.size),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ripple Ring 3 (Outer Pulsing Ring)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final progress = (_controller.value + 0.6) % 1.0;
                return Container(
                  width: widget.size * (1.0 + progress * 0.6),
                  height: widget.size * (1.0 + progress * 0.6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.15 * (1.0 - progress)),
                      width: 4,
                    ),
                    color: primaryColor.withValues(alpha: 0.08 * (1.0 - progress)),
                  ),
                );
              },
            ),
            // Ripple Ring 2 (Middle Pulsing Ring)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final progress = (_controller.value + 0.3) % 1.0;
                return Container(
                  width: widget.size * (1.0 + progress * 0.6),
                  height: widget.size * (1.0 + progress * 0.6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.25 * (1.0 - progress)),
                      width: 4,
                    ),
                    color: primaryColor.withValues(alpha: 0.12 * (1.0 - progress)),
                  ),
                );
              },
            ),
            // Ripple Ring 1 (Inner Pulsing Ring)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final progress = _controller.value;
                return Container(
                  width: widget.size * (1.0 + progress * 0.6),
                  height: widget.size * (1.0 + progress * 0.6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.35 * (1.0 - progress)),
                      width: 4,
                    ),
                    color: primaryColor.withValues(alpha: 0.18 * (1.0 - progress)),
                  ),
                );
              },
            ),
            // Inner Core Button Shadow/Glow (Pulsing Glow Size)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final glowIntensity = 0.3 + 0.2 * math.sin(_controller.value * 2 * math.pi);
                return Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: glowIntensity),
                        blurRadius: 20 + 8 * math.sin(_controller.value * 2 * math.pi),
                        spreadRadius: 2 + 3 * math.sin(_controller.value * 2 * math.pi),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Main Electric Indigo/Cyan Button Core with Breathing Scale
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final scale = 1.0 + 0.04 * math.sin(_controller.value * 2 * math.pi);
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          theme.colorScheme.secondary.withValues(alpha: 0.9),
                          primaryColor,
                          theme.colorScheme.primaryContainer,
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.emergency,
                            color: Colors.white,
                            size: 40,
                          ),
                          SizedBox(height: 6),
                          Text(
                            'SOS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

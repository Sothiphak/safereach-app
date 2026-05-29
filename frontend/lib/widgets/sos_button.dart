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
            // Ripple Ring 3
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
                      color: const Color(0xFFD32F2F).withValues(alpha: 0.15 * (1.0 - progress)),
                      width: 4,
                    ),
                    color: const Color(0xFFD32F2F).withValues(alpha: 0.08 * (1.0 - progress)),
                  ),
                );
              },
            ),
            // Ripple Ring 2
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
                      color: const Color(0xFFD32F2F).withValues(alpha: 0.25 * (1.0 - progress)),
                      width: 4,
                    ),
                    color: const Color(0xFFD32F2F).withValues(alpha: 0.12 * (1.0 - progress)),
                  ),
                );
              },
            ),
            // Ripple Ring 1
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
                      color: const Color(0xFFD32F2F).withValues(alpha: 0.35 * (1.0 - progress)),
                      width: 4,
                    ),
                    color: const Color(0xFFD32F2F).withValues(alpha: 0.18 * (1.0 - progress)),
                  ),
                );
              },
            ),
            // Inner Core Button Shadow/Glow
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD32F2F).withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
            ),
            // Main Red Button Core
            Container(
              width: widget.size,
              height: widget.size,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0xFFFF5252),
                    Color(0xFFD32F2F),
                    Color(0xFFB71C1C),
                  ],
                  stops: [0.0, 0.7, 1.0],
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
          ],
        ),
      ),
    );
  }
}

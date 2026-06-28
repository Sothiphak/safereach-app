import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/translations.dart';
import '../../widgets/neumorphic_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeIn),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final primaryColor = theme.colorScheme.primary;
    final softAccentColor = primaryColor.withValues(alpha: isDark ? 0.18 : 0.1);
    final screenSize = MediaQuery.sizeOf(context);
    final isCompact = screenSize.shortestSide < 380 || screenSize.height < 700;
    final logoSize = isCompact ? 78.0 : 96.0;
    final logoPadding = isCompact ? 20.0 : 26.0;
    final titleSize = isCompact ? 32.0 : 36.0;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          gradient: RadialGradient(
            center: const Alignment(0, -0.35),
            radius: 0.9,
            colors: [softAccentColor, backgroundColor],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: NeumorphicContainer(
                        borderRadius: 72,
                        padding: EdgeInsets.all(logoPadding),
                        color: isDark
                            ? theme.colorScheme.surface
                            : Colors.white,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor.withValues(alpha: 0.08),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/splash_logo.svg',
                            width: logoSize,
                            height: logoSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Opacity(
                    opacity: _fadeAnimation.value,
                    child: FractionalTranslation(
                      translation: _slideAnimation.value,
                      child: Column(
                        children: [
                          Text(
                            'SafeReach',
                            style: theme.textTheme.displayMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w900,
                              fontSize: titleSize,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'EMERGENCY SERVICES'.tr(context),
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

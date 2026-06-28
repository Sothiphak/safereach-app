import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../widgets/app_button.dart';
import '../../widgets/neumorphic_container.dart';
import '../../utils/translations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  final _slides = const [
    _OnboardingSlide(
      title: 'Instant Emergency Help',
      description:
          'Find the nearest police, hospital, fire station, or ambulance in seconds.',
      icon: Icons.emergency,
    ),
    _OnboardingSlide(
      title: 'One-Tap SOS',
      description:
          'Hit the big SOS button to quickly access critical contacts.',
      icon: Icons.sos,
    ),
    _OnboardingSlide(
      title: 'Preparedness Tips',
      description:
          'Learn first-aid steps and store personal emergency contacts.',
      icon: Icons.health_and_safety,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await context.read<AppState>().completeOnboarding();
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          gradient: RadialGradient(
            center: const Alignment(0, -0.45),
            radius: 0.95,
            colors: [
              primaryColor.withValues(alpha: isDark ? 0.16 : 0.08),
              backgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _slides.length,
                    onPageChanged: (value) => setState(() => _index = value),
                    itemBuilder: (context, index) {
                      final slide = _slides[index];
                      return Center(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: NeumorphicContainer(
                              borderRadius: 28,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 36,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Semantics(
                                    label: slide.title.tr(context),
                                    child: NeumorphicContainer(
                                      borderRadius: 64,
                                      padding: const EdgeInsets.all(24),
                                      color: isDark
                                          ? theme.colorScheme.surface
                                          : Colors.white,
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: primaryColor.withValues(
                                            alpha: 0.08,
                                          ),
                                        ),
                                        child: Icon(
                                          slide.icon,
                                          size: 60,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  Text(
                                    slide.title.tr(context),
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 24,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    slide.description.tr(context),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.7),
                                      height: 1.45,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                NeumorphicContainer(
                  borderRadius: 18,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _index == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _index == index
                              ? primaryColor
                              : primaryColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                AppButton.primary(
                  label: (_index == _slides.length - 1 ? 'Get started' : 'Next')
                      .tr(context),
                  onPressed: () async {
                    if (_index == _slides.length - 1) {
                      await _finish();
                    } else {
                      await _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  isFullWidth: true,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _finish,
                  child: Text(
                    'Skip'.tr(context),
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

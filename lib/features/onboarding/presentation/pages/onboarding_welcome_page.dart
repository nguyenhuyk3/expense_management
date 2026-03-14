import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/sizes.dart';
import '../widgets/onboarding_name_star_field.dart';
import '../widgets/onboarding_welcome_greeting.dart';

/// Shown after the user submits their name.
/// Displays a time-based greeting then auto-navigates to home.
class OnboardingWelcomePage extends StatefulWidget {
  final String name;

  const OnboardingWelcomePage({super.key, required this.name});

  @override
  State<OnboardingWelcomePage> createState() => _OnboardingWelcomePageState();
}

class _OnboardingWelcomePageState extends State<OnboardingWelcomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enter;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _fade = CurvedAnimation(parent: _enter, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _enter, curve: Curves.easeOut));

    // TODO: replace Placeholder() with actual Home page
    Future.delayed(const Duration(milliseconds: 2800), _navigateHome);
  }

  void _navigateHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const Scaffold(
          body: Center(child: Text('Home', style: TextStyle(color: Colors.white))),
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          const OnboardingNameStarField(),
          Center(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.wXLarge),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OnboardingWelcomeGreeting(name: widget.name),
                      const SizedBox(height: 52),
                      // Spinning loader ring
                      _SpinningRing(),
                      const SizedBox(height: Sizes.hLarge),
                      const Text(
                        'Đang vào ứng dụng...',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: Sizes.textSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpinningRing extends StatefulWidget {
  @override
  State<_SpinningRing> createState() => _SpinningRingState();
}

class _SpinningRingState extends State<_SpinningRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Transform.rotate(
        angle: _c.value * 2 * 3.14159,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border(
              top: BorderSide(color: AppColors.primary, width: 3),
              right: BorderSide(color: AppColors.inputBorderIdle, width: 3),
              bottom: BorderSide(color: AppColors.inputBorderIdle, width: 3),
              left: BorderSide(color: AppColors.inputBorderIdle, width: 3),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/sizes.dart';

/// Ba chấm nhảy bounce dùng cho màn hình Splash của Onboarding.
class OnboardingSplashDots extends StatefulWidget {
  const OnboardingSplashDots({super.key});

  @override
  State<OnboardingSplashDots> createState() => _OnboardingSplashDotsState();
}

class _OnboardingSplashDotsState extends State<OnboardingSplashDots>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(3, (i) {
      final c = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );

      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          c.repeat(reverse: true);
        }
      });

      return c;
    });

    _anims = _controllers
        .map(
          (c) => Tween<double>(
            begin: 1.0,
            end: 0.35,
          ).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut)),
        )
        .toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: FadeTransition(
            opacity: _anims[i],
            child: ScaleTransition(
              scale: _anims[i].drive(Tween<double>(begin: 1.0, end: 0.6)),
              child: Container(
                width: Sizes.dotSmall,
                height: Sizes.dotSmall,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

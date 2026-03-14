import 'dart:math';

import 'package:flutter/material.dart';

/// Nền trang trí với các chấm/ngôi sao cho màn hình Onboarding.
class OnboardingNameStarField extends StatelessWidget {
  const OnboardingNameStarField({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final rng = Random(42); // Seed cố định → vị trí ổn định giữa các lần build

    return Stack(
      children: List.generate(20, (i) {
        final left = rng.nextDouble() * size.width;
        final top = rng.nextDouble() * size.height;
        final dotSize = rng.nextDouble() * 4 + 2;
        final opacity = 0.15 + rng.nextDouble() * 0.25;

        return Positioned(
          left: left,
          top: top,
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: opacity),
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}

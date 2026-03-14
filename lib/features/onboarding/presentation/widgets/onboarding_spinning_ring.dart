import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/sizes.dart';

/// Vòng tròn xoay dùng làm spinner tải.
class OnboardingSpinningRing extends StatefulWidget {
  const OnboardingSpinningRing({super.key});

  @override
  State<OnboardingSpinningRing> createState() => _OnboardingSpinningRingState();
}

class _OnboardingSpinningRingState extends State<OnboardingSpinningRing>
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
        angle: _c.value * 2 * math.pi,
        child: Container(
          width: Sizes.spinnerSize,
          height: Sizes.spinnerSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border(
              top: BorderSide(
                color: AppColors.primary,
                width: Sizes.borderThick,
              ),
              right: BorderSide(
                color: AppColors.inputBorderIdle,
                width: Sizes.borderThick,
              ),
              bottom: BorderSide(
                color: AppColors.inputBorderIdle,
                width: Sizes.borderThick,
              ),
              left: BorderSide(
                color: AppColors.inputBorderIdle,
                width: Sizes.borderThick,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

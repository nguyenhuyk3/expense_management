import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/sizes.dart';
import 'onboarding_fade_up_widget.dart';
import 'onboarding_splash_dots.dart';
import 'onboarding_splash_logo.dart';

/// Phần thương hiệu trung tâm của màn hình Splash:
/// logo, tên ứng dụng, khẩu hiệu và ba chấm nhảy.
class OnboardingSplashBrand extends StatelessWidget {
  final int phase;

  const OnboardingSplashBrand({super.key, required this.phase});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const OnboardingSplashLogo(),

        const SizedBox(height: Sizes.hXLarge),
        // Tên ứng dụng
        OnboardingFadeUpWidget(
          delay: const Duration(milliseconds: 150),
          child: const Text(
            'Spendly',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: Sizes.text3XLarge,
              color: AppColors.textAppName,
              letterSpacing: -1,
            ),
          ),
        ),
        // Khẩu hiệu
        AnimatedOpacity(
          opacity: phase >= 1 ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: AnimatedSlide(
            offset: phase >= 1 ? Offset.zero : const Offset(0, 0.4),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            child: Padding(
              padding: const EdgeInsets.only(top: Sizes.hMedium),
              child: Text(
                'Quản lý chi tiêu thông minh',
                style: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.8),
                  fontSize: Sizes.textRegular,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ),
        // Ba chấm nhảy
        AnimatedOpacity(
          opacity: phase >= 1 ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 400),
          child: Padding(
            padding: const EdgeInsets.only(top: Sizes.hXLarge + Sizes.hLarge),
            child: phase >= 1
                ? const OnboardingSplashDots()
                : const SizedBox(height: Sizes.dotSmall),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/sizes.dart';
import 'onboarding_spinning_ring.dart';
import 'onboarding_welcome_greeting.dart';

/// Nội dung trung tâm của màn hình chào mừng:
/// lời chào theo giờ, spinner tải và chú thích.
class OnboardingWelcomeContent extends StatelessWidget {
  final String name;

  const OnboardingWelcomeContent({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.wXLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OnboardingWelcomeGreeting(name: name),
          
          const SizedBox(height: Sizes.emojiMedium),
          const OnboardingSpinningRing(),
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
    );
  }
}

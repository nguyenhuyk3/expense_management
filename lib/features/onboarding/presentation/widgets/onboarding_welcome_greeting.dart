import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/sizes.dart';

/// Time-based greeting card for the Onboarding Welcome page.
class OnboardingWelcomeGreeting extends StatelessWidget {
  final String name;

  const OnboardingWelcomeGreeting({super.key, required this.name});

  static ({String greeting, String emoji}) _resolveTime() {
    final hour = DateTime.now().hour;
    if (hour < 12) return (greeting: 'Chào buổi sáng', emoji: '☀️');
    if (hour < 18) return (greeting: 'Chào buổi chiều', emoji: '🌤️');
    return (greeting: 'Chào buổi tối', emoji: '🌙');
  }

  @override
  Widget build(BuildContext context) {
    final (:greeting, :emoji) = _resolveTime();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 72)),
        const SizedBox(height: Sizes.hXLarge),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: Sizes.textXLarge + 4,
              height: 1.3,
            ),
            children: [
              TextSpan(
                text: '$greeting,\n',
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              TextSpan(
                text: '$name!',
                style: const TextStyle(color: AppColors.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: Sizes.hLarge),
        const Text(
          'Chào mừng bạn đến với Spendly 🎉\nHãy cùng quản lý tài chính thật thông minh!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: Sizes.textRegular,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

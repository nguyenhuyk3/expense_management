import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/sizes.dart';

/// Emoji + tiêu đề + phụ đề cho trang nhập tên Onboarding.
class OnboardingNameHeader extends StatelessWidget {
  const OnboardingNameHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '👋',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: Sizes.emojiMedium),
        ),

        const SizedBox(height: Sizes.hLarge),

        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(
              fontSize: Sizes.text3XLarge,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
            children: [
              TextSpan(
                text: 'Chúng tôi gọi\n',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              TextSpan(
                text: 'bạn là gì?',
                style: TextStyle(color: AppColors.primary),
              ),
            ],
          ),
        ),

        const SizedBox(height: Sizes.hLarge),

        const Text(
          'Nhập tên hoặc biệt danh của bạn.\nChúng tôi sẽ dùng tên này để chào hỏi bạn.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: Sizes.textRegular,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

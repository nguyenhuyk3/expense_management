import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/sizes.dart';

/// Khung nhập tên trên trang nhập tên Onboarding.
class OnboardingNameTextField extends StatelessWidget {
  final TextEditingController controller;
  final int maxLength;
  final ValueChanged<String> onChanged;

  const OnboardingNameTextField({
    super.key,
    required this.controller,
    required this.maxLength,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(Sizes.hMedium),
        border: Border.all(
          color: AppColors.inputBorder,
          width: Sizes.borderThin,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.wLarge,
        vertical: Sizes.hMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TÊN CỦA BẠN',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: Sizes.textSmall,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLength: maxLength,
                  onChanged: onChanged,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: Sizes.textLarge,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    hintText: 'Nhập tên...',
                    hintStyle: TextStyle(color: AppColors.textHint),
                  ),
                  cursorColor: AppColors.primary,
                ),
              ),

              Text(
                '${controller.text.length}/$maxLength',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: Sizes.textSmall,
                ),
              ),
            ],
          ),

          Container(height: Sizes.borderThin, color: AppColors.inputBorder),
        ],
      ),
    );
  }
}

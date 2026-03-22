import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';
import '../../domain/entities/expense_category.dart';

/// Widget nút danh mục mở bottom sheet chọn danh mục
class AddExpenseCategoryButton extends StatelessWidget {
  final ExpenseCategory? category;
  final VoidCallback onTap;

  const AddExpenseCategoryButton({
    super.key,
    this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.wLarge,
          vertical: Sizes.hLarge - 3,
        ),
        decoration: BoxDecoration(
          color: category != null
              ? category!.color.withOpacity(0.08)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(Sizes.hLarge - 2),
          border: Border.all(
            color: category != null
                ? category!.color.withOpacity(0.35)
                : AppColors.inputBorderIdle,
          ),
        ),
        child: Row(
          children: [
            if (category != null) ...[
              Text(
                category!.icon,
                style: const TextStyle(fontSize: Sizes.textLarge),
              ),

              const SizedBox(width: Sizes.wMedium + 2),

              Text(
                category!.label,
                style: TextStyle(
                  color: category!.color,
                  fontSize: Sizes.textRegular,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ] else ...[
              const Icon(
                Icons.grid_view_rounded,
                color: AppColors.textHint,
                size: Sizes.textMedium + 1,
              ),

              const SizedBox(width: Sizes.wMedium),

              const Text(
                'Chọn danh mục',
                style: TextStyle(
                  color: AppColors.textHint,
                  fontSize: Sizes.textRegular,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],

            const Spacer(),

            Icon(
              Icons.chevron_right_rounded,
              color: category != null
                  ? category!.color.withOpacity(0.7)
                  : AppColors.textHint.withOpacity(0.6),
              size: Sizes.textLarge,
            ),
          ],
        ),
      ),
    );
  }
}

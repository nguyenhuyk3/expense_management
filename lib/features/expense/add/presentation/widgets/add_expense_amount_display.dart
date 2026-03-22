import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';
import '../../domain/entities/expense_category.dart';
import 'add_expense_constants.dart';

/// Amount Display widget hiển thị số tiền và danh mục đã nhập hiện tại.
/// Nhấn vào vùng danh mục bên phải để mở bottom sheet chọn danh mục.
class AddExpenseAmountDisplay extends StatelessWidget {
  final int amount;
  final ExpenseCategory? category;
  final VoidCallback onCategoryTap;

  const AddExpenseAmountDisplay({
    super.key,
    required this.amount,
    required this.onCategoryTap,
    // ignore: avoid_init_to_null — nullable vì người dùng chưa chọn danh mục
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.wLarge,
        vertical: Sizes.hLarge - 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(Sizes.hLarge),
        border: Border.all(
          color: amount > 0
              ? (category?.color.withOpacity(0.45) ??
                    AppColors.primary.withOpacity(0.35))
              : AppColors.inputBorderIdle,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '₫',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: Sizes.textLarge,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(width: Sizes.wMedium),

          Expanded(
            child: Text(
              amount > 0 ? formatCurrencyAmount(amount) : '0',
              style: TextStyle(
                color: amount > 0 ? AppColors.textPrimary : AppColors.textHint,
                fontSize: Sizes.text2XLarge,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.5,
              ),
            ),
          ),

          GestureDetector(
            onTap: onCategoryTap,
            child: category != null
                ? AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.wMedium + 2,
                      vertical: Sizes.hSmall,
                    ),
                    decoration: BoxDecoration(
                      color: category!.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(Sizes.textLarge),
                      border: Border.all(
                        color: category!.color.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          category!.icon,
                          style: const TextStyle(fontSize: Sizes.textSmall + 1),
                        ),

                        const SizedBox(width: Sizes.wSmall),

                        Text(
                          category!.label,
                          style: TextStyle(
                            color: category!.color,
                            fontSize: Sizes.textSmall - 1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  )
                : const Text(
                    'Chọn danh mục',
                    style: TextStyle(
                      color: AppColors.textHint,
                      fontSize: Sizes.textSmall,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

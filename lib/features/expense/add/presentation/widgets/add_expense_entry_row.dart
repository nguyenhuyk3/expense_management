import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';
import '../../domain/entities/expense_category.dart';
import '../bloc/add_expense_state.dart';
import 'add_expense_constants.dart';

/// Entry Row widget để hiển thị từng mục chi phí
class AddExpenseEntryRow extends StatelessWidget {
  final ExpenseEntry entry;
  final ExpenseCategory category;
  final String payIcon;
  final String payLabel;
  final VoidCallback onRemove;

  /// Callback when tapping the row to start or cancel editing
  final VoidCallback onTap;

  /// True when this row is in editing mode
  final bool isEditing;

  const AddExpenseEntryRow({
    super.key,
    required this.entry,
    required this.category,
    required this.payIcon,
    required this.payLabel,
    required this.onRemove,
    required this.onTap,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.wLarge - 4,
          vertical: Sizes.hMedium + 2,
        ),
        decoration: BoxDecoration(
          color: isEditing
              ? AppColors.primary.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(Sizes.hLarge / 2),
          border: Border.all(
            color: isEditing
                ? AppColors.primary.withOpacity(0.45)
                : const Color(0xFF12152A),
            width: isEditing ? Sizes.borderThin : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: Sizes.categoryHeight,
              height: Sizes.categoryHeight,
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(Sizes.hLarge / 2 - 2),
                border: Border.all(color: category.color.withOpacity(0.2)),
              ),
              child: Center(
                child: Text(
                  category.icon,
                  style: const TextStyle(fontSize: Sizes.textLarge - 4),
                ),
              ),
            ),

            const SizedBox(width: Sizes.wMedium + 2),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            category.label,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: Sizes.textSmall + 1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          if (isEditing) ...[
                            const SizedBox(width: Sizes.wSmall + 2),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.wSmall + 2,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.4),
                                ),
                              ),
                              child: const Text(
                                'đang sửa',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '−${formatCurrencyAmount(entry.amount)}',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: Sizes.textMedium - 1,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            const TextSpan(
                              text: ' ₫',
                              style: TextStyle(
                                color: AppColors.textHint,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: Sizes.hSmall + 1),

                  Row(
                    children: [
                      Text(
                        '$payIcon $payLabel',
                        style: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: Sizes.textSmall - 1,
                        ),
                      ),

                      if (entry.note.isNotEmpty) ...[
                        const SizedBox(width: Sizes.wSmall + 2),

                        const Text(
                          '·',
                          style: TextStyle(
                            color: AppColors.inputBorderIdle,
                            fontSize: 10,
                          ),
                        ),

                        const SizedBox(width: Sizes.wSmall + 2),

                        Expanded(
                          child: Text(
                            entry.note,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textHint,
                              fontSize: Sizes.textSmall - 1,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: Sizes.wMedium),

            GestureDetector(
              onTap: onRemove,
              child: Container(
                width: Sizes.sheetHandleWidth,
                height: Sizes.sheetHandleWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.hLarge),
                  border: Border.all(color: AppColors.inputBorderIdle),
                ),
                child: const Center(
                  child: Text(
                    '✕',
                    style: TextStyle(color: AppColors.textHint, fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

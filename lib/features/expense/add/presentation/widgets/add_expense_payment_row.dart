import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';
import '../../domain/entities/expense_category.dart';

/// Payment Row widget để chọn phương thức thanh toán và bật/tắt ghi chú
class AddExpensePaymentRow extends StatelessWidget {
  final String selectedPayment;
  final bool hasNote;
  final bool noteOpen;
  final void Function(String id) onPaymentTap;
  final VoidCallback onNoteTap;

  const AddExpensePaymentRow({
    super.key,
    required this.selectedPayment,
    required this.hasNote,
    required this.noteOpen,
    required this.onPaymentTap,
    required this.onNoteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...ExpenseCategory.paymentMethods.map((p) {
          final sel = selectedPayment == p['id'];

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: Sizes.wSmall + 2),
              child: GestureDetector(
                onTap: () => onPaymentTap(p['id']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.hMedium + 1,
                  ),
                  decoration: BoxDecoration(
                    color: sel
                        ? AppColors.primary.withOpacity(0.08)
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(Sizes.hLarge / 2 - 1),
                    border: Border.all(
                      color: sel
                          ? AppColors.primary.withOpacity(0.4)
                          : AppColors.inputBorderIdle,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        p['icon']!,
                        style: const TextStyle(fontSize: Sizes.textMedium - 1),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        p['label']!,
                        style: TextStyle(
                          color: sel ? AppColors.primary : AppColors.textHint,
                          fontSize: Sizes.textSmall - 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        // Note toggle
        GestureDetector(
          onTap: onNoteTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.hMedium + 1,
              horizontal: Sizes.wLarge,
            ),
            decoration: BoxDecoration(
              color: noteOpen || hasNote
                  ? AppColors.primary.withOpacity(0.08)
                  : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(Sizes.hLarge / 2 - 1),
              border: Border.all(
                color: noteOpen || hasNote
                    ? AppColors.primary.withOpacity(0.4)
                    : AppColors.inputBorderIdle,
              ),
            ),
            child: Column(
              children: [
                const Text(
                  '📝',
                  style: TextStyle(fontSize: Sizes.textMedium - 1),
                ),

                const SizedBox(height: 2),

                Text(
                  hasNote ? 'Có ghi chú' : 'Ghi chú',
                  style: TextStyle(
                    color: noteOpen || hasNote
                        ? AppColors.primary
                        : AppColors.textHint,
                    fontSize: Sizes.textSmall - 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

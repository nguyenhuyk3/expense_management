import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';
import 'add_expense_constants.dart';

/// Numpad widget để nhập số tiền
class AddExpenseNumpad extends StatelessWidget {
  final void Function(String key) onKey;

  const AddExpenseNumpad({super.key, required this.onKey});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (row) => Padding(
          padding: EdgeInsets.only(top: row > 0 ? Sizes.hSmall + 1 : 0),
          child: Row(
            children: List.generate(3, (col) {
              final k = kAddExpenseKeys[row * 3 + col];

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: col > 0 ? Sizes.wSmall + 1 : 0,
                  ),
                  child: AddExpenseNumKey(label: k, onTap: () => onKey(k)),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

/// Tiện ích phím số đơn giản với label và callback khi nhấn
class AddExpenseNumKey extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const AddExpenseNumKey({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDel = label == '⌫';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(Sizes.hLarge / 2 - 1),
          border: Border.all(color: AppColors.inputBorderIdle.withOpacity(0.8)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isDel ? AppColors.primary : AppColors.textPrimary,
              fontSize: isDel ? Sizes.textMedium : Sizes.textMedium + 2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

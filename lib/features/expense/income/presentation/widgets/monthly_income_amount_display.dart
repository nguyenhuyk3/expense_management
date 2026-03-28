import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';
import '../../../../../features/expense/add/presentation/widgets/add_expense_constants.dart';

/// Card hiển thị số tiền thu nhập đang nhập hoặc đang xem.
///
/// Khi [isInputMode] = true → hiển thị con trỏ nhấp nháy và số đang nhập.
/// Khi [isInputMode] = false → hiển thị thu nhập đã lưu (read-only).
class MonthlyIncomeAmountDisplay extends StatefulWidget {
  final String amountRaw;
  final bool isInputMode;

  const MonthlyIncomeAmountDisplay({
    super.key,
    required this.amountRaw,
    required this.isInputMode,
  });

  @override
  State<MonthlyIncomeAmountDisplay> createState() =>
      _MonthlyIncomeAmountDisplayState();
}

class _MonthlyIncomeAmountDisplayState extends State<MonthlyIncomeAmountDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _cursorController;

  @override
  void initState() {
    super.initState();

    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cursorController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final amount = int.tryParse(widget.amountRaw) ?? 0;
    final displayText = amount > 0 ? formatCurrencyAmount(amount) : '0';
    final isEmpty = widget.amountRaw.isEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Sizes.wLarge),
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.wXLarge,
        vertical: Sizes.hXLarge,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(Sizes.radiusCard),
        border: Border.all(
          color: AppColors.borderSubtle,
          width: Sizes.borderThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'THU NHẬP THÁNG NÀY',
            style: TextStyle(
              color: AppColors.textHint,
              fontSize: Sizes.textSmall,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: Sizes.hMedium),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '₫',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: Sizes.text3XLarge,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),

              const SizedBox(width: Sizes.wSmall),

              Text(
                displayText,
                style: TextStyle(
                  color: isEmpty
                      ? AppColors.inputBorderIdle
                      : AppColors.textAppName,
                  fontSize: Sizes.text3XLarge,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  height: 1,
                ),
              ),
              if (widget.isInputMode) ...[
                const SizedBox(width: Sizes.wSmall),

                FadeTransition(
                  opacity: _cursorController,
                  child: Container(
                    width: Sizes.cursorWidth,
                    height: Sizes.text3XLarge,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(Sizes.cursorWidth),
                    ),
                  ),
                ),
              ],
            ],
          ),

          if (amount >= 1000000) ...[
            const SizedBox(height: Sizes.hSmall),

            Text(
              '≈ ${formatCurrencyAmount(amount ~/ 1000)}K · '
              '${formatCurrencyAmount(amount ~/ 30)}/ngày',
              style: const TextStyle(
                color: AppColors.success,
                fontSize: Sizes.textSmall,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

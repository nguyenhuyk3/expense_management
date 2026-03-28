import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';
import '../../../../../features/expense/add/presentation/widgets/add_expense_constants.dart';

/// Danh sách preset thu nhập nhanh (5tr, 8tr, 12tr, 20tr, 30tr).
class MonthlyIncomeQuickPresets extends StatelessWidget {
  final String selectedAmountRaw;
  final ValueChanged<String> onPresetSelected;

  const MonthlyIncomeQuickPresets({
    super.key,
    required this.selectedAmountRaw,
    required this.onPresetSelected,
  });

  static const List<int> _presets = [
    5000000,
    8000000,
    12000000,
    20000000,
    30000000,
  ];

  String _label(int value) {
    if (value >= 1000000) {
      return '${value ~/ 1000000}tr';
    }

    return '${value ~/ 1000}k';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.wLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CHỌN NHANH',
            style: TextStyle(
              color: AppColors.textHint,
              fontSize: Sizes.textSmall,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: Sizes.hMedium),

          Wrap(
            spacing: Sizes.wMedium,
            runSpacing: Sizes.hMedium,
            children: _presets.map((preset) {
              final isSelected = selectedAmountRaw == preset.toString();

              return GestureDetector(
                onTap: () => onPresetSelected(preset.toString()),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.wLarge,
                    vertical: Sizes.hSmall + 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(Sizes.radiusButton),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.inputBorderIdle,
                      width: Sizes.borderThin,
                    ),
                  ),
                  child: Text(
                    '${_label(preset)} — ${formatCurrencyAmount(preset)} ₫',
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textHint,
                      fontSize: Sizes.textSmall,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

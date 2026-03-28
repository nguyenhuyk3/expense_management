import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';
import '../../domain/entities/monthly_income_entity.dart';

/// Tiêu đề điều hướng tháng, hiển thị kỳ hiện tại và mũi tên trái/phải.
class MonthlyIncomeMonthNavigator extends StatelessWidget {
  final String period;
  final String currentPeriod;
  final ValueChanged<String> onPeriodChanged;

  const MonthlyIncomeMonthNavigator({
    super.key,
    required this.period,
    required this.currentPeriod,
    required this.onPeriodChanged,
  });

  static const int _maxMonthsBack = 11;

  bool get _canGoBack {
    final oldest = MonthlyIncomePeriodHelper.shift(
      currentPeriod,
      -_maxMonthsBack,
    );

    return !MonthlyIncomePeriodHelper.isBefore(period, oldest) &&
        period != oldest;
  }

  bool get _canGoForward => period != currentPeriod;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Sizes.wLarge),
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.wMedium,
        vertical: Sizes.hMedium,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(Sizes.radiusInput),
        border: Border.all(
          color: AppColors.borderSubtle,
          width: Sizes.borderThin,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ArrowButton(
            icon: Icons.chevron_left_rounded,
            enabled: _canGoBack,
            onTap: () =>
                onPeriodChanged(MonthlyIncomePeriodHelper.shift(period, -1)),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                MonthlyIncomePeriodHelper.displayName(period),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: Sizes.textMedium,
                  fontWeight: FontWeight.w700,
                ),
              ),

              if (period == currentPeriod)
                const Text(
                  'Tháng hiện tại',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: Sizes.textSmall,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),

          _ArrowButton(
            icon: Icons.chevron_right_rounded,
            enabled: _canGoForward,
            onTap: () =>
                onPeriodChanged(MonthlyIncomePeriodHelper.shift(period, 1)),
          ),
        ],
      ),
    );
  }
}

/// Nút mũi tên trái/phải trong MonthlyIncomeMonthNavigator.
class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _ArrowButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(Sizes.radiusMedium),
          border: Border.all(
            color: enabled ? AppColors.inputBorderIdle : AppColors.borderSubtle,
            width: Sizes.borderThin,
          ),
        ),
        child: Icon(
          icon,
          size: Sizes.iconMedium,
          color: enabled ? AppColors.textSecondary : AppColors.textHint,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';
import '../cubit/monthly_income_cubit.dart';

/// Thanh tiến trình mỏng — vàng khi có dữ liệu thu nhập, xám khi chưa.
class MonthlyIncomeProgressBar extends StatelessWidget {
  final MonthlyIncomeLoaded state;

  const MonthlyIncomeProgressBar({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Sizes.wLarge,
        Sizes.hMedium,
        Sizes.wLarge,
        0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Sizes.progressBarHeight),
        child: LinearProgressIndicator(
          value: state.hasExistingIncome ? 1.0 : 0.5,
          minHeight: Sizes.progressBarHeight,
          backgroundColor: AppColors.borderSubtle,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
    );
  }
}

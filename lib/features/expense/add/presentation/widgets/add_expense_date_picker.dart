import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';
import '../bloc/add_expense_bloc.dart';

/// Date picker widget cho phép người dùng chọn ngày cho các khoản chi tiêu.
class AddExpenseDatePicker extends StatelessWidget {
  const AddExpenseDatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExpenseBloc, AddExpenseState>(
      buildWhen: (p, c) => p.selectedDate != c.selectedDate,
      builder: (ctx, state) {
        final date = state.effectiveDate;
        final now = DateTime.now();
        final isToday =
            date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;

        return GestureDetector(
          onTap: () => _pickDate(ctx, date),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.wLarge,
              vertical: Sizes.hLarge - 5,
            ),
            decoration: BoxDecoration(
              color: isToday
                  ? AppColors.cardBackground
                  : AppColors.primary.withOpacity(0.07),
              borderRadius: BorderRadius.circular(Sizes.hLarge),
              border: Border.all(
                color: isToday
                    ? AppColors.inputBorderIdle
                    : AppColors.primary.withOpacity(0.45),
              ),
            ),
            child: Row(
              children: [
                // Icon lịch
                Container(
                  width: Sizes.text3XLarge + 2,
                  height: Sizes.text3XLarge + 2,
                  decoration: BoxDecoration(
                    color: isToday
                        ? AppColors.inputBorderIdle.withOpacity(0.6)
                        : AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(Sizes.hMedium + 2),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.calendar_month_rounded,
                      color: isToday ? AppColors.textHint : AppColors.primary,
                      size: Sizes.textMedium + 1,
                    ),
                  ),
                ),

                const SizedBox(width: Sizes.wLarge - 4),
                // Label + date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ngày chi tiêu',
                        style: TextStyle(
                          color: isToday
                              ? AppColors.textHint
                              : AppColors.primary.withOpacity(0.7),
                          fontSize: Sizes.textSmall - 2,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        _formatLabel(date, now),
                        style: TextStyle(
                          color: isToday
                              ? AppColors.textPrimary
                              : AppColors.primary,
                          fontSize: Sizes.textRegular,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                // Nút "Hôm nay" — chỉ hiện khi đang chọn ngày khác
                if (!isToday) ...[
                  GestureDetector(
                    onTap: () => ctx.read<AddExpenseBloc>().add(
                      DateSelected(date: _todayOnly()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.wMedium + 1,
                        vertical: Sizes.hSmall + 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(Sizes.hMedium + 2),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: const Text(
                        'Hôm nay',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: Sizes.textSmall - 1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: Sizes.wMedium),
                ],

                Icon(
                  Icons.chevron_right_rounded,
                  color: isToday
                      ? AppColors.textHint
                      : AppColors.primary.withOpacity(0.7),
                  size: Sizes.textMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Trả về label hiển thị thân thiện (Hôm nay / Hôm qua / dd/MM/yyyy)
  String _formatLabel(DateTime date, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    final diff = today.difference(d).inDays;

    if (diff == 0) {
      return 'Hôm nay';
    }

    if (diff == 1) {
      return 'Hôm qua';
    }

    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Ngày hôm nay ở 00:00 (chỉ phần date, không có giờ)
  DateTime _todayOnly() {
    final now = DateTime.now();

    return DateTime(now.year, now.month, now.day);
  }

  /// Mở Material DatePicker với custom dark theme
  Future<void> _pickDate(BuildContext context, DateTime currentDate) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      helpText: 'CHỌN NGÀY CHI TIÊU',
      confirmText: 'XÁC NHẬN',
      cancelText: 'HUỶ',
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
            primary: AppColors.primary,
            onPrimary: AppColors.scaffoldBackground,
            surface: AppColors.cardBackground,
            onSurface: AppColors.textPrimary,
            secondary: AppColors.primary,
            onSecondary: AppColors.scaffoldBackground,
            outline: AppColors.inputBorderIdle,
          ),
          dialogBackgroundColor: AppColors.inputBorderIdle,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          dividerColor: AppColors.inputBorderIdle,
        ),
        child: child!,
      ),
    );

    if (picked != null && context.mounted) {
      context.read<AddExpenseBloc>().add(DateSelected(date: picked));
    }
  }
}

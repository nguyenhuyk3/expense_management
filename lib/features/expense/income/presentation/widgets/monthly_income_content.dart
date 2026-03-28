import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/sizes.dart';
import '../cubit/monthly_income_cubit.dart';

import 'monthly_income_action_button.dart';
import 'monthly_income_amount_display.dart';
import 'monthly_income_header.dart';
import 'monthly_income_month_navigator.dart';
import 'monthly_income_numpad.dart';
import 'monthly_income_progress_bar.dart';

/// Nội dung chính của màn hình thu nhập khi đã load xong dữ liệu.
class MonthlyIncomeContent extends StatelessWidget {
  final MonthlyIncomeLoaded state;

  const MonthlyIncomeContent({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MonthlyIncomeCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header với tiêu đề thay đổi theo trạng thái
        MonthlyIncomeHeader(
          hasExistingIncome: state.hasExistingIncome,
          isEditing: state.isEditing,
        ),
        // Thanh tiến trình
        MonthlyIncomeProgressBar(state: state),

        const SizedBox(height: Sizes.hLarge),
        // Điều hướng tháng
        MonthlyIncomeMonthNavigator(
          period: state.period,
          currentPeriod: state.currentPeriod,
          onPeriodChanged: (p) => cubit.changePeriod(period: p),
        ),

        const SizedBox(height: Sizes.hLarge),
        // Hiển thị số tiền
        MonthlyIncomeAmountDisplay(
          amountRaw: state.amountRaw,
          isInputMode: state.isInputMode,
        ),

        const SizedBox(height: Sizes.hLarge),
        // Numpad chiếm toàn bộ không gian còn lại
        if (state.isInputMode) ...[
          Expanded(
            child: MonthlyIncomeNumpad(
              onKey: (k) => cubit.handleNumpadKey(key: k),
            ),
          ),
        ] else ...[
          const Spacer(),
        ],

        const SizedBox(height: Sizes.hLarge),
        // Nút hành động
        MonthlyIncomeActionButton(
          canSave: state.canSave,
          hasExistingIncome: state.hasExistingIncome,
          isEditing: state.isEditing,
          onSave: cubit.saveOrUpdateIncome,
          onStartEdit: cubit.startEditing,
          onCancelEdit: cubit.cancelEditing,
        ),

        const SizedBox(height: Sizes.hLarge),
      ],
    );
  }
}

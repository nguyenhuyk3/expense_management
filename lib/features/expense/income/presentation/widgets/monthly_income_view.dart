import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/colors.dart';
import '../cubit/monthly_income_cubit.dart';

import 'monthly_income_content.dart';

/// Scaffold bọc toàn bộ màn hình thu nhập và lắng nghe state từ Cubit.
class MonthlyIncomeView extends StatelessWidget {
  const MonthlyIncomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: BlocConsumer<MonthlyIncomeCubit, MonthlyIncomeState>(
          listener: (context, state) {
            if (state is MonthlyIncomeFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is MonthlyIncomeInitial ||
                state is MonthlyIncomeLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state is MonthlyIncomeSaving) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state is MonthlyIncomeLoaded) {
              return MonthlyIncomeContent(state: state);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

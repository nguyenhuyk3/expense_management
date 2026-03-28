import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';
import '../cubit/monthly_income_cubit.dart';
import '../widgets/monthly_income_view.dart';

/// Màn hình nhập / chỉnh sửa thu nhập hàng tháng.
///
/// - Nếu tháng hiện tại chưa có dữ liệu → cho phép nhập mới.
/// - Nếu đã có dữ liệu → hiển thị và cho phép chỉnh sửa.
/// - Có thanh điều hướng để xem các tháng trước.
class MonthlyIncomePage extends StatelessWidget {
  const MonthlyIncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MonthlyIncomeCubit>()..init(),
      child: const MonthlyIncomeView(),
    );
  }
}

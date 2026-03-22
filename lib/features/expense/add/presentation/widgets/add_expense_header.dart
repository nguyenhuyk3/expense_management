import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';
import '../bloc/add_expense_bloc.dart';
import 'add_expense_circle_btn.dart';

/// Header widget màn hình Thêm chi phí
/// Hiển thị nút quay lại, tiêu đề và số lượng mục trong phiên
class AddExpenseHeader extends StatelessWidget {
  const AddExpenseHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExpenseBloc, AddExpenseState>(
      buildWhen: (p, c) => p.sessionEntries.length != c.sessionEntries.length,
      builder: (ctx, state) => Padding(
        padding: const EdgeInsets.fromLTRB(
          Sizes.wLarge + 4,
          Sizes.hLarge - 4,
          Sizes.wLarge + 4,
          Sizes.hMedium,
        ),
        child: Row(
          children: [
            AddExpenseCircleBtn(
              onTap: () => Navigator.maybePop(context),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textHint,
                size: Sizes.textMedium - 1,
              ),
            ),

            const Spacer(),

            const Text(
              'Ghi chi tiêu',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: Sizes.textLarge - 2,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),

            const Spacer(),

            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.wMedium + 2,
                vertical: Sizes.hSmall + 2,
              ),
              decoration: BoxDecoration(
                color: state.sessionEntries.isNotEmpty
                    ? AppColors.primary.withOpacity(0.12)
                    : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(Sizes.hMedium + 2),
                border: Border.all(
                  color: state.sessionEntries.isNotEmpty
                      ? AppColors.primary.withOpacity(0.35)
                      : AppColors.inputBorderIdle,
                ),
              ),
              child: Text(
                state.sessionEntries.isNotEmpty
                    ? '${state.sessionEntries.length} mục'
                    : '0',
                style: TextStyle(
                  color: state.sessionEntries.isNotEmpty
                      ? AppColors.primary
                      : AppColors.textHint,
                  fontSize: Sizes.textSmall,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

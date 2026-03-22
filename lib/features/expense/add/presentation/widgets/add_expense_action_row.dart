import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';
import '../../domain/entities/expense_category.dart';
import '../bloc/add_expense_bloc.dart';

/// Action Row widget cho các nút Thêm/Cập nhật và Lưu tất cả
class AddExpenseActionRow extends StatelessWidget {
  final AddExpenseState state;
  final ExpenseCategory? category;
  final VoidCallback onAdd;
  final VoidCallback onSaveAll;

  const AddExpenseActionRow({
    super.key,
    required this.state,
    required this.category,
    required this.onAdd,
    required this.onSaveAll,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onAdd,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: Sizes.hLarge - 1),
                decoration: BoxDecoration(
                  gradient: state.canAdd
                      ? const LinearGradient(
                          colors: [
                            AppColors.primary,
                            Color(0xFFE8C96A),
                            AppColors.primary,
                          ],
                        )
                      : null,
                  color: state.canAdd ? null : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(Sizes.hLarge),
                  boxShadow: state.canAdd
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    state.canAdd
                        ? (state.isEditing
                              ? '✓ Cập nhật${category != null ? " · Mục ${category!.label.toLowerCase()}" : ""}'
                              : '+ Thêm${category != null ? " · Mục ${category!.label.toLowerCase()}" : ""}')
                        : 'Chọn danh mục & nhập tiền',
                    style: TextStyle(
                      color: state.canAdd
                          ? AppColors.scaffoldBackground
                          : AppColors.textHint,
                      fontWeight: FontWeight.w800,
                      fontSize: Sizes.textRegular,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: Sizes.wMedium),

          if (state.isEditing) ...[
            GestureDetector(
              onTap: () => context.read<AddExpenseBloc>().add(
                const ExpenseEditCancelled(),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.wLarge,
                  vertical: Sizes.hLarge - 5,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(Sizes.hLarge),
                  border: Border.all(color: AppColors.error.withOpacity(0.45)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '✕',
                      style: TextStyle(fontSize: Sizes.textLarge - 4),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'Huỷ',
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: Sizes.textSmall - 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            GestureDetector(
              onTap: onSaveAll,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.wLarge,
                  vertical: Sizes.hLarge - 5,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(Sizes.hLarge),
                  border: Border.all(
                    color: state.sessionEntries.isNotEmpty
                        ? AppColors.success.withOpacity(0.5)
                        : AppColors.inputBorderIdle,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.done_all_rounded,
                      color: state.sessionEntries.isNotEmpty
                          ? AppColors.success
                          : AppColors.textHint,
                      size: Sizes.textLarge - 2,
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'Lưu hết',
                      style: TextStyle(
                        color: state.sessionEntries.isNotEmpty
                            ? AppColors.success
                            : AppColors.textHint,
                        fontSize: Sizes.textSmall - 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

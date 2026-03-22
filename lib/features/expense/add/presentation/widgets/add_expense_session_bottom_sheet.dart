import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';
import '../../domain/entities/expense_category.dart';
import '../bloc/add_expense_bloc.dart';
import 'add_expense_constants.dart';

/// Bottom Sheet hiển thị preview tất cả khoản chi tiêu trong phiên
/// Nhấn vào 1 khoản để bắt đầu chỉnh sửa nó
class AddExpenseSessionBottomSheet extends StatelessWidget {
  const AddExpenseSessionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExpenseBloc, AddExpenseState>(
      builder: (ctx, state) {
        final total = state.sessionEntries.fold(0, (s, e) => s + e.amount);

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.72,
          ),
          decoration: const BoxDecoration(
            color: AppColors.scaffoldBackground,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Sizes.radiusLarge + 2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: Sizes.hLarge),
              Container(
                width: Sizes.sheetHandleWidth,
                height: Sizes.hSmall,
                decoration: BoxDecoration(
                  color: AppColors.inputBorderIdle,
                  borderRadius: BorderRadius.circular(Sizes.hSmall),
                ),
              ),

              const SizedBox(height: Sizes.hLarge + 4),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.wLarge + 4,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Chi tiêu phiên này',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: Sizes.textMedium,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          '${state.sessionEntries.length} khoản',
                          style: const TextStyle(
                            color: AppColors.textHint,
                            fontSize: Sizes.textSmall - 1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '−${formatCurrencyAmount(total)}',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: Sizes.textLarge,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const TextSpan(
                            text: ' ₫',
                            style: TextStyle(
                              color: AppColors.textHint,
                              fontSize: Sizes.textSmall + 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: Sizes.hLarge - 2),

              const Divider(height: 1, thickness: 1, color: Color(0xFF12152A)),

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Sizes.wLarge + 4,
                  Sizes.hMedium + 2,
                  Sizes.wLarge + 4,
                  2,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.touch_app_rounded,
                      color: AppColors.textHint.withOpacity(0.7),
                      size: Sizes.textSmall + 1,
                    ),

                    const SizedBox(width: Sizes.wMedium),

                    const Text(
                      'Nhấn vào khoản để chỉnh sửa',
                      style: TextStyle(
                        color: AppColors.textHint,
                        fontSize: Sizes.textSmall - 1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                  shrinkWrap: true,
                  itemCount: state.sessionEntries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (_, i) {
                    final entry = state.sessionEntries[i];
                    final category = ExpenseCategory.findById(
                      entry.categoryId,
                    )!;
                    final payment = ExpenseCategory.paymentMethods.firstWhere(
                      (p) => p['id'] == entry.paymentMethod,
                      orElse: () => {
                        'id': entry.paymentMethod,
                        'icon': '💵',
                        'label': entry.paymentMethod,
                      },
                    );

                    return _buildEntryTile(
                      sheetCtx: ctx,
                      entry: entry,
                      category: category,
                      payIcon: payment['icon']!,
                      payLabel: payment['label']!,
                      isEditing: state.editingEntryId == entry.id,
                    );
                  },
                ),
              ),

              const SizedBox(height: Sizes.hLarge - 2),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.wLarge),
                child: GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: Sizes.hMedium + 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(Sizes.hLarge),
                      border: Border.all(color: AppColors.inputBorderIdle),
                    ),
                    child: const Center(
                      child: Text(
                        'Đóng',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: Sizes.textRegular,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).padding.bottom + Sizes.hLarge,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Tile hiển thị thông tin 1 khoản; nhấn để chỉnh sửa và đóng sheet
  Widget _buildEntryTile({
    required BuildContext sheetCtx,
    required ExpenseEntry entry,
    required ExpenseCategory category,
    required String payIcon,
    required String payLabel,
    required bool isEditing,
  }) {
    return GestureDetector(
      onTap: () {
        final bloc = sheetCtx.read<AddExpenseBloc>();

        Navigator.pop(sheetCtx);

        bloc.add(ExpenseEditStarted(id: entry.id));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.wLarge,
          vertical: Sizes.hMedium + 1,
        ),
        decoration: BoxDecoration(
          color: isEditing
              ? AppColors.primary.withOpacity(0.06)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(Sizes.hLarge),
          border: Border.all(
            color: isEditing
                ? AppColors.primary.withOpacity(0.45)
                : AppColors.inputBorderIdle,
            width: isEditing ? Sizes.borderThin : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: Sizes.categoryHeight,
              height: Sizes.categoryHeight,
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(Sizes.hLarge / 2 - 1),
                border: Border.all(color: category.color.withOpacity(0.1)),
              ),
              child: Center(
                child: Text(
                  category.icon,
                  style: const TextStyle(fontSize: Sizes.textLarge - 2),
                ),
              ),
            ),

            const SizedBox(width: Sizes.wMedium),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        category.label,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: Sizes.textSmall + 1,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      if (isEditing) ...[
                        const SizedBox(width: Sizes.wSmall + 2),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.wSmall + 2,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.4),
                            ),
                          ),
                          child: const Text(
                            'đang sửa',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: Sizes.hSmall - 1),

                  Row(
                    children: [
                      Text(
                        '$payIcon $payLabel',
                        style: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: Sizes.textSmall - 1,
                        ),
                      ),
                      if (entry.note.isNotEmpty) ...[
                        const SizedBox(width: Sizes.wSmall + 2),

                        const Text(
                          '·',
                          style: TextStyle(
                            color: AppColors.inputBorderIdle,
                            fontSize: 10,
                          ),
                        ),

                        const SizedBox(width: Sizes.wSmall + 2),

                        Expanded(
                          child: Text(
                            entry.note,
                            style: const TextStyle(
                              color: AppColors.textHint,
                              fontSize: Sizes.textSmall - 1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: Sizes.wMedium),

            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '−${formatCurrencyAmount(entry.amount)}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: Sizes.textMedium - 1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const TextSpan(
                    text: ' ₫',
                    style: TextStyle(
                      color: AppColors.textHint,
                      fontSize: Sizes.textSmall + 1,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: Sizes.wMedium),

            Icon(
              Icons.edit_rounded,
              color: AppColors.textHint,
              size: Sizes.textSmall + 2,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';
import '../../domain/entities/expense_category.dart';
import '../bloc/add_expense_bloc.dart';
import 'add_expense_constants.dart';
import 'add_expense_entry_row.dart';
import 'add_expense_session_bottom_sheet.dart';

/// Session List widget để hiển thị các khoản chi phí phát sinh
class AddExpenseSessionList extends StatelessWidget {
  final GlobalKey<AnimatedListState> listKey;

  const AddExpenseSessionList({super.key, required this.listKey});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExpenseBloc, AddExpenseState>(
      buildWhen: (p, c) => p.sessionEntries != c.sessionEntries,
      builder: (ctx, state) {
        if (state.sessionEntries.isEmpty) {
          return _buildEmptyState();
        }

        final total = state.sessionEntries.fold(0, (s, e) => s + e.amount);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Sizes.wLarge,
                Sizes.hSmall + 2,
                Sizes.wLarge,
                Sizes.hSmall,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hôm nay · ${state.sessionEntries.length} khoản',
                    style: const TextStyle(
                      color: AppColors.textHint,
                      fontSize: Sizes.textSmall,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '−${formatCurrencyAmount(total)}',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: Sizes.textRegular,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const TextSpan(
                          text: ' ₫',
                          style: TextStyle(
                            color: AppColors.textHint,
                            fontSize: Sizes.textSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(14, 2, 14, 8),
                itemCount: state.sessionEntries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (ctx, i) {
                  final entry = state.sessionEntries[i];
                  final category = ExpenseCategory.findById(entry.categoryId)!;
                  final payment = ExpenseCategory.paymentMethods.firstWhere(
                    (p) => p['id'] == entry.paymentMethod,
                    orElse: () => {
                      'id': entry.paymentMethod,
                      'icon': '💵',
                      'label': entry.paymentMethod,
                    },
                  );
                  final isEditingThis = state.editingEntryId == entry.id;

                  return AddExpenseEntryRow(
                    entry: entry,
                    category: category,
                    payIcon: payment['icon']!,
                    payLabel: payment['label']!,
                    isEditing: isEditingThis,
                    onTap: () => _showSessionBottomSheet(ctx),
                    onRemove: () => ctx.read<AddExpenseBloc>().add(
                      ExpenseRemoved(id: entry.id),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Widget hiển thị trạng thái trống
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('📋', style: TextStyle(fontSize: Sizes.text3XLarge)),

          const SizedBox(height: Sizes.hMedium),

          const Text(
            'Chưa có khoản nào.\nNhập bên dưới và nhấn + để thêm.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textHint,
              fontSize: Sizes.textRegular,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  /// Mở Bottom Sheet preview tất cả khoản chi tiêu trong phiên
  void _showSessionBottomSheet(BuildContext context) {
    final bloc = context.read<AddExpenseBloc>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: const AddExpenseSessionBottomSheet(),
      ),
    );
  }
}

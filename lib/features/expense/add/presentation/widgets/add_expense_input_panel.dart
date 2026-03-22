import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';
import '../../domain/entities/expense_category.dart';
import '../bloc/add_expense_bloc.dart';
import 'add_expense_action_row.dart';
import 'add_expense_amount_display.dart';
import 'add_expense_category_bottom_sheet.dart';
import 'add_expense_date_picker.dart';
import 'add_expense_numpad.dart';
import 'add_expense_payment_row.dart';

/// Input Panel widget để nhập số tiền, danh mục, phương thức thanh toán và ghi chú
class AddExpenseInputPanel extends StatelessWidget {
  final TextEditingController noteController;
  final bool noteOpen;
  final VoidCallback onToggleNote;
  final VoidCallback onAdd;

  const AddExpenseInputPanel({
    super.key,
    required this.noteController,
    required this.noteOpen,
    required this.onToggleNote,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExpenseBloc, AddExpenseState>(
      builder: (ctx, state) {
        final cat = state.selectedCategoryId != null
            ? ExpenseCategory.findById(state.selectedCategoryId!)
            : null;

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            Sizes.wLarge,
            Sizes.hSmall + 2,
            Sizes.wLarge,
            0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AddExpenseDatePicker(),

              const SizedBox(height: Sizes.hSmall),

              AddExpenseAmountDisplay(
                amount: state.numericAmount,
                category: cat,
                onCategoryTap: () => _openCategorySheet(ctx, context, state),
              ),

              const SizedBox(height: Sizes.hSmall),

              AddExpensePaymentRow(
                selectedPayment: state.paymentMethod,
                hasNote: state.note.isNotEmpty,
                noteOpen: noteOpen,
                onPaymentTap: (id) => ctx.read<AddExpenseBloc>().add(
                  PaymentMethodSelected(paymentMethod: id),
                ),
                onNoteTap: onToggleNote,
              ),

              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: noteOpen
                    ? Padding(
                        padding: const EdgeInsets.only(top: Sizes.hSmall),
                        child: TextField(
                          controller: noteController,
                          autofocus: true,
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: Sizes.textSmall + 1,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Ghi chú nhanh...',
                            hintStyle: const TextStyle(
                              color: AppColors.textHint,
                              fontSize: Sizes.textSmall + 1,
                            ),
                            filled: true,
                            fillColor: AppColors.cardBackground,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: Sizes.wLarge - 2,
                              vertical: Sizes.hMedium + 2,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                Sizes.hLarge / 2 - 1,
                              ),
                              borderSide: const BorderSide(
                                color: AppColors.inputBorderIdle,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                Sizes.hLarge / 2 - 1,
                              ),
                              borderSide: const BorderSide(
                                color: AppColors.inputBorderIdle,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                Sizes.hLarge / 2 - 1,
                              ),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1,
                              ),
                            ),
                          ),
                          onChanged: (v) => ctx.read<AddExpenseBloc>().add(
                            NoteChanged(note: v),
                          ),
                          onEditingComplete: () {
                            FocusScope.of(ctx).unfocus();
                            Future.delayed(
                              const Duration(milliseconds: 200),
                              onToggleNote,
                            );
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              if (!noteOpen) ...[
                const SizedBox(height: Sizes.hSmall),

                AddExpenseNumpad(
                  onKey: (k) {
                    HapticFeedback.selectionClick();
                    ctx.read<AddExpenseBloc>().add(AmountKeyPressed(key: k));
                  },
                ),

                const SizedBox(height: Sizes.hSmall),

                AddExpenseActionRow(
                  state: state,
                  category: cat,
                  onAdd: () {
                    if (!state.canAdd) return;
                    ctx.read<AddExpenseBloc>().add(const ExpenseAdded());
                    HapticFeedback.mediumImpact();
                    onAdd();
                  },
                  onSaveAll: () =>
                      ctx.read<AddExpenseBloc>().add(const ExpenseSavedAll()),
                ),

                const SizedBox(height: Sizes.hMedium),
              ] else ...[
                const SizedBox(height: Sizes.hSmall),

                AddExpenseActionRow(
                  state: state,
                  category: cat,
                  onAdd: () {
                    if (!state.canAdd) return;
                    ctx.read<AddExpenseBloc>().add(const ExpenseAdded());
                    HapticFeedback.mediumImpact();
                    onAdd();
                  },
                  onSaveAll: () =>
                      ctx.read<AddExpenseBloc>().add(const ExpenseSavedAll()),
                ),

                const SizedBox(height: Sizes.hMedium),
              ],
            ],
          ),
        );
      },
    );
  }

  /// Mở trang chọn danh mục ở cuối trang
  void _openCategorySheet(
    BuildContext blocCtx,
    BuildContext rootCtx,
    AddExpenseState state,
  ) {
    final bloc = blocCtx.read<AddExpenseBloc>();

    showModalBottomSheet(
      context: rootCtx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AddExpenseCategoryBottomSheet(
        selectedId: bloc.state.selectedCategoryId,
        onSelect: (id) {
          final newId = id == bloc.state.selectedCategoryId ? null : id;

          bloc.add(CategorySelected(categoryId: newId));

          Navigator.pop(rootCtx);
        },
      ),
    );
  }
}

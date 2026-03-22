import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/expense_detail_entity.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/usecases/add_expense_usecase.dart';
import '../../domain/usecases/delete_expense_usecase.dart';
import '../../domain/usecases/get_expenses_usecase.dart';
import 'add_expense_event.dart';
import 'add_expense_state.dart';

export 'add_expense_event.dart';
export 'add_expense_state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  final AddExpenseUseCase addExpenseUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;
  final GetExpensesUseCase getExpensesUseCase;

  int _counter = 0;

  AddExpenseBloc({
    required this.addExpenseUseCase,
    required this.deleteExpenseUseCase,
    required this.getExpensesUseCase,
  }) : super(const AddExpenseState()) {
    on<AmountKeyPressed>(_onAmountKeyPressed);
    on<CategorySelected>(_onCategorySelected);
    on<PaymentMethodSelected>(_onPaymentMethodSelected);
    on<NoteChanged>(_onNoteChanged);
    on<ExpenseAdded>(_onExpenseAdded);
    on<ExpenseRemoved>(_onExpenseRemoved);
    on<ExpenseSavedAll>(_onExpenseSavedAll);
    on<ExpenseEditStarted>(_onExpenseEditStarted);
    on<ExpenseEditCancelled>(_onExpenseEditCancelled);
    on<DateSelected>(_onDateSelected);
  }

  void _onAmountKeyPressed(
    AmountKeyPressed event,
    Emitter<AddExpenseState> emit,
  ) {
    final k = event.key;
    var raw = state.amountRaw;

    if (k == '⌫') {
      raw = raw.isEmpty ? '' : raw.substring(0, raw.length - 1);
    } else {
      final combined = (raw + k).replaceFirst(RegExp(r'^0+(?=\d)'), '');

      if (combined.length > 11) {
        return;
      }

      raw = combined;
    }

    emit(state.copyWith(amountRaw: raw));
  }

  void _onCategorySelected(
    CategorySelected event,
    Emitter<AddExpenseState> emit,
  ) {
    emit(state.copyWith(selectedCategoryId: event.categoryId));
  }

  void _onPaymentMethodSelected(
    PaymentMethodSelected event,
    Emitter<AddExpenseState> emit,
  ) {
    emit(state.copyWith(paymentMethod: event.paymentMethod));
  }

  void _onNoteChanged(NoteChanged event, Emitter<AddExpenseState> emit) {
    emit(state.copyWith(note: event.note));
  }

  void _onExpenseAdded(ExpenseAdded event, Emitter<AddExpenseState> emit) {
    if (!state.canAdd) {
      return;
    }

    if (state.isEditing) {
      // Cập nhật khoản đang được chỉnh sửa
      final updatedEntries = state.sessionEntries.map((e) {
        if (e.id != state.editingEntryId) {
          return e;
        }

        return ExpenseEntry(
          id: e.id,
          amount: state.numericAmount,
          categoryId: state.selectedCategoryId!,
          paymentMethod: state.paymentMethod,
          note: state.note.trim(),
        );
      }).toList();

      emit(
        state.copyWith(
          sessionEntries: updatedEntries,
          clearEditingEntryId: true,
          amountRaw: '',
          note: '',
        ),
      );

      return;
    }

    final id = 'entry_${_counter++}_${DateTime.now().millisecondsSinceEpoch}';
    // final now = DateTime.now();
    // final date = state.effectiveDate;
    // Dùng ngày người dùng chọn, nhưng giữ lại giờ/phút/giây hiện tại để sắp xếp
    // final createdAt = DateTime(
    //   date.year,
    //   date.month,
    //   date.day,
    //   now.hour,
    //   now.minute,
    //   now.second,
    // );
    final entry = ExpenseEntry(
      id: id,
      amount: state.numericAmount,
      categoryId: state.selectedCategoryId!,
      paymentMethod: state.paymentMethod,
      note: state.note.trim(),
    );

    emit(
      state.copyWith(
        sessionEntries: [entry, ...state.sessionEntries],
        amountRaw: '',
        note: '',
      ),
    );
  }

  void _onExpenseRemoved(ExpenseRemoved event, Emitter<AddExpenseState> emit) {
    emit(
      state.copyWith(
        sessionEntries: state.sessionEntries
            .where((e) => e.id != event.id)
            .toList(),
      ),
    );
  }

  Future<void> _onExpenseSavedAll(
    ExpenseSavedAll event,
    Emitter<AddExpenseState> emit,
  ) async {
    if (state.sessionEntries.isEmpty) {
      return;
    }

    emit(state.copyWith(status: AddExpenseStatus.loading));

    for (final entry in state.sessionEntries) {
      final result = await addExpenseUseCase(
        AddExpenseParams(
          expense: ExpenseEntity(id: entry.id, createdAt: state.effectiveDate),
          detail: ExpenseDetailEntity(
            expenseId: entry.id,
            amount: entry.amount,
            categoryId: entry.categoryId,
            paymentMethod: entry.paymentMethod,
            note: entry.note,
          ),
        ),
      );

      if (result.isLeft()) {
        emit(
          state.copyWith(
            status: AddExpenseStatus.failure,
            errorMessage: 'Có lỗi khi lưu chi tiêu',
          ),
        );

        return;
      }
    }

    emit(
      state.copyWith(
        status: AddExpenseStatus.success,
        allSaved: true,
        sessionEntries: [],
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(status: AddExpenseStatus.initial, allSaved: false));
  }

  void _onExpenseEditStarted(
    ExpenseEditStarted event,
    Emitter<AddExpenseState> emit,
  ) {
    final entry = state.sessionEntries.firstWhere((e) => e.id == event.id);

    emit(
      state.copyWith(
        editingEntryId: event.id,
        amountRaw: entry.amount.toString(),
        selectedCategoryId: entry.categoryId,
        paymentMethod: entry.paymentMethod,
        note: entry.note,
      ),
    );
  }

  void _onExpenseEditCancelled(
    ExpenseEditCancelled event,
    Emitter<AddExpenseState> emit,
  ) {
    emit(state.copyWith(clearEditingEntryId: true, amountRaw: '', note: ''));
  }

  void _onDateSelected(DateSelected event, Emitter<AddExpenseState> emit) {
    emit(state.copyWith(selectedDate: event.date));
  }
}

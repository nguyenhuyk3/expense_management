import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:expense_management/core/error/failure.dart';
import 'package:expense_management/features/expense/add/domain/usecases/add_expense_usecase.dart';
import 'package:expense_management/features/expense/add/domain/usecases/delete_expense_usecase.dart';
import 'package:expense_management/features/expense/add/domain/usecases/get_expenses_usecase.dart';
import 'package:expense_management/features/expense/add/presentation/bloc/add_expense_bloc.dart';

class MockAddExpenseUseCase extends Mock implements AddExpenseUseCase {}

class MockDeleteExpenseUseCase extends Mock implements DeleteExpenseUseCase {}

class MockGetExpensesUseCase extends Mock implements GetExpensesUseCase {}

// Mock Params để match trong mocktail
class FakeAddExpenseParams extends Fake implements AddExpenseParams {}

void main() {
  late AddExpenseBloc addExpenseBloc;
  late MockAddExpenseUseCase mockAddExpenseUseCase;
  late MockDeleteExpenseUseCase mockDeleteExpenseUseCase;
  late MockGetExpensesUseCase mockGetExpensesUseCase;

  setUpAll(() {
    registerFallbackValue(FakeAddExpenseParams());
  });

  setUp(() {
    mockAddExpenseUseCase = MockAddExpenseUseCase();
    mockDeleteExpenseUseCase = MockDeleteExpenseUseCase();
    mockGetExpensesUseCase = MockGetExpensesUseCase();

    addExpenseBloc = AddExpenseBloc(
      addExpenseUseCase: mockAddExpenseUseCase,
      deleteExpenseUseCase: mockDeleteExpenseUseCase,
      getExpensesUseCase: mockGetExpensesUseCase,
    );
  });

  tearDown(() {
    addExpenseBloc.close();
  });

  group('AddExpenseBloc Tests', () {
    test('Initial state is correct', () {
      expect(addExpenseBloc.state, const AddExpenseState());
    });

    group('Input Events', () {
      blocTest<AddExpenseBloc, AddExpenseState>(
        'Gửi amountRaw được cập nhật khi thêm sự kiện AmountKeyPressed',
        build: () => addExpenseBloc,
        act: (bloc) => bloc.add(const AmountKeyPressed(key: '5')),
        expect: () => [const AddExpenseState(amountRaw: '5')],
      );

      blocTest<AddExpenseBloc, AddExpenseState>(
        'Xử lý phím xóa đúng trong amountRaw',
        build: () => addExpenseBloc,
        seed: () => const AddExpenseState(amountRaw: '123'),
        act: (bloc) => bloc.add(const AmountKeyPressed(key: '⌫')),
        expect: () => [const AddExpenseState(amountRaw: '12')],
      );

      blocTest<AddExpenseBloc, AddExpenseState>(
        'Gửi selectedCategoryId khi chọn danh mục',
        build: () => addExpenseBloc,
        act: (bloc) => bloc.add(const CategorySelected(categoryId: 'cat_1')),
        expect: () => [const AddExpenseState(selectedCategoryId: 'cat_1')],
      );

      blocTest<AddExpenseBloc, AddExpenseState>(
        'Cập nhật phương thức thanh toán khi PaymentMethodSelected',
        build: () => addExpenseBloc,
        act: (bloc) =>
            bloc.add(const PaymentMethodSelected(paymentMethod: 'card')),
        expect: () => [const AddExpenseState(paymentMethod: 'card')],
      );

      blocTest<AddExpenseBloc, AddExpenseState>(
        'Cập nhật note khi NoteChanged',
        build: () => addExpenseBloc,
        act: (bloc) => bloc.add(const NoteChanged(note: 'Ghi chú thử')),
        expect: () => [const AddExpenseState(note: 'Ghi chú thử')],
      );
    });

    group('Expense Session Logic', () {
      blocTest<AddExpenseBloc, AddExpenseState>(
        'Thêm entry vào sessionEntries và xóa input khi ExpenseAdded',
        build: () => addExpenseBloc,
        seed: () => const AddExpenseState(
          amountRaw: '50000',
          selectedCategoryId: 'food',
          note: 'Ăn trưa',
        ),
        act: (bloc) => bloc.add(const ExpenseAdded()),
        expect: () => [
          predicate<AddExpenseState>((state) {
            return state.sessionEntries.length == 1 &&
                state.sessionEntries.first.amount == 50000 &&
                state.amountRaw == '' &&
                state.note == '';
          }),
        ],
      );

      blocTest<AddExpenseBloc, AddExpenseState>(
        'Khi chỉnh sửa và nhấn thêm sẽ cập nhật entry đang chỉnh sửa',
        build: () => addExpenseBloc,
        seed: () => AddExpenseState(
          sessionEntries: [
            const ExpenseEntry(
              id: 'e1',
              amount: 100,
              categoryId: 'old',
              paymentMethod: 'cash',
              note: 'old note',
            ),
          ],
          editingEntryId: 'e1',
          amountRaw: '250',
          selectedCategoryId: 'cat_edit',
          paymentMethod: 'card',
          note: 'updated',
        ),
        act: (bloc) => bloc.add(const ExpenseAdded()),
        expect: () => [
          predicate<AddExpenseState>((s) {
            return s.sessionEntries.length == 1 &&
                s.sessionEntries.first.id == 'e1' &&
                s.sessionEntries.first.amount == 250 &&
                s.sessionEntries.first.categoryId == 'cat_edit' &&
                s.amountRaw == '' &&
                s.note == '' &&
                s.editingEntryId == null;
          }),
        ],
      );

      blocTest<AddExpenseBloc, AddExpenseState>(
        'Xóa entry khi ExpenseRemoved',
        build: () => addExpenseBloc,
        seed: () => AddExpenseState(
          sessionEntries: [
            const ExpenseEntry(
              id: 'a',
              amount: 1,
              categoryId: 'c1',
              paymentMethod: 'cash',
              note: '',
            ),
            const ExpenseEntry(
              id: 'b',
              amount: 2,
              categoryId: 'c2',
              paymentMethod: 'cash',
              note: '',
            ),
          ],
        ),
        act: (bloc) => bloc.add(const ExpenseRemoved(id: 'a')),
        expect: () => [
          predicate<AddExpenseState>(
            (s) =>
                s.sessionEntries.length == 1 &&
                s.sessionEntries.first.id == 'b',
          ),
        ],
      );

      blocTest<AddExpenseBloc, AddExpenseState>(
        'Hủy chỉnh sửa xóa editingEntryId, amountRaw và note',
        build: () => addExpenseBloc,
        seed: () => const AddExpenseState(
          editingEntryId: 'x',
          amountRaw: '123',
          note: 'a',
        ),
        act: (bloc) => bloc.add(const ExpenseEditCancelled()),
        expect: () => [
          const AddExpenseState(editingEntryId: null, amountRaw: '', note: ''),
        ],
      );

      blocTest<AddExpenseBloc, AddExpenseState>(
        'Không cho phép thêm chữ số khi amountRaw dài hơn 11',
        build: () => addExpenseBloc,
        seed: () => const AddExpenseState(amountRaw: '12345678901'),
        act: (bloc) => bloc.add(const AmountKeyPressed(key: '9')),
        expect: () => [],
      );

      blocTest<AddExpenseBloc, AddExpenseState>(
        'Bắt đầu chỉnh sửa và điền dữ liệu khi ExpenseEditStarted',
        build: () => addExpenseBloc,
        seed: () => const AddExpenseState(
          sessionEntries: [
            ExpenseEntry(
              id: 'test_id',
              amount: 1000,
              categoryId: 'bus',
              paymentMethod: 'cash',
              note: 'Ticket',
            ),
          ],
        ),
        act: (bloc) => bloc.add(const ExpenseEditStarted(id: 'test_id')),
        expect: () => [
          const AddExpenseState(
            sessionEntries: [
              ExpenseEntry(
                id: 'test_id',
                amount: 1000,
                categoryId: 'bus',
                paymentMethod: 'cash',
                note: 'Ticket',
              ),
            ],
            editingEntryId: 'test_id',
            amountRaw: '1000',
            selectedCategoryId: 'bus',
            paymentMethod: 'cash',
            note: 'Ticket',
          ),
        ],
      );
    });

    group('Saving to Database', () {
      final entry = ExpenseEntry(
        id: '1',
        amount: 20000,
        categoryId: 'cafe',
        paymentMethod: 'card',
        note: 'Coffee',
      );

      blocTest<AddExpenseBloc, AddExpenseState>(
        'Phát [loading, success] khi lưu tất cả thành công',
        build: () => addExpenseBloc,
        seed: () => AddExpenseState(sessionEntries: [entry]),
        setUp: () {
          when(
            () => mockAddExpenseUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
        },
        act: (bloc) => bloc.add(const ExpenseSavedAll()),
        expect: () => [
          AddExpenseState(
            sessionEntries: [entry],
            status: AddExpenseStatus.loading,
          ),
          const AddExpenseState(
            status: AddExpenseStatus.success,
            allSaved: true,
            sessionEntries: [],
          ),
          // State reset sau 2 giây delay
          const AddExpenseState(
            status: AddExpenseStatus.initial,
            allSaved: false,
            sessionEntries: [],
          ),
        ],
        wait: const Duration(
          seconds: 2,
        ), // Cần thiết vì bạn có await Future.delayed
      );

      blocTest<AddExpenseBloc, AddExpenseState>(
        'Phát [loading, failure] khi usecase trả về lỗi',
        build: () => addExpenseBloc,
        seed: () => AddExpenseState(sessionEntries: [entry]),
        setUp: () {
          when(() => mockAddExpenseUseCase(any())).thenAnswer(
            (_) async =>
                Left(CacheFailure(message: 'Đã có lỗi xảy ra khi lấy dữ liệu')),
          ); // Giả định có CacheFailure
        },
        act: (bloc) => bloc.add(const ExpenseSavedAll()),
        expect: () => [
          AddExpenseState(
            sessionEntries: [entry],
            status: AddExpenseStatus.loading,
          ),
          AddExpenseState(
            sessionEntries: [entry],
            status: AddExpenseStatus.failure,
            errorMessage: 'Có lỗi khi lưu chi tiêu',
          ),
        ],
      );
    });

    group('Date logic', () {
      final testDate = DateTime(2023, 12, 25);
      blocTest<AddExpenseBloc, AddExpenseState>(
        'Cập nhật selectedDate khi thêm DateSelected',
        build: () => addExpenseBloc,
        act: (bloc) => bloc.add(DateSelected(date: testDate)),
        expect: () => [AddExpenseState(selectedDate: testDate)],
      );
    });
  });
}

// Dummy Failure class cho việc test error
class ServerFailure {}

import 'package:flutter_test/flutter_test.dart';
import 'package:expense_management/features/expense/add/presentation/bloc/add_expense_state.dart';

void main() {
  test('numericAmount parses amountRaw correctly', () {
    final s1 = const AddExpenseState(amountRaw: '');
    expect(s1.numericAmount, 0);

    final s2 = const AddExpenseState(amountRaw: '250');
    expect(s2.numericAmount, 250);
  });

  test('canAdd true only when numericAmount > 0 and category selected', () {
    final s1 = const AddExpenseState(amountRaw: '0', selectedCategoryId: null);
    expect(s1.canAdd, isFalse);

    final s2 = const AddExpenseState(
      amountRaw: '100',
      selectedCategoryId: null,
    );
    expect(s2.canAdd, isFalse);

    final s3 = const AddExpenseState(
      amountRaw: '100',
      selectedCategoryId: 'cat',
    );
    expect(s3.canAdd, isTrue);
  });

  test('effectiveDate returns selectedDate when provided', () {
    final dt = DateTime(2020, 1, 2);
    final s = AddExpenseState(selectedDate: dt);
    expect(s.effectiveDate, dt);
  });
}

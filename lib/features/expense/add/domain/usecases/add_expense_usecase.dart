import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../income/domain/entities/monthly_income_entity.dart';
import '../../../income/domain/usecases/get_monthly_income_usecase.dart';
import '../entities/expense_detail_entity.dart';
import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class AddExpenseUseCase extends UseCase<void, AddExpenseParams> {
  final ExpenseRepository repository;
  final GetMonthlyIncomeUseCase getMonthlyIncomeUseCase;

  AddExpenseUseCase({
    required this.repository,
    required this.getMonthlyIncomeUseCase,
  });

  @override
  Future<Either<Failure, void>> call(AddExpenseParams params) async {
    final period = MonthlyIncomePeriodHelper.fromDateTime(
      params.expense.createdAt,
    );
    final incomeResult = await getMonthlyIncomeUseCase(
      GetMonthlyIncomeParams(period: period),
    );
    final monthlyIncomeId = incomeResult.fold(
      (_) => null,
      (income) => income?.id,
    );

    final expense = ExpenseEntity(
      id: params.expense.id,
      createdAt: params.expense.createdAt,
      monthlyIncomeId: monthlyIncomeId,
    );

    return repository.addExpense(expense: expense, detail: params.detail);
  }
}

class AddExpenseParams extends Equatable {
  final ExpenseEntity expense;
  final ExpenseDetailEntity detail;

  const AddExpenseParams({required this.expense, required this.detail});

  @override
  List<Object?> get props => [expense, detail];
}

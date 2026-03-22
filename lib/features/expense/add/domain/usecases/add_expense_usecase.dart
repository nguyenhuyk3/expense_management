import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/expense_detail_entity.dart';
import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class AddExpenseUseCase extends UseCase<void, AddExpenseParams> {
  final ExpenseRepository repository;

  AddExpenseUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(AddExpenseParams params) {
    return repository.addExpense(
      expense: params.expense,
      detail: params.detail,
    );
  }
}

class AddExpenseParams extends Equatable {
  final ExpenseEntity expense;
  final ExpenseDetailEntity detail;

  const AddExpenseParams({required this.expense, required this.detail});

  @override
  List<Object?> get props => [expense, detail];
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/expense_repository.dart';

class DeleteExpenseUseCase extends UseCase<void, DeleteExpenseParams> {
  final ExpenseRepository repository;

  DeleteExpenseUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(DeleteExpenseParams params) {
    return repository.deleteExpense(id: params.id);
  }
}

class DeleteExpenseParams extends Equatable {
  final String id;

  const DeleteExpenseParams({required this.id});

  @override
  List<Object?> get props => [id];
}

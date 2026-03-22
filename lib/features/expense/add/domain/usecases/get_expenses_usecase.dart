import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/expense_detail_entity.dart';
import '../repositories/expense_repository.dart';

class GetExpensesUseCase extends UseCase<List<ExpenseDetailEntity>, NoParams> {
  final ExpenseRepository repository;

  GetExpensesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ExpenseDetailEntity>>> call(NoParams params) {
    return repository.getExpenses();
  }
}

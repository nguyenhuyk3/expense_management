import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../entities/expense_detail_entity.dart';
import '../entities/expense_entity.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, void>> addExpense({
    required ExpenseEntity expense,
    required ExpenseDetailEntity detail,
  });
  Future<Either<Failure, List<ExpenseDetailEntity>>> getExpenses();
  Future<Either<Failure, void>> deleteExpense(String id);
}

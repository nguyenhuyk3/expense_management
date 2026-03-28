import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/entities/expense_detail_entity.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_datasource.dart';
import '../models/expense_entity_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDatasource datasource;

  ExpenseRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, void>> addExpense({
    required ExpenseEntity expense,
    required ExpenseDetailEntity detail,
  }) async {
    try {
      await datasource.saveExpense(
        entity: ExpenseEntityModel.fromEntity(expense),
        detail: detail,
      );

      return const Right(null);
    } catch (e) {
      return Left(SaveExpenseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ExpenseDetailEntity>>> getExpenses() async {
    try {
      final models = await datasource.getExpenses();

      return Right(models.map((m) => m.detail).toList());
    } catch (e) {
      return Left(ReadExpenseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense({required String id}) async {
    try {
      await datasource.deleteExpense(id: id);

      return const Right(null);
    } catch (e) {
      return Left(DeleteExpenseFailure(message: e.toString()));
    }
  }
}

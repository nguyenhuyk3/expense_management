import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/entities/expense_detail_entity.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_datasource.dart';
import '../models/expense_model.dart';

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
        ExpenseModel.fromEntities(expense: expense, detail: detail),
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ExpenseDetailEntity>>> getExpenses() async {
    try {
      final models = await datasource.getExpenses();
      return Right(models.map((m) => m.detail).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(String id) async {
    try {
      await datasource.deleteExpense(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}

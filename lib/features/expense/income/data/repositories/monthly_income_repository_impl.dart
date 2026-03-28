import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/entities/monthly_income_entity.dart';
import '../../domain/repositories/monthly_income_repository.dart';
import '../datasources/monthly_income_local_datasource.dart';
import '../models/monthly_income_model.dart';

class MonthlyIncomeRepositoryImpl implements MonthlyIncomeRepository {
  final MonthlyIncomeLocalDatasource datasource;

  MonthlyIncomeRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, MonthlyIncomeEntity?>> getIncomeByPeriod({
    required String period,
  }) async {
    try {
      final model = await datasource.getByPeriod(period: period);

      return Right(model);
    } catch (e) {
      return Left(ReadIncomeFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MonthlyIncomeEntity>>> getAllIncomes() async {
    try {
      final models = await datasource.getAll();

      return Right(models);
    } catch (e) {
      return Left(ReadIncomeFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveIncome({
    required MonthlyIncomeEntity income,
  }) async {
    try {
      await datasource.save(model: MonthlyIncomeModel.fromEntity(income));

      return const Right(null);
    } catch (e) {
      return Left(SaveIncomeFailure(message: e.toString()));
    }
  }
}

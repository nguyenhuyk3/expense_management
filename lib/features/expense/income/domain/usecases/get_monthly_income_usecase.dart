import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/monthly_income_entity.dart';
import '../repositories/monthly_income_repository.dart';

class GetMonthlyIncomeUseCase
    implements UseCase<MonthlyIncomeEntity?, GetMonthlyIncomeParams> {
  final MonthlyIncomeRepository repository;

  GetMonthlyIncomeUseCase({required this.repository});

  @override
  Future<Either<Failure, MonthlyIncomeEntity?>> call(
    GetMonthlyIncomeParams params,
  ) => repository.getIncomeByPeriod(period: params.period);
}

class GetMonthlyIncomeParams {
  final String period;

  const GetMonthlyIncomeParams({required this.period});
}

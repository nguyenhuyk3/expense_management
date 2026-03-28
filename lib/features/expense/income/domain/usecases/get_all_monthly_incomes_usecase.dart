import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/monthly_income_entity.dart';
import '../repositories/monthly_income_repository.dart';

class GetAllMonthlyIncomesUseCase
    implements UseCase<List<MonthlyIncomeEntity>, NoParams> {
  final MonthlyIncomeRepository repository;

  GetAllMonthlyIncomesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<MonthlyIncomeEntity>>> call(NoParams params) =>
      repository.getAllIncomes();
}

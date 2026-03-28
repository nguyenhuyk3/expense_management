import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/monthly_income_entity.dart';
import '../repositories/monthly_income_repository.dart';

class SaveMonthlyIncomeUseCase implements UseCase<void, MonthlyIncomeEntity> {
  final MonthlyIncomeRepository repository;

  SaveMonthlyIncomeUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(MonthlyIncomeEntity params) =>
      repository.saveIncome(income: params);
}

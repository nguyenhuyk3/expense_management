import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../entities/monthly_income_entity.dart';

abstract class MonthlyIncomeRepository {
  /// Lấy thu nhập theo [period] (định dạng "yyyy-MM").
  /// Trả về [null] nếu chưa có dữ liệu cho kỳ đó.
  Future<Either<Failure, MonthlyIncomeEntity?>> getIncomeByPeriod({
    required String period,
  });

  /// Lấy toàn bộ danh sách thu nhập đã lưu, sắp xếp từ mới → cũ.
  Future<Either<Failure, List<MonthlyIncomeEntity>>> getAllIncomes();

  /// Lưu hoặc cập nhật thu nhập. Ghi đè nếu [period] đã tồn tại.
  Future<Either<Failure, void>> saveIncome({
    required MonthlyIncomeEntity income,
  });
}

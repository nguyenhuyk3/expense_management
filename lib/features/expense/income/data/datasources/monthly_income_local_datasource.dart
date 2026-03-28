import 'package:hive_flutter/hive_flutter.dart';

import '../models/monthly_income_model.dart';

abstract class MonthlyIncomeLocalDatasource {
  /// Lấy income theo khóa [period] ("yyyy-MM"). Trả về null nếu chưa có.
  Future<MonthlyIncomeModel?> getByPeriod({required String period});

  /// Lấy toàn bộ danh sách, sắp xếp mới → cũ.
  Future<List<MonthlyIncomeModel>> getAll();

  /// Lưu hoặc ghi đè income (key = period).
  Future<void> save({required MonthlyIncomeModel model});
}

class MonthlyIncomeLocalDatasourceImpl implements MonthlyIncomeLocalDatasource {
  static const String _boxName = 'monthly_income_box';

  Box get _box => Hive.box(_boxName);

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  @override
  Future<MonthlyIncomeModel?> getByPeriod({required String period}) async {
    final raw = _box.get(period);

    if (raw == null) {
      return null;
    }

    return MonthlyIncomeModel.fromMap(raw as Map<dynamic, dynamic>);
  }

  @override
  Future<List<MonthlyIncomeModel>> getAll() async {
    final models = _box.values
        .map((v) => MonthlyIncomeModel.fromMap(v as Map<dynamic, dynamic>))
        .toList();
    // Sắp xếp từ mới nhất → cũ nhất theo period
    models.sort((a, b) => b.period.compareTo(a.period));

    return models;
  }

  @override
  Future<void> save({required MonthlyIncomeModel model}) async {
    await _box.put(model.period, model.toMap());
  }
}

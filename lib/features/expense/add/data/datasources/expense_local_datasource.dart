import 'package:hive_flutter/hive_flutter.dart';

import '../models/expense_model.dart';

abstract class ExpenseLocalDatasource {
  Future<void> saveExpense(ExpenseModel model);
  Future<List<ExpenseModel>> getExpenses();
  Future<void> deleteExpense(String id);
}

class ExpenseLocalDatasourceImpl implements ExpenseLocalDatasource {
  static const String _boxName = 'expense_box';

  Box get _box => Hive.box(_boxName);

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  @override
  Future<void> saveExpense(ExpenseModel model) async {
    await _box.put(model.id, model.toMap());
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    final list = _box.values
        .map((v) => ExpenseModel.fromMap(v as Map<dynamic, dynamic>))
        .toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return list;
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _box.delete(id);
  }
}

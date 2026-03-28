import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/expense_detail_entity.dart';
import '../models/expense_detail_model.dart';
import '../models/expense_entity_model.dart';
import '../models/expense_model.dart';

abstract class ExpenseLocalDatasource {
  Future<void> saveExpense({
    required ExpenseEntityModel entity,

    /// [detail] là domain entity — [numericalOrder] sẽ được gán tự động bởi implementation.
    required ExpenseDetailEntity detail,
  });
  Future<List<ExpenseModel>> getExpenses();
  Future<void> deleteExpense({required String id});
}

class ExpenseLocalDatasourceImpl implements ExpenseLocalDatasource {
  static const String _entityBoxName = 'expense_entity_box';
  static const String _detailBoxName = 'expense_detail_box';

  Box get _entityBox => Hive.box(_entityBoxName);
  Box get _detailBox => Hive.box(_detailBoxName);

  static Future<void> init() async {
    await Hive.openBox(_entityBoxName);
    await Hive.openBox(_detailBoxName);
  }

  @override
  Future<void> saveExpense({
    required ExpenseEntityModel entity,
    required ExpenseDetailEntity detail,
  }) async {
    final nextOrder = _detailBox.length + 1;
    final detailModel = ExpenseDetailModel(
      expenseId: detail.expenseId,
      amount: detail.amount,
      categoryId: detail.categoryId,
      paymentMethod: detail.paymentMethod,
      note: detail.note,
      numericalOrder: nextOrder,
    );
    await _entityBox.put(entity.id, entity.toMap());
    await _detailBox.put(detail.expenseId, detailModel.toMap());
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    final entities = _entityBox.values
        .map((v) => ExpenseEntityModel.fromMap(v as Map<dynamic, dynamic>))
        .toList();
    final Map<String, ExpenseDetailModel> detailsMap = {};

    for (final v in _detailBox.values) {
      final detail = ExpenseDetailModel.fromMap(v as Map<dynamic, dynamic>);

      detailsMap[detail.expenseId] = detail;
    }

    final result = entities
        .where((entity) => detailsMap.containsKey(entity.id))
        .map(
          (entity) => ExpenseModel.fromModels(
            entity: entity,
            detail: detailsMap[entity.id]!,
          ),
        )
        .toList();

    result.sort((a, b) => a.numericalOrder.compareTo(b.numericalOrder));

    return result;
  }

  @override
  Future<void> deleteExpense({required String id}) async {
    await _entityBox.delete(id);
    await _detailBox.delete(id);
    // Sau khi xoá, sắp xếp lại numericalOrder cho các bản ghi còn lại (1, 2, 3, ...).
    final remaining =
        _detailBox.values
            .map((v) => ExpenseDetailModel.fromMap(v as Map<dynamic, dynamic>))
            .toList()
          ..sort((a, b) => a.numericalOrder.compareTo(b.numericalOrder));

    for (int i = 0; i < remaining.length; i++) {
      final updated = remaining[i].withOrder(numericalOrder: i + 1);
      await _detailBox.put(updated.expenseId, updated.toMap());
    }
  }
}

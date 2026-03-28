import '../../domain/entities/expense_entity.dart';

/// Model Hive cho [ExpenseEntity].
/// Chịu trách nhiệm serialize/deserialize dữ liệu định danh và thời điểm tạo
/// vào bảng `expense_entity_box` riêng biệt.
class ExpenseEntityModel extends ExpenseEntity {
  const ExpenseEntityModel({
    required super.id,
    required super.createdAt,
    // Optional: kế thừa từ ExpenseEntity, nullable khi không có thu nhập tháng tương ứng.
    super.monthlyIncomeId,
  });

  factory ExpenseEntityModel.fromEntity(ExpenseEntity entity) =>
      ExpenseEntityModel(
        id: entity.id,
        createdAt: entity.createdAt,
        monthlyIncomeId: entity.monthlyIncomeId,
      );

  factory ExpenseEntityModel.fromMap(Map<dynamic, dynamic> map) =>
      ExpenseEntityModel(
        id: map['id'] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        monthlyIncomeId: map['monthlyIncomeId'] as String?,
      );

  Map<String, dynamic> toMap() => {
    'id': id,
    'createdAt': createdAt.millisecondsSinceEpoch,
    if (monthlyIncomeId != null) 'monthlyIncomeId': monthlyIncomeId,
  };
}

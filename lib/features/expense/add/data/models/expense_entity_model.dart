import '../../domain/entities/expense_entity.dart';

/// Model Hive cho [ExpenseEntity].
/// Chịu trách nhiệm serialize/deserialize dữ liệu định danh và thời điểm tạo
/// vào bảng `expense_entity_box` riêng biệt.
class ExpenseEntityModel extends ExpenseEntity {
  const ExpenseEntityModel({required super.id, required super.createdAt});

  factory ExpenseEntityModel.fromEntity(ExpenseEntity entity) =>
      ExpenseEntityModel(id: entity.id, createdAt: entity.createdAt);

  factory ExpenseEntityModel.fromMap(Map<dynamic, dynamic> map) =>
      ExpenseEntityModel(
        id: map['id'] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      );

  Map<String, dynamic> toMap() => {
    'id': id,
    'createdAt': createdAt.millisecondsSinceEpoch,
  };
}

import '../../domain/entities/expense_detail_entity.dart';
import '../../domain/entities/expense_entity.dart';

/// Model lưu trữ phẳng (flat) cho Hive, kết hợp dữ liệu của
/// [ExpenseEntity] và [ExpenseDetailEntity] trong một bản ghi duy nhất.
class ExpenseModel extends ExpenseEntity {
  final int amount;
  final String categoryId;
  final String paymentMethod;
  final String note;

  const ExpenseModel({
    required super.id,
    required super.createdAt,
    required this.amount,
    required this.categoryId,
    required this.paymentMethod,
    required this.note,
  });

  factory ExpenseModel.fromMap(Map<dynamic, dynamic> map) {
    return ExpenseModel(
      id: map['id'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      amount: map['amount'] as int,
      categoryId: map['categoryId'] as String,
      paymentMethod: map['paymentMethod'] as String,
      note: map['note'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'amount': amount,
    'categoryId': categoryId,
    'paymentMethod': paymentMethod,
    'note': note,
  };

  factory ExpenseModel.fromEntities({
    required ExpenseEntity expense,
    required ExpenseDetailEntity detail,
  }) => ExpenseModel(
    id: expense.id,
    createdAt: expense.createdAt,
    amount: detail.amount,
    categoryId: detail.categoryId,
    paymentMethod: detail.paymentMethod,
    note: detail.note,
  );

  /// Trả về [ExpenseDetailEntity] từ dữ liệu flat của model này.
  ExpenseDetailEntity get detail => ExpenseDetailEntity(
    expenseId: id,
    amount: amount,
    categoryId: categoryId,
    paymentMethod: paymentMethod,
    note: note,
  );
}

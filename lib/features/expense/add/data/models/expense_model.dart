import '../../domain/entities/expense_detail_entity.dart';
import '../../domain/entities/expense_entity.dart';
import 'expense_detail_model.dart';
import 'expense_entity_model.dart';

/// Model kết hợp dùng để đọc dữ liệu từ hai bảng [ExpenseEntityModel] và
/// [ExpenseDetailModel]. Không dùng trực tiếp cho việc ghi vào Hive.
class ExpenseModel extends ExpenseEntity {
  final int amount;
  final String categoryId;
  final String paymentMethod;
  final String note;

  /// Số thứ tự toàn cục được join từ [ExpenseDetailModel.numericalOrder].
  final int numericalOrder;

  const ExpenseModel({
    required super.id,
    required super.createdAt,
    required this.amount,
    required this.categoryId,
    required this.paymentMethod,
    required this.note,
    required this.numericalOrder,
  });

  /// Tạo [ExpenseModel] bằng cách kết hợp (join) hai model từ hai bảng Hive.
  factory ExpenseModel.fromModels({
    required ExpenseEntityModel entity,
    required ExpenseDetailModel detail,
  }) => ExpenseModel(
    id: entity.id,
    createdAt: entity.createdAt,
    amount: detail.amount,
    categoryId: detail.categoryId,
    paymentMethod: detail.paymentMethod,
    note: detail.note,
    numericalOrder: detail.numericalOrder,
  );

  /// Trả về [ExpenseDetailEntity] từ dữ liệu của model này.
  ExpenseDetailEntity get detail => ExpenseDetailEntity(
    expenseId: id,
    amount: amount,
    categoryId: categoryId,
    paymentMethod: paymentMethod,
    note: note,
  );
}

import '../../domain/entities/expense_detail_entity.dart';

/// Model Hive cho [ExpenseDetailEntity].
/// Chịu trách nhiệm serialize/deserialize chi tiết nội dung khoản chi tiêu
/// vào bảng `expense_detail_box` riêng biệt.
/// [numericalOrder] là số thứ tự toàn cục, bắt đầu từ 1, do datasource quản lý
/// để xác định thứ tự hiển thị danh sách. Không thuộc về domain entity.
class ExpenseDetailModel extends ExpenseDetailEntity {
  /// Số thứ tự toàn cục dùng để sắp xếp danh sách, bắt đầu từ 1.
  /// Được gán và quản lý tự động bởi [ExpenseLocalDatasourceImpl].
  final int numericalOrder;

  const ExpenseDetailModel({
    required super.expenseId,
    required super.amount,
    required super.categoryId,
    required super.paymentMethod,
    required super.note,
    required this.numericalOrder,
  });

  factory ExpenseDetailModel.fromMap(Map<dynamic, dynamic> map) =>
      ExpenseDetailModel(
        expenseId: map['expenseId'] as String,
        amount: map['amount'] as int,
        categoryId: map['categoryId'] as String,
        paymentMethod: map['paymentMethod'] as String,
        note: map['note'] as String,
        numericalOrder: map['numericalOrder'] as int,
      );

  Map<String, dynamic> toMap() => {
    'expenseId': expenseId,
    'amount': amount,
    'categoryId': categoryId,
    'paymentMethod': paymentMethod,
    'note': note,
    'numericalOrder': numericalOrder,
  };

  /// Tạo bản sao với [numericalOrder] mới, giữ nguyên các trường còn lại.
  ExpenseDetailModel withOrder({required int numericalOrder}) =>
      ExpenseDetailModel(
        expenseId: expenseId,
        amount: amount,
        categoryId: categoryId,
        paymentMethod: paymentMethod,
        note: note,
        numericalOrder: numericalOrder,
      );
}

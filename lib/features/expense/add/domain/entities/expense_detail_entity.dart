import 'package:equatable/equatable.dart';

/// Chi tiết nội dung của một khoản chi tiêu.
/// Liên kết với [ExpenseEntity] qua khóa ngoại [expenseId].
class ExpenseDetailEntity extends Equatable {
  /// Khóa ngoại liên kết tới [ExpenseEntity.id].
  final String expenseId;
  final int amount;
  final String categoryId;
  final String paymentMethod;
  final String note;

  const ExpenseDetailEntity({
    required this.expenseId,
    required this.amount,
    required this.categoryId,
    required this.paymentMethod,
    required this.note,
  });

  @override
  List<Object?> get props => [
    expenseId,
    amount,
    categoryId,
    paymentMethod,
    note,
  ];
}

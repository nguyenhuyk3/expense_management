import 'package:equatable/equatable.dart';

/// Entity đại diện cho một khoản chi tiêu, chứa thông tin định danh và thời điểm tạo.
/// Chi tiết nội dung của khoản chi được lưu trong [ExpenseDetailEntity]
/// thông qua khóa ngoại [ExpenseDetailEntity.expenseId].
class ExpenseEntity extends Equatable {
  final String id;
  final DateTime createdAt;

  const ExpenseEntity({required this.id, required this.createdAt});

  @override
  List<Object?> get props => [id, createdAt];
}

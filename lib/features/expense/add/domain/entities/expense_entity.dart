import 'package:equatable/equatable.dart';

/// Entity đại diện cho một khoản chi tiêu, chứa thông tin định danh và thời điểm tạo.
/// Chi tiết nội dung của khoản chi được lưu trong [ExpenseDetailEntity]
/// thông qua khóa ngoại [ExpenseDetailEntity.expenseId].
class ExpenseEntity extends Equatable {
  final String id;
  final DateTime createdAt;

  /// Id của [MonthlyIncomeEntity] tương ứng với tháng của [createdAt].
  /// Nullable vì có thể không tồn tại dữ liệu thu nhập cho tháng đó.
  final String? monthlyIncomeId;

  const ExpenseEntity({
    required this.id,
    required this.createdAt,
    // Optional: không phải lúc nào cũng có thu nhập được ghi nhận cho tháng tương ứng.
    this.monthlyIncomeId,
  });

  @override
  List<Object?> get props => [id, createdAt, monthlyIncomeId];
}

import 'package:equatable/equatable.dart';

abstract class AddExpenseEvent extends Equatable {
  const AddExpenseEvent();

  @override
  List<Object?> get props => [];
}

class AmountKeyPressed extends AddExpenseEvent {
  final String key;

  const AmountKeyPressed({required this.key});

  @override
  List<Object?> get props => [key];
}

class CategorySelected extends AddExpenseEvent {
  /// null nếu người dùng chọn "Không phân loại"
  final String? categoryId;

  const CategorySelected({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class PaymentMethodSelected extends AddExpenseEvent {
  final String paymentMethod;

  const PaymentMethodSelected({required this.paymentMethod});

  @override
  List<Object?> get props => [paymentMethod];
}

class NoteChanged extends AddExpenseEvent {
  final String note;

  const NoteChanged({required this.note});

  @override
  List<Object?> get props => [note];
}

class ExpenseAdded extends AddExpenseEvent {
  const ExpenseAdded();
}

class ExpenseRemoved extends AddExpenseEvent {
  final String id;

  const ExpenseRemoved({required this.id});

  @override
  List<Object?> get props => [id];
}

class ExpenseSavedAll extends AddExpenseEvent {
  const ExpenseSavedAll();
}

/// Bắt đầu chỉnh sửa một khoản đã thêm trong phiên
class ExpenseEditStarted extends AddExpenseEvent {
  final String id;

  const ExpenseEditStarted({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Huỷ chỉnh sửa và khôi phục trạng thái nhập liệu trống
class ExpenseEditCancelled extends AddExpenseEvent {
  const ExpenseEditCancelled();
}

/// Người dùng chọn ngày để gán cho các khoản chi tiêu trong phiên
class DateSelected extends AddExpenseEvent {
  final DateTime date;

  const DateSelected({required this.date});

  @override
  List<Object?> get props => [date];
}

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Lỗi xảy ra khi ghi/lưu dữ liệu chi tiêu vào bộ nhớ cục bộ.
class SaveExpenseFailure extends Failure {
  const SaveExpenseFailure({required super.message});
}

/// Lỗi xảy ra khi đọc/lấy danh sách chi tiêu từ bộ nhớ cục bộ.
class ReadExpenseFailure extends Failure {
  const ReadExpenseFailure({required super.message});
}

/// Lỗi xảy ra khi xoá một khoản chi tiêu khỏi bộ nhớ cục bộ.
class DeleteExpenseFailure extends Failure {
  const DeleteExpenseFailure({required super.message});
}

class SaveIncomeFailure extends Failure {
  const SaveIncomeFailure({required super.message});
}

class ReadIncomeFailure extends Failure {
  const ReadIncomeFailure({required super.message});
}

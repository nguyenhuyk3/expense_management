import 'package:equatable/equatable.dart';

import '../../domain/entities/monthly_income_entity.dart';

sealed class MonthlyIncomeState extends Equatable {
  const MonthlyIncomeState();
}

/// Trạng thái khởi đầu, chưa load dữ liệu.
final class MonthlyIncomeInitial extends MonthlyIncomeState {
  const MonthlyIncomeInitial();

  @override
  List<Object?> get props => [];
}

/// Đang tải dữ liệu.
final class MonthlyIncomeLoading extends MonthlyIncomeState {
  const MonthlyIncomeLoading();

  @override
  List<Object?> get props => [];
}

/// Dữ liệu đã được tải — bao gồm cả trạng thái form nhập liệu.
final class MonthlyIncomeLoaded extends MonthlyIncomeState {
  /// Kỳ tháng đang xem, định dạng "yyyy-MM".
  final String period;

  /// Kỳ tháng thực tế (tháng hiện tại), dùng để giới hạn navigation.
  final String currentPeriod;

  /// Thu nhập đã lưu cho [period], null nếu chưa có.
  final MonthlyIncomeEntity? existingIncome;

  /// Chuỗi số đang nhập từ numpad (không có dấu phân cách).
  final String amountRaw;

  /// true khi người dùng đang chỉnh sửa thu nhập đã tồn tại.
  final bool isEditing;

  const MonthlyIncomeLoaded({
    required this.period,
    required this.currentPeriod,
    required this.existingIncome,
    required this.amountRaw,
    required this.isEditing,
  });

  bool get hasExistingIncome => existingIncome != null;

  /// Đang ở chế độ nhập (không có dữ liệu cũ, hoặc đang chỉnh sửa).
  bool get isInputMode => !hasExistingIncome || isEditing;

  /// Period đang xem có phải tháng hiện tại không.
  bool get isCurrentPeriod => period == currentPeriod;

  /// Số tiền thu nhập từ [amountRaw].
  int get numericAmount => int.tryParse(amountRaw) ?? 0;

  /// Có thể lưu không (amount > 0).
  bool get canSave => numericAmount > 0;

  MonthlyIncomeLoaded copyWith({
    String? period,
    String? currentPeriod,
    MonthlyIncomeEntity? existingIncome,
    bool clearExistingIncome = false,
    String? amountRaw,
    bool? isEditing,
  }) => MonthlyIncomeLoaded(
    period: period ?? this.period,
    currentPeriod: currentPeriod ?? this.currentPeriod,
    existingIncome: clearExistingIncome
        ? null
        : (existingIncome ?? this.existingIncome),
    amountRaw: amountRaw ?? this.amountRaw,
    isEditing: isEditing ?? this.isEditing,
  );

  @override
  List<Object?> get props => [
    period,
    currentPeriod,
    existingIncome,
    amountRaw,
    isEditing,
  ];
}

/// Đang lưu dữ liệu.
final class MonthlyIncomeSaving extends MonthlyIncomeState {
  const MonthlyIncomeSaving();

  @override
  List<Object?> get props => [];
}

/// Lưu thành công.
final class MonthlyIncomeSaved extends MonthlyIncomeState {
  final MonthlyIncomeEntity income;

  const MonthlyIncomeSaved({required this.income});

  @override
  List<Object?> get props => [income];
}

/// Có lỗi xảy ra.
final class MonthlyIncomeFailure extends MonthlyIncomeState {
  final String message;

  const MonthlyIncomeFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

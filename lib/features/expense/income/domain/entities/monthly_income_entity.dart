import 'package:equatable/equatable.dart';

/// Entity đại diện cho thu nhập của một tháng cụ thể.
///
/// Đề xuất tên field: [period]
/// Lưu dưới dạng chuỗi "yyyy-MM" (ví dụ: "2026-03") — chỉ chứa tháng và năm.
class MonthlyIncomeEntity extends Equatable {
  final String id;
  final int income;

  /// Kỳ tháng — định dạng "yyyy-MM" (ví dụ: "2026-03").
  final String period;

  final DateTime createdAt;
  final DateTime updatedAt;

  const MonthlyIncomeEntity({
    required this.id,
    required this.income,
    required this.period,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, income, period, createdAt, updatedAt];
}

/// Các tiện ích làm việc với chuỗi period "yyyy-MM".
class MonthlyIncomePeriodHelper {
  /// Tạo chuỗi period từ [DateTime] (ví dụ: 2026-03).
  static String fromDateTime(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-'
      '${dt.month.toString().padLeft(2, '0')}';

  /// Trả về chuỗi hiển thị thân thiện (ví dụ: "Tháng 3, 2026").
  static String displayName(String period) {
    final parts = period.split('-');

    return 'Tháng ${int.parse(parts[1])}, ${parts[0]}';
  }

  /// Chuyển chuỗi period trở lại [DateTime] (ngày 1 của tháng đó).
  static DateTime toDateTime(String period) {
    final parts = period.split('-');

    return DateTime(int.parse(parts[0]), int.parse(parts[1]));
  }

  /// Dịch chuyển [period] theo số tháng [delta] (âm = về trước).
  static String shift(String period, int delta) {
    final dt = toDateTime(period);
    var month = dt.month + delta;
    var year = dt.year;

    while (month > 12) {
      month -= 12;
      year++;
    }
    while (month < 1) {
      month += 12;
      year--;
    }

    return fromDateTime(DateTime(year, month));
  }

  /// Kiểm tra [period] có phải là tháng hiện tại không.
  static bool isCurrentMonth(String period) =>
      period == fromDateTime(DateTime.now());

  /// So sánh thứ tự: true nếu [a] đứng trước [b].
  static bool isBefore(String a, String b) => a.compareTo(b) < 0;
}

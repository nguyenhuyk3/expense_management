const List<String> kAddExpenseKeys = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '000',
  '0',
  '⌫',
];

/// Formatter cho đơn vị tiền tệ theo định dạng tiếng Việt (phân tách bằng dấu chấm)
String formatCurrencyAmount(int n) {
  if (n == 0) {
    return '0';
  }

  final s = n.toString();
  final buf = StringBuffer();

  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) {
      buf.write('.');
    }

    buf.write(s[i]);
  }

  return buf.toString();
}

/// Formatter để hiển thị ngày giờ
String formatDateTime(DateTime dt) {
  final now = DateTime.now();
  final hh = dt.hour.toString().padLeft(2, '0');
  final mm = dt.minute.toString().padLeft(2, '0');
  final isSameDay =
      dt.year == now.year && dt.month == now.month && dt.day == now.day;

  if (isSameDay) {
    return '$hh:$mm';
  }

  final dd = dt.day.toString().padLeft(2, '0');
  final mo = dt.month.toString().padLeft(2, '0');

  return '$dd/$mo · $hh:$mm';
}

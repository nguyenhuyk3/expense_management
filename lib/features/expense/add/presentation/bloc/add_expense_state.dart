import 'package:equatable/equatable.dart';

class ExpenseEntry extends Equatable {
  final String id;
  final int amount;
  final String categoryId;
  final String paymentMethod;
  final String note;

  const ExpenseEntry({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.paymentMethod,
    required this.note,
  });

  @override
  List<Object?> get props => [id, amount, categoryId, paymentMethod, note];
}

enum AddExpenseStatus { initial, loading, success, failure }

class AddExpenseState extends Equatable {
  final String amountRaw;
  final String? selectedCategoryId;
  final String paymentMethod;
  final String note;
  final List<ExpenseEntry> sessionEntries;
  final AddExpenseStatus status;
  final String? errorMessage;
  final bool allSaved;
  final String? editingEntryId;

  /// Ngày được chọn để gán cho các khoản chi tiêu. Null = dùng ngày hôm nay.
  final DateTime? selectedDate;

  const AddExpenseState({
    this.amountRaw = '',
    this.selectedCategoryId,
    this.paymentMethod = 'cash',
    this.note = '',
    this.sessionEntries = const [],
    this.status = AddExpenseStatus.initial,
    this.errorMessage,
    this.allSaved = false,
    this.editingEntryId,
    this.selectedDate,
  });

  bool get isEditing => editingEntryId != null;

  int get numericAmount => amountRaw.isEmpty ? 0 : int.tryParse(amountRaw) ?? 0;

  bool get canAdd => numericAmount > 0 && selectedCategoryId != null;

  /// Ngày hiệu lực dùng khi tạo entry. Nếu chưa chọn thì dùng ngày hôm nay.
  DateTime get effectiveDate => selectedDate ?? DateTime.now();

  AddExpenseState copyWith({
    String? amountRaw,
    String? selectedCategoryId,
    String? paymentMethod,
    String? note,
    List<ExpenseEntry>? sessionEntries,
    AddExpenseStatus? status,
    String? errorMessage,
    bool? allSaved,
    String? editingEntryId,
    bool clearEditingEntryId = false,
    DateTime? selectedDate,
    bool clearSelectedDate = false,
  }) => AddExpenseState(
    amountRaw: amountRaw ?? this.amountRaw,
    selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    note: note ?? this.note,
    sessionEntries: sessionEntries ?? this.sessionEntries,
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    allSaved: allSaved ?? this.allSaved,
    editingEntryId: clearEditingEntryId
        ? null
        : (editingEntryId ?? this.editingEntryId),
    selectedDate: clearSelectedDate
        ? null
        : (selectedDate ?? this.selectedDate),
  );

  @override
  List<Object?> get props => [
    amountRaw,
    selectedCategoryId,
    paymentMethod,
    note,
    sessionEntries,
    status,
    errorMessage,
    allSaved,
    editingEntryId,
    selectedDate,
  ];
}

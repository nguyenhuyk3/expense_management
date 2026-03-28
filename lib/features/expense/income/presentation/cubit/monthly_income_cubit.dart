import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/monthly_income_entity.dart';
import '../../domain/usecases/get_all_monthly_incomes_usecase.dart';
import '../../domain/usecases/get_monthly_income_usecase.dart';
import '../../domain/usecases/save_monthly_income_usecase.dart';

import 'monthly_income_state.dart';

export 'monthly_income_state.dart';

class MonthlyIncomeCubit extends Cubit<MonthlyIncomeState> {
  final GetMonthlyIncomeUseCase _getMonthlyIncomeUseCase;
  final SaveMonthlyIncomeUseCase _saveMonthlyIncomeUseCase;
  final GetAllMonthlyIncomesUseCase _getAllMonthlyIncomesUseCase;

  MonthlyIncomeCubit({
    required GetMonthlyIncomeUseCase getMonthlyIncomeUseCase,
    required SaveMonthlyIncomeUseCase saveMonthlyIncomeUseCase,
    required GetAllMonthlyIncomesUseCase getAllMonthlyIncomesUseCase,
  }) : _getMonthlyIncomeUseCase = getMonthlyIncomeUseCase,
       _saveMonthlyIncomeUseCase = saveMonthlyIncomeUseCase,
       _getAllMonthlyIncomesUseCase = getAllMonthlyIncomesUseCase,

       super(const MonthlyIncomeInitial());

  String get _currentPeriod =>
      MonthlyIncomePeriodHelper.fromDateTime(DateTime.now());

  /// Khởi tạo: load thu nhập tháng hiện tại.
  Future<void> init() => loadIncome(period: _currentPeriod);

  /// Load thu nhập cho [period] cụ thể và cập nhật UI.
  Future<void> loadIncome({required String period}) async {
    emit(const MonthlyIncomeLoading());

    final result = await _getMonthlyIncomeUseCase(
      GetMonthlyIncomeParams(period: period),
    );

    result.fold(
      (failure) => emit(MonthlyIncomeFailure(message: failure.message)),
      (income) {
        // Nếu đã có thu nhập, pre-fill amountRaw để sẵn sàng chỉnh sửa
        final amountRaw = income != null ? income.income.toString() : '';

        emit(
          MonthlyIncomeLoaded(
            period: period,
            currentPeriod: _currentPeriod,
            existingIncome: income,
            amountRaw: amountRaw,
            isEditing: false,
          ),
        );
      },
    );
  }

  /// Chuyển sang kỳ tháng khác (điều hướng lịch).
  Future<void> changePeriod({required String period}) =>
      loadIncome(period: period);

  /// Bắt đầu chỉnh sửa thu nhập đã có.
  void startEditing() {
    final current = state;

    if (current is! MonthlyIncomeLoaded) {
      return;
    }

    emit(current.copyWith(isEditing: true));
  }

  /// Hủy chỉnh sửa, khôi phục về giá trị đang lưu.
  void cancelEditing() {
    final current = state;

    if (current is! MonthlyIncomeLoaded) {
      return;
    }

    final existingAmount = current.existingIncome?.income.toString() ?? '';

    emit(current.copyWith(amountRaw: existingAmount, isEditing: false));
  }

  /// Xử lý phím numpad.
  void handleNumpadKey({required String key}) {
    final current = state;

    if (current is! MonthlyIncomeLoaded || !current.isInputMode) {
      return;
    }

    var raw = current.amountRaw;

    if (key == '⌫') {
      raw = raw.isEmpty ? '' : raw.substring(0, raw.length - 1);
    } else {
      final combined = (raw + key).replaceFirst(RegExp(r'^0+(?=\d)'), '');

      if (combined.length > 13) {
        return; // Giới hạn ~9.999 tỷ VND
      }

      raw = combined;
    }

    emit(current.copyWith(amountRaw: raw));
  }

  /// Đặt trực tiếp số tiền (dùng cho quick preset).
  void setAmount({required String amountRaw}) {
    final current = state;

    if (current is! MonthlyIncomeLoaded || !current.isInputMode) {
      return;
    }

    emit(current.copyWith(amountRaw: amountRaw));
  }

  /// Lưu hoặc cập nhật thu nhập với số tiền hiện tại.
  Future<void> saveOrUpdateIncome() async {
    final current = state;

    if (current is! MonthlyIncomeLoaded || !current.canSave) {
      return;
    }

    emit(const MonthlyIncomeSaving());

    final now = DateTime.now();
    final existing = current.existingIncome;
    final entity = MonthlyIncomeEntity(
      id:
          existing?.id ??
          'income_${current.period}_${now.millisecondsSinceEpoch}',
      income: current.numericAmount,
      period: current.period,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
    final result = await _saveMonthlyIncomeUseCase(entity);

    result.fold(
      (failure) => emit(MonthlyIncomeFailure(message: failure.message)),
      (_) => emit(
        MonthlyIncomeLoaded(
          period: current.period,
          currentPeriod: current.currentPeriod,
          existingIncome: entity,
          amountRaw: entity.income.toString(),
          isEditing: false,
        ),
      ),
    );
  }

  /// Lấy danh sách tất cả các kỳ đã có dữ liệu (để hiển thị lịch sử).
  Future<List<String>> fetchAllPeriods() async {
    final result = await _getAllMonthlyIncomesUseCase(NoParams());

    return result.fold((_) => [], (list) => list.map((e) => e.period).toList());
  }
}

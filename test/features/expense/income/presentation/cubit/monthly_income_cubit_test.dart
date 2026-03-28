import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:expense_management/core/error/failure.dart';
import 'package:expense_management/core/usecases/usecase.dart';
import 'package:expense_management/features/expense/income/domain/entities/monthly_income_entity.dart';
import 'package:expense_management/features/expense/income/domain/usecases/get_all_monthly_incomes_usecase.dart';
import 'package:expense_management/features/expense/income/domain/usecases/get_monthly_income_usecase.dart';
import 'package:expense_management/features/expense/income/domain/usecases/save_monthly_income_usecase.dart';
import 'package:expense_management/features/expense/income/presentation/cubit/monthly_income_cubit.dart';

// ─────────────────────────────────────────────
// Mocks — giả lập use case để cô lập Cubit
// ─────────────────────────────────────────────
class MockGetMonthlyIncomeUseCase extends Mock
    implements GetMonthlyIncomeUseCase {}

class MockSaveMonthlyIncomeUseCase extends Mock
    implements SaveMonthlyIncomeUseCase {}

class MockGetAllMonthlyIncomesUseCase extends Mock
    implements GetAllMonthlyIncomesUseCase {}

// ─────────────────────────────────────────────
// Fakes — giá trị fallback cho argument matchers
// ─────────────────────────────────────────────
class FakeGetMonthlyIncomeParams extends Fake
    implements GetMonthlyIncomeParams {}

class FakeMonthlyIncomeEntity extends Fake implements MonthlyIncomeEntity {}

/// Failure cụ thể dùng trong test vì Failure là abstract
class _TestFailure extends Failure {
  const _TestFailure(String msg) : super(message: msg);
}

// ─────────────────────────────────────────────
// Test Data Builders
// ─────────────────────────────────────────────

/// Tạo entity mẫu cho một kỳ cụ thể
MonthlyIncomeEntity _income({required String period, int amount = 5000000}) {
  final now = DateTime(2026, 3, 28);

  return MonthlyIncomeEntity(
    id: 'income_$period',
    income: amount,
    period: period,
    createdAt: now,
    updatedAt: now,
  );
}

/// Tạo state [MonthlyIncomeLoaded] mẫu
MonthlyIncomeLoaded _loaded({
  required String period,
  String amountRaw = '5000000',
  bool isEditing = false,
  bool noExistingIncome = false,
}) {
  return MonthlyIncomeLoaded(
    period: period,
    currentPeriod: period,
    existingIncome: noExistingIncome
        ? null
        : _income(period: period, amount: int.parse(amountRaw)),
    amountRaw: amountRaw,
    isEditing: isEditing,
  );
}

// ─────────────────────────────────────────────
// Tests
// ─────────────────────────────────────────────
void main() {
  late MockGetMonthlyIncomeUseCase mockGet;
  late MockSaveMonthlyIncomeUseCase mockSave;
  late MockGetAllMonthlyIncomesUseCase mockGetAll;
  late MonthlyIncomeCubit cubit;

  const tPeriod = '2024-12';
  final tIncome = _income(period: tPeriod);

  setUpAll(() {
    registerFallbackValue(FakeGetMonthlyIncomeParams());
    registerFallbackValue(FakeMonthlyIncomeEntity());
    registerFallbackValue(NoParams());
  });
  setUp(() {
    mockGet = MockGetMonthlyIncomeUseCase();
    mockSave = MockSaveMonthlyIncomeUseCase();
    mockGetAll = MockGetAllMonthlyIncomesUseCase();

    cubit = MonthlyIncomeCubit(
      getMonthlyIncomeUseCase: mockGet,
      saveMonthlyIncomeUseCase: mockSave,
      getAllMonthlyIncomesUseCase: mockGetAll,
    );
  });
  tearDown(() => cubit.close());
  // ─── Trạng thái khởi đầu ─────────────────────────────────────────────
  test('trạng thái ban đầu phải là MonthlyIncomeInitial', () {
    expect(cubit.state, isA<MonthlyIncomeInitial>());
  });
  // ─── 1. init() ───────────────────────────────────────────────────────
  // init() ủy quyền cho loadIncome() với period tháng hiện tại
  group('init()', () {
    blocTest<MonthlyIncomeCubit, MonthlyIncomeState>(
      'phát [Loading, Loaded] — tháng hiện tại có dữ liệu',
      build: () {
        when(() => mockGet(any())).thenAnswer((_) async => Right(tIncome));

        return cubit;
      },
      act: (c) => c.init(),
      expect: () => [
        isA<MonthlyIncomeLoading>(),
        isA<MonthlyIncomeLoaded>()
            .having((s) => s.existingIncome, 'existingIncome', tIncome)
            .having((s) => s.amountRaw, 'amountRaw', '5000000'),
      ],
    );

    blocTest<MonthlyIncomeCubit, MonthlyIncomeState>(
      'phát [Loading, Failure] — khi use case trả về lỗi',
      build: () {
        when(
          () => mockGet(any()),
        ).thenAnswer((_) async => Left(const _TestFailure('Lỗi kết nối')));

        return cubit;
      },
      act: (c) => c.init(),
      expect: () => [
        isA<MonthlyIncomeLoading>(),
        isA<MonthlyIncomeFailure>().having(
          (s) => s.message,
          'message',
          'Lỗi kết nối',
        ),
      ],
    );
  });
  // ─── 2. loadIncome() ─────────────────────────────────────────────────
  group('loadIncome()', () {
    blocTest<MonthlyIncomeCubit, MonthlyIncomeState>(
      'phát [Loading, Loaded] — khi tháng đã có dữ liệu',
      build: () {
        when(() => mockGet(any())).thenAnswer((_) async => Right(tIncome));

        return cubit;
      },
      act: (c) => c.loadIncome(period: tPeriod),
      expect: () => [
        isA<MonthlyIncomeLoading>(),
        isA<MonthlyIncomeLoaded>()
            .having((s) => s.period, 'period', tPeriod)
            .having((s) => s.existingIncome, 'existingIncome', tIncome),
      ],
      verify: (_) {
        // Dùng captureAny để bắt params và kiểm tra period
        final captured = verify(() => mockGet(captureAny())).captured;
        final params = captured.first as GetMonthlyIncomeParams;

        expect(params.period, tPeriod);
      },
    );

    blocTest<MonthlyIncomeCubit, MonthlyIncomeState>(
      'phát [Loading, Loaded] — amountRaw rỗng khi tháng chưa có dữ liệu',
      build: () {
        // null = tháng này chưa từng nhập thu nhập
        when(() => mockGet(any())).thenAnswer((_) async => const Right(null));

        return cubit;
      },
      act: (c) => c.loadIncome(period: tPeriod),
      expect: () => [
        isA<MonthlyIncomeLoading>(),
        isA<MonthlyIncomeLoaded>()
            .having((s) => s.existingIncome, 'existingIncome', isNull)
            .having((s) => s.amountRaw, 'amountRaw rỗng', ''),
      ],
    );

    blocTest<MonthlyIncomeCubit, MonthlyIncomeState>(
      'phát [Loading, Failure] — khi use case thất bại',
      build: () {
        when(
          () => mockGet(any()),
        ).thenAnswer((_) async => Left(const _TestFailure('DB lỗi')));

        return cubit;
      },
      act: (c) => c.loadIncome(period: tPeriod),
      expect: () => [
        isA<MonthlyIncomeLoading>(),
        isA<MonthlyIncomeFailure>().having(
          (s) => s.message,
          'message',
          'DB lỗi',
        ),
      ],
    );
  });
  // ─── 3. changePeriod() ───────────────────────────────────────────────
  // changePeriod() ủy quyền cho loadIncome() với period mới.
  group('changePeriod()', () {
    blocTest<MonthlyIncomeCubit, MonthlyIncomeState>(
      'phát [Loading, Loaded] — chuyển sang kỳ mới đúng period',
      build: () {
        when(
          () => mockGet(any()),
        ).thenAnswer((_) async => Right(_income(period: '2024-09')));

        return cubit;
      },
      act: (c) => c.changePeriod(period: '2024-09'),
      expect: () => [
        isA<MonthlyIncomeLoading>(),
        isA<MonthlyIncomeLoaded>().having(
          (s) => s.period,
          'period mới',
          '2024-09',
        ),
      ],
      verify: (_) {
        final captured = verify(() => mockGet(captureAny())).captured;
        final params = captured.first as GetMonthlyIncomeParams;

        expect(params.period, '2024-09');
      },
    );
  });
  // ─── 4. startEditing() ───────────────────────────────────────────────
  group('startEditing()', () {
    blocTest<MonthlyIncomeCubit, MonthlyIncomeState>(
      'bật isEditing = true để cho phép chỉnh sửa thu nhập đã lưu',
      seed: () => _loaded(period: tPeriod),
      build: () => cubit,
      act: (c) => c.startEditing(),
      expect: () => [
        isA<MonthlyIncomeLoaded>().having(
          (s) => s.isEditing,
          'isEditing',
          true,
        ),
      ],
    );

    blocTest<MonthlyIncomeCubit, MonthlyIncomeState>(
      'không làm gì nếu state không phải Loaded',
      // State ban đầu là Initial → startEditing() phải bị bỏ qua
      build: () => cubit,
      act: (c) => c.startEditing(),
      expect: () => [],
    );
  });
  // ─── 5. cancelEditing() ──────────────────────────────────────────────
  group('cancelEditing()', () {
    blocTest<MonthlyIncomeCubit, MonthlyIncomeState>(
      'khôi phục amountRaw về giá trị đã lưu và tắt chế độ chỉnh sửa',
      seed: () => _loaded(
        period: tPeriod,
        amountRaw: '5000000',
      ).copyWith(amountRaw: '9999999', isEditing: true),
      build: () => cubit,
      act: (c) => c.cancelEditing(),
      expect: () => [
        // amountRaw phải quay về income của existingIncome
        isA<MonthlyIncomeLoaded>()
            .having((s) => s.isEditing, 'isEditing', false)
            .having((s) => s.amountRaw, 'amountRaw phục hồi', '5000000'),
      ],
    );

    blocTest<MonthlyIncomeCubit, MonthlyIncomeState>(
      'amountRaw rỗng khi chưa có existingIncome',
      seed: () => _loaded(
        period: tPeriod,
        amountRaw: '0',
        noExistingIncome: true,
      ).copyWith(amountRaw: '500', isEditing: true),
      build: () => cubit,
      act: (c) => c.cancelEditing(),
      expect: () => [
        isA<MonthlyIncomeLoaded>()
            .having((s) => s.isEditing, 'isEditing', false)
            .having((s) => s.amountRaw, 'amountRaw rỗng', ''),
      ],
    );
  });
  // ─── 6. handleNumpadKey() ────────────────────────────────────────────
  group('handleNumpadKey()', () {
    // Seed ở chế độ nhập mới (chưa có existingIncome → isInputMode = true)
    final inputState = _loaded(
      period: tPeriod,
      amountRaw: '100',
      noExistingIncome: true,
    );

    blocTest<MonthlyIncomeCubit, MonthlyIncomeState>(
      'nhập chữ số — thêm vào cuối amountRaw',
      seed: () => inputState,
      build: () => cubit,
      act: (c) => c.handleNumpadKey(key: '5'),
      expect: () => [
        isA<MonthlyIncomeLoaded>().having(
          (s) => s.amountRaw,
          'amountRaw',
          '1005',
        ),
      ],
    );

    blocTest<MonthlyIncomeCubit, MonthlyIncomeState>(
      'nhấn ⌫ — xóa ký tự cuối cùng',
      seed: () => inputState,
      build: () => cubit,
      act: (c) => c.handleNumpadKey(key: '⌫'),
      expect: () => [
        isA<MonthlyIncomeLoaded>().having(
          (s) => s.amountRaw,
          'amountRaw',
          '10',
        ),
      ],
    );

    blocTest<MonthlyIncomeCubit, MonthlyIncomeState>(
      'nhấn ⌫ khi amountRaw đã rỗng — không phát state mới (Equatable ngăn emit trùng)',
      seed: () => inputState.copyWith(amountRaw: '', clearExistingIncome: true),
      build: () => cubit,
      act: (c) => c.handleNumpadKey(key: '⌫'),
      expect: () => [], // raw mới == raw cũ → bloc không emit duplicate state
    );

    blocTest<MonthlyIncomeCubit, MonthlyIncomeState>(
      'không cho nhập khi amountRaw đã đạt giới hạn 13 ký tự',
      seed: () => inputState.copyWith(
        amountRaw: '1234567890123',
        clearExistingIncome: true,
      ),
      build: () => cubit,
      act: (c) => c.handleNumpadKey(key: '4'),
      expect: () => [], // Guard trả về sớm, không phát state mới
    );

    blocTest<MonthlyIncomeCubit, MonthlyIncomeState>(
      'loại bỏ số 0 đứng đầu khi nhập số mới',
      seed: () =>
          inputState.copyWith(amountRaw: '0', clearExistingIncome: true),
      build: () => cubit,
      act: (c) => c.handleNumpadKey(key: '7'),
      expect: () => [
        isA<MonthlyIncomeLoaded>().having(
          (s) => s.amountRaw,
          'không có leading zero',
          '7',
        ),
      ],
    );

    blocTest<MonthlyIncomeCubit, MonthlyIncomeState>(
      'không làm gì nếu không ở isInputMode',
      // existingIncome tồn tại + isEditing = false → isInputMode = false
      seed: () => _loaded(period: tPeriod, amountRaw: '5000000'),
      build: () => cubit,
      act: (c) => c.handleNumpadKey(key: '1'),
      expect: () => [],
    );
  });
  // ─── 7. setAmount() ──────────────────────────────────────────────────
  group('setAmount()', () {
    blocTest<MonthlyIncomeCubit, MonthlyIncomeState>(
      'ghi đè amountRaw trực tiếp khi ở isInputMode',
      seed: () =>
          _loaded(period: tPeriod, amountRaw: '0', noExistingIncome: true),
      build: () => cubit,
      act: (c) => c.setAmount(amountRaw: '3500000'),
      expect: () => [
        isA<MonthlyIncomeLoaded>().having(
          (s) => s.amountRaw,
          'amountRaw',
          '3500000',
        ),
      ],
    );

    blocTest<MonthlyIncomeCubit, MonthlyIncomeState>(
      'không làm gì nếu không ở isInputMode',
      // Có existingIncome và không edit → isInputMode = false
      seed: () => _loaded(period: tPeriod, amountRaw: '5000000'),
      build: () => cubit,
      act: (c) => c.setAmount(amountRaw: '9999'),
      expect: () => [],
    );
  });

  // ─── 8. saveOrUpdateIncome() ─────────────────────────────────────────
  group('saveOrUpdateIncome()', () {
    // Trạng thái có thể lưu: không có existingIncome, amount > 0
    final savableState = _loaded(
      period: tPeriod,
      amountRaw: '2000000',
      noExistingIncome: true,
    );

    blocTest<MonthlyIncomeCubit, MonthlyIncomeState>(
      'phát [Saving, Loaded] — lưu thành công, existingIncome được cập nhật',
      seed: () => savableState,
      build: () {
        // ignore: void_checks
        when(() => mockSave(any())).thenAnswer((_) async => const Right(unit));

        return cubit;
      },
      act: (c) => c.saveOrUpdateIncome(),
      expect: () => [
        isA<MonthlyIncomeSaving>(),
        isA<MonthlyIncomeLoaded>()
            .having((s) => s.isEditing, 'isEditing', false)
            .having((s) => s.amountRaw, 'amountRaw', '2000000')
            .having(
              (s) => s.existingIncome,
              'existingIncome không null',
              isNotNull,
            ),
      ],
      verify: (_) {
        // Dùng captureAny để bắt entity và kiểm tra income
        final captured = verify(() => mockSave(captureAny())).captured;
        final entity = captured.first as MonthlyIncomeEntity;

        expect(entity.income, 2000000);
      },
    );

    blocTest<MonthlyIncomeCubit, MonthlyIncomeState>(
      'phát [Saving, Failure] — khi use case lưu thất bại',
      seed: () => savableState,
      build: () {
        when(
          () => mockSave(any()),
        ).thenAnswer((_) async => Left(const _TestFailure('Lỗi lưu')));

        return cubit;
      },
      act: (c) => c.saveOrUpdateIncome(),
      expect: () => [
        isA<MonthlyIncomeSaving>(),
        isA<MonthlyIncomeFailure>().having(
          (s) => s.message,
          'message',
          'Lỗi lưu',
        ),
      ],
    );

    blocTest<MonthlyIncomeCubit, MonthlyIncomeState>(
      'không làm gì nếu canSave = false (amountRaw = 0)',
      // numericAmount = 0 → canSave = false → guard trả về sớm
      seed: () =>
          savableState.copyWith(amountRaw: '0', clearExistingIncome: true),
      build: () => cubit,
      act: (c) => c.saveOrUpdateIncome(),
      expect: () => [],
      verify: (_) => verifyNever(() => mockSave(any())),
    );
  });
  // ─── 9. fetchAllPeriods() ────────────────────────────────────────────
  group('fetchAllPeriods()', () {
    test('trả về danh sách period của tất cả kỳ đã có dữ liệu', () async {
      // Arrange
      final incomes = [_income(period: '2026-03'), _income(period: '2026-02')];

      when(() => mockGetAll(any())).thenAnswer((_) async => Right(incomes));
      // Act
      final result = await cubit.fetchAllPeriods();
      // Assert
      expect(result, equals(['2026-03', '2026-02']));
      verify(() => mockGetAll(any())).called(1);
    });

    test('trả về danh sách rỗng nếu use case thất bại', () async {
      // Arrange
      when(
        () => mockGetAll(any()),
      ).thenAnswer((_) async => Left(const _TestFailure('Lỗi đọc')));
      // Act
      final result = await cubit.fetchAllPeriods();
      // Assert
      expect(result, isEmpty);
    });
  });
}

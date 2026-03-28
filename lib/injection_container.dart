import 'package:get_it/get_it.dart';

import 'features/expense/add/data/datasources/expense_local_datasource.dart';
import 'features/expense/add/data/repositories/expense_repository_impl.dart';
import 'features/expense/add/domain/repositories/expense_repository.dart';
import 'features/expense/add/domain/usecases/add_expense_usecase.dart';
import 'features/expense/add/domain/usecases/delete_expense_usecase.dart';
import 'features/expense/add/domain/usecases/get_expenses_usecase.dart';
import 'features/expense/add/presentation/bloc/add_expense_bloc.dart';
import 'features/expense/income/data/datasources/monthly_income_local_datasource.dart';
import 'features/expense/income/data/repositories/monthly_income_repository_impl.dart';
import 'features/expense/income/domain/repositories/monthly_income_repository.dart';
import 'features/expense/income/domain/usecases/get_all_monthly_incomes_usecase.dart';
import 'features/expense/income/domain/usecases/get_monthly_income_usecase.dart';
import 'features/expense/income/domain/usecases/save_monthly_income_usecase.dart';
import 'features/expense/income/presentation/cubit/monthly_income_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── Datasources ──────────────────────────────────────────────────────────
  await ExpenseLocalDatasourceImpl.init();
  await MonthlyIncomeLocalDatasourceImpl.init();

  sl.registerLazySingleton<ExpenseLocalDatasource>(
    () => ExpenseLocalDatasourceImpl(),
  );
  sl.registerLazySingleton<MonthlyIncomeLocalDatasource>(
    () => MonthlyIncomeLocalDatasourceImpl(),
  );

  // ── Repositories ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<MonthlyIncomeRepository>(
    () => MonthlyIncomeRepositoryImpl(datasource: sl()),
  );

  // ── Use Cases ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton(
    () => AddExpenseUseCase(repository: sl(), getMonthlyIncomeUseCase: sl()),
  );
  sl.registerLazySingleton(() => GetExpensesUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteExpenseUseCase(repository: sl()));

  sl.registerLazySingleton(() => GetMonthlyIncomeUseCase(repository: sl()));
  sl.registerLazySingleton(() => SaveMonthlyIncomeUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetAllMonthlyIncomesUseCase(repository: sl()));

  // ── Bloc / Cubit (factory = new instance per route) ───────────────────────
  sl.registerFactory(
    () => AddExpenseBloc(
      addExpenseUseCase: sl(),
      deleteExpenseUseCase: sl(),
      getExpensesUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => MonthlyIncomeCubit(
      getMonthlyIncomeUseCase: sl(),
      saveMonthlyIncomeUseCase: sl(),
      getAllMonthlyIncomesUseCase: sl(),
    ),
  );
}

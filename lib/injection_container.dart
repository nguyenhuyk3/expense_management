import 'package:get_it/get_it.dart';

import 'features/expense/add/data/datasources/expense_local_datasource.dart';
import 'features/expense/add/data/repositories/expense_repository_impl.dart';
import 'features/expense/add/domain/repositories/expense_repository.dart';
import 'features/expense/add/domain/usecases/add_expense_usecase.dart';
import 'features/expense/add/domain/usecases/delete_expense_usecase.dart';
import 'features/expense/add/domain/usecases/get_expenses_usecase.dart';
import 'features/expense/add/presentation/bloc/add_expense_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── Datasources ──────────────────────────────────────────────────────────
  await ExpenseLocalDatasourceImpl.init();

  sl.registerLazySingleton<ExpenseLocalDatasource>(
    () => ExpenseLocalDatasourceImpl(),
  );

  // ── Repositories ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(sl()),
  );

  // ── Use Cases ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => AddExpenseUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetExpensesUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteExpenseUseCase(repository: sl()));

  // ── Bloc (factory = new instance per route) ───────────────────────────────
  sl.registerFactory(
    () => AddExpenseBloc(
      addExpenseUseCase: sl(),
      deleteExpenseUseCase: sl(),
      getExpensesUseCase: sl(),
    ),
  );
}

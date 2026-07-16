import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/database/database_service.dart';
import '../../core/database/entity_mapper.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/notification_scheduler.dart';
import '../../features/analytics/data/services/analytics_calculator.dart';
import '../../features/expenses/data/datasources/category_local_datasource.dart';
import '../../features/expenses/data/datasources/category_local_datasource_impl.dart';
import '../../features/expenses/data/datasources/category_seeder.dart';
import '../../features/expenses/data/datasources/expense_local_datasource.dart';
import '../../features/expenses/data/datasources/expense_local_datasource_impl.dart';
import '../../features/expenses/data/repositories/category_repository_impl.dart';
import '../../features/expenses/data/repositories/expense_repository_impl.dart';
import '../../features/expenses/domain/repositories/category_repository.dart';
import '../../features/expenses/domain/repositories/expense_repository.dart';
import '../../features/expenses/domain/usecases/category_usecases.dart';
import '../../features/expenses/domain/usecases/expense_usecases.dart';
import '../../features/ledger/data/datasources/contact_local_datasource.dart';
import '../../features/ledger/data/datasources/contact_local_datasource_impl.dart';
import '../../features/ledger/data/datasources/ledger_entry_local_datasource.dart';
import '../../features/ledger/data/datasources/ledger_entry_local_datasource_impl.dart';
import '../../features/ledger/data/repositories/contact_repository_impl.dart';
import '../../features/ledger/data/repositories/ledger_entry_repository_impl.dart';
import '../../features/ledger/domain/repositories/contact_repository.dart';
import '../../features/ledger/domain/repositories/ledger_entry_repository.dart';
import '../../features/ledger/domain/usecases/contact_usecases.dart';
import '../../features/ledger/domain/usecases/ledger_entry_usecases.dart';
import '../providers/theme_provider.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // Core services
  sl.registerLazySingleton<DatabaseService>(() => DatabaseService());
  sl.registerLazySingleton<NotificationService>(() => NotificationService());

  // Notification scheduler
  sl.registerLazySingleton<NotificationScheduler>(
    () => LocalNotificationScheduler(sl()),
  );

  // Application layer
  sl.registerLazySingleton<ThemeProvider>(() => ThemeProvider(sl()));

  // Analytics
  sl.registerLazySingleton<AnalyticsCalculator>(() => AnalyticsCalculator());

  // Entity mappers
  sl.registerLazySingleton<ExpenseMapper>(() => ExpenseMapper());
  sl.registerLazySingleton<CategoryMapper>(() => CategoryMapper());

  // Category feature
  sl.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<CategorySeeder>(() => CategorySeeder(sl()));
  sl.registerLazySingleton<GetAllCategories>(() => GetAllCategories(sl()));
  sl.registerLazySingleton<GetDefaultCategories>(() => GetDefaultCategories(sl()));
  sl.registerLazySingleton<GetCategoryById>(() => GetCategoryById(sl()));
  sl.registerLazySingleton<SaveCategory>(() => SaveCategory(sl()));
  sl.registerLazySingleton<DeleteCategory>(() => DeleteCategory(sl()));

  // Expense feature
  sl.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSourceImpl(sl(), sl<ExpenseMapper>()),
  );
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<CreateExpense>(() => CreateExpense(sl()));
  sl.registerLazySingleton<UpdateExpense>(() => UpdateExpense(sl()));
  sl.registerLazySingleton<DeleteExpense>(() => DeleteExpense(sl()));
  sl.registerLazySingleton<GetExpenseById>(() => GetExpenseById(sl()));
  sl.registerLazySingleton<GetAllExpenses>(() => GetAllExpenses(sl()));
  sl.registerLazySingleton<SearchExpenses>(() => SearchExpenses(sl()));
  sl.registerLazySingleton<GetExpensesByCategory>(() => GetExpensesByCategory(sl()));
  sl.registerLazySingleton<GetExpensesByDateRange>(() => GetExpensesByDateRange(sl()));
  sl.registerLazySingleton<GetFilteredExpenses>(() => GetFilteredExpenses(sl()));
  sl.registerLazySingleton<GetDashboardStats>(() => GetDashboardStats(sl()));

  // Ledger feature — Mappers
  sl.registerLazySingleton<ContactMapper>(() => ContactMapper());
  sl.registerLazySingleton<LedgerEntryMapper>(() => LedgerEntryMapper());

  // Ledger feature — Data sources
  sl.registerLazySingleton<ContactLocalDataSource>(
    () => ContactLocalDataSourceImpl(sl(), sl<ContactMapper>()),
  );
  sl.registerLazySingleton<LedgerEntryLocalDataSource>(
    () => LedgerEntryLocalDataSourceImpl(sl(), sl<LedgerEntryMapper>()),
  );

  // Ledger feature — Repositories
  sl.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<LedgerEntryRepository>(
    () => LedgerEntryRepositoryImpl(sl()),
  );

  // Ledger feature — Use cases (Contact)
  sl.registerLazySingleton<CreateContact>(() => CreateContact(sl()));
  sl.registerLazySingleton<UpdateContact>(() => UpdateContact(sl()));
  sl.registerLazySingleton<DeleteContact>(() => DeleteContact(sl()));
  sl.registerLazySingleton<GetContactById>(() => GetContactById(sl()));
  sl.registerLazySingleton<GetAllContacts>(() => GetAllContacts(sl()));
  sl.registerLazySingleton<SearchContacts>(() => SearchContacts(sl()));

  // Ledger feature — Use cases (LedgerEntry)
  sl.registerLazySingleton<CreateLedgerEntry>(() => CreateLedgerEntry(sl()));
  sl.registerLazySingleton<UpdateLedgerEntry>(() => UpdateLedgerEntry(sl()));
  sl.registerLazySingleton<DeleteLedgerEntry>(() => DeleteLedgerEntry(sl()));
  sl.registerLazySingleton<GetLedgerEntryById>(() => GetLedgerEntryById(sl()));
  sl.registerLazySingleton<GetAllLedgerEntries>(() => GetAllLedgerEntries(sl()));
  sl.registerLazySingleton<GetLedgerEntriesByContact>(() => GetLedgerEntriesByContact(sl()));
  sl.registerLazySingleton<GetRecentLedgerEntries>(() => GetRecentLedgerEntries(sl()));
  sl.registerLazySingleton<GetOverdueEntries>(() => GetOverdueEntries(sl()));
  sl.registerLazySingleton<GetTotalReceivable>(() => GetTotalReceivable(sl()));
  sl.registerLazySingleton<GetTotalPayable>(() => GetTotalPayable(sl()));
}

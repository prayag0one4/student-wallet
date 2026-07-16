import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../../expenses/domain/repositories/expense_repository.dart';
import '../../../expenses/domain/usecases/expense_usecases.dart';
import '../../data/services/analytics_calculator.dart';

final analyticsExpensesProvider = FutureProvider<List<Expense>>((ref) async {
  final usecase = GetIt.instance<GetAllExpenses>();
  final result = await usecase();
  return result.fold(
    onSuccess: (data) => data,
    onFailure: (f) => throw f,
  );
});

final monthlyTrendProvider = FutureProvider<List<MonthlyTrend>>((ref) async {
  final expenses = ref.watch(analyticsExpensesProvider).valueOrNull ?? [];
  final calculator = GetIt.instance<AnalyticsCalculator>();
  return calculator.calculateMonthlyTrend(expenses);
});

final categoryDistributionProvider =
    FutureProvider<List<CategoryShare>>((ref) async {
  final expenses = ref.watch(analyticsExpensesProvider).valueOrNull ?? [];
  final calculator = GetIt.instance<AnalyticsCalculator>();
  return calculator.calculateCategoryDistribution(expenses);
});

final averageTransactionProvider = FutureProvider<double>((ref) async {
  final expenses = ref.watch(analyticsExpensesProvider).valueOrNull ?? [];
  final calculator = GetIt.instance<AnalyticsCalculator>();
  return calculator.calculateAverageTransaction(expenses);
});

class DashboardData {
  final double monthlySpending;
  final double previousMonthSpending;
  final double percentageChange;
  final double todaySpending;
  final double dailyAverage;
  final List<Expense> recentExpenses;
  final List<CategoryShare> categoryBreakdown;

  DashboardData({
    required this.monthlySpending,
    required this.previousMonthSpending,
    required this.percentageChange,
    required this.todaySpending,
    required this.dailyAverage,
    required this.recentExpenses,
    required this.categoryBreakdown,
  });
}

final dashboardProvider = FutureProvider<DashboardData>((ref) async {
  final expenses = ref.watch(analyticsExpensesProvider).valueOrNull ?? [];
  final calculator = GetIt.instance<AnalyticsCalculator>();
  final repoResult = await GetIt.instance<ExpenseRepository>().getRecentExpenses(count: 5);

  final recentExpenses = repoResult.fold(
    onSuccess: (data) => data,
    onFailure: (f) => throw f,
  );

  final now = DateTime.now();
  final currentMonth = now.startOfMonth;
  final previousMonth = DateTime(now.year, now.month - 1, 1);

  final comparison = calculator.compareMonths(expenses, currentMonth, previousMonth);
  final categoryDist = calculator.calculateCategoryDistribution(
    expenses.where((e) => e.expenseDate.isSameMonth(now)).toList(),
  );

  final todayExpenses = expenses
      .where((e) => e.expenseDate.isSameDay(now))
      .fold<double>(0, (sum, e) => sum + e.amount);

  final daysInMonth = now.daysInMonth;
  final dailyAvg = comparison.currentTotal / (now.day < daysInMonth ? now.day : daysInMonth);

  return DashboardData(
    monthlySpending: comparison.currentTotal,
    previousMonthSpending: comparison.previousTotal,
    percentageChange: comparison.percentageChange,
    todaySpending: todayExpenses,
    dailyAverage: dailyAvg,
    recentExpenses: recentExpenses,
    categoryBreakdown: categoryDist,
  );
});

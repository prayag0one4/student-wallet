import '../../../../core/extensions/date_time_extension.dart';
import '../../../expenses/domain/entities/expense.dart';

class MonthlyTrend {
  final DateTime month;
  final double total;
  MonthlyTrend({required this.month, required this.total});
}

class WeeklyTrend {
  final DateTime weekStart;
  final double total;
  WeeklyTrend({required this.weekStart, required this.total});
}

class CategoryShare {
  final int categoryId;
  final double total;
  final double percentage;
  CategoryShare({
    required this.categoryId,
    required this.total,
    required this.percentage,
  });
}

class ComparisonResult {
  final double currentTotal;
  final double previousTotal;
  final double percentageChange;
  ComparisonResult({
    required this.currentTotal,
    required this.previousTotal,
    required this.percentageChange,
  });
}

class AnalyticsCalculator {
  List<MonthlyTrend> calculateMonthlyTrend(List<Expense> expenses) {
    final monthlyMap = <DateTime, double>{};
    for (final e in expenses) {
      final key = DateTime(e.expenseDate.year, e.expenseDate.month);
      monthlyMap[key] = (monthlyMap[key] ?? 0) + e.amount;
    }
    return monthlyMap.entries
        .map((e) => MonthlyTrend(month: e.key, total: e.value))
        .toList()
      ..sort((a, b) => a.month.compareTo(b.month));
  }

  List<WeeklyTrend> calculateWeeklyTrend(List<Expense> expenses) {
    final weeklyMap = <DateTime, double>{};
    for (final e in expenses) {
      final key = e.expenseDate.startOfWeek;
      weeklyMap[key] = (weeklyMap[key] ?? 0) + e.amount;
    }
    return weeklyMap.entries
        .map((e) => WeeklyTrend(weekStart: e.key, total: e.value))
        .toList()
      ..sort((a, b) => a.weekStart.compareTo(b.weekStart));
  }

  List<CategoryShare> calculateCategoryDistribution(List<Expense> expenses) {
    final categoryMap = <int, double>{};
    double grandTotal = 0;

    for (final e in expenses) {
      categoryMap[e.categoryId] = (categoryMap[e.categoryId] ?? 0) + e.amount;
      grandTotal += e.amount;
    }

    if (grandTotal == 0) return [];

    return categoryMap.entries
        .map((e) => CategoryShare(
              categoryId: e.key,
              total: e.value,
              percentage: (e.value / grandTotal) * 100,
            ))
        .toList()
      ..sort((a, b) => b.total.compareTo(a.total));
  }

  double calculateAverageTransaction(List<Expense> expenses) {
    if (expenses.isEmpty) return 0;
    return expenses.map((e) => e.amount).reduce((a, b) => a + b) / expenses.length;
  }

  Map<int, int> calculateSpendingFrequency(List<Expense> expenses) {
    final frequencyMap = <int, int>{};
    for (final e in expenses) {
      final day = e.expenseDate.weekday;
      frequencyMap[day] = (frequencyMap[day] ?? 0) + 1;
    }
    return frequencyMap;
  }

  ComparisonResult compareMonths(
    List<Expense> allExpenses,
    DateTime currentMonth,
    DateTime previousMonth,
  ) {
    final currentTotal = allExpenses
        .where((e) => e.expenseDate.isSameMonth(currentMonth))
        .fold<double>(0, (sum, e) => sum + e.amount);

    final previousTotal = allExpenses
        .where((e) => e.expenseDate.isSameMonth(previousMonth))
        .fold<double>(0, (sum, e) => sum + e.amount);

    double percentageChange = 0;
    if (previousTotal > 0) {
      percentageChange = ((currentTotal - previousTotal) / previousTotal) * 100;
    } else if (currentTotal > 0) {
      percentageChange = 100;
    }

    return ComparisonResult(
      currentTotal: currentTotal,
      previousTotal: previousTotal,
      percentageChange: percentageChange,
    );
  }
}

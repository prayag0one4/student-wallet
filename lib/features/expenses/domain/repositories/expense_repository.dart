import '../../../../core/errors/result.dart';
import '../../domain/entities/expense.dart';
import '../../../../core/constants/payment_method.dart';

abstract class ExpenseRepository {
  Future<Result<List<Expense>>> getAllExpenses({int? offset, int? limit});
  Future<Result<Expense>> createExpense(Expense expense);
  Future<Result<Expense>> updateExpense(Expense expense);
  Future<Result<void>> deleteExpense(int id);
  Future<Result<Expense?>> getExpenseById(int id);
  Future<Result<List<Expense>>> searchExpenses(String query);
  Future<Result<List<Expense>>> getExpensesByCategory(int categoryId);
  Future<Result<List<Expense>>> getExpensesByDateRange(DateTime start, DateTime end);
  Future<Result<List<Expense>>> getFilteredExpenses({
    int? categoryId,
    PaymentMethod? paymentMethod,
    DateTime? startDate,
    DateTime? endDate,
    String? sortBy,
    bool descending = true,
    int? offset,
    int? limit,
  });
  Future<Result<int>> getExpenseCount();
  Future<Result<List<Expense>>> getRecentExpenses({int count = 5});
}

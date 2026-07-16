import '../../../../core/errors/result.dart';
import '../../../../core/constants/payment_method.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class CreateExpense {
  final ExpenseRepository _repository;
  CreateExpense(this._repository);
  Future<Result<Expense>> call(Expense expense) => _repository.createExpense(expense);
}

class UpdateExpense {
  final ExpenseRepository _repository;
  UpdateExpense(this._repository);
  Future<Result<Expense>> call(Expense expense) => _repository.updateExpense(expense);
}

class DeleteExpense {
  final ExpenseRepository _repository;
  DeleteExpense(this._repository);
  Future<Result<void>> call(int id) => _repository.deleteExpense(id);
}

class GetExpenseById {
  final ExpenseRepository _repository;
  GetExpenseById(this._repository);
  Future<Result<Expense?>> call(int id) => _repository.getExpenseById(id);
}

class GetAllExpenses {
  final ExpenseRepository _repository;
  GetAllExpenses(this._repository);
  Future<Result<List<Expense>>> call({int? offset, int? limit}) =>
      _repository.getAllExpenses(offset: offset, limit: limit);
}

class SearchExpenses {
  final ExpenseRepository _repository;
  SearchExpenses(this._repository);
  Future<Result<List<Expense>>> call(String query) =>
      _repository.searchExpenses(query);
}

class GetExpensesByCategory {
  final ExpenseRepository _repository;
  GetExpensesByCategory(this._repository);
  Future<Result<List<Expense>>> call(int categoryId) =>
      _repository.getExpensesByCategory(categoryId);
}

class GetExpensesByDateRange {
  final ExpenseRepository _repository;
  GetExpensesByDateRange(this._repository);
  Future<Result<List<Expense>>> call(DateTime start, DateTime end) =>
      _repository.getExpensesByDateRange(start, end);
}

class GetFilteredExpenses {
  final ExpenseRepository _repository;
  GetFilteredExpenses(this._repository);
  Future<Result<List<Expense>>> call({
    int? categoryId,
    PaymentMethod? paymentMethod,
    DateTime? startDate,
    DateTime? endDate,
    String? sortBy,
    bool descending = true,
    int? offset,
    int? limit,
  }) =>
      _repository.getFilteredExpenses(
        categoryId: categoryId,
        paymentMethod: paymentMethod,
        startDate: startDate,
        endDate: endDate,
        sortBy: sortBy,
        descending: descending,
        offset: offset,
        limit: limit,
      );
}

class GetDashboardStats {
  final ExpenseRepository _repository;
  GetDashboardStats(this._repository);

  Future<Result<List<Expense>>> call({int? offset, int? limit}) =>
      _repository.getAllExpenses(offset: offset, limit: limit);
}

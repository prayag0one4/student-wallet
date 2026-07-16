import '../../../../core/constants/payment_method.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_datasource.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource _localDataSource;
  final _logger = const AppLogger('ExpenseRepo');

  ExpenseRepositoryImpl(this._localDataSource);

  @override
  Future<Result<List<Expense>>> getAllExpenses({int? offset, int? limit}) async {
    try {
      final expenses = await _localDataSource.getAll(offset: offset, limit: limit);
      return Result.success(expenses);
    } catch (e) {
      _logger.error('Failed to get all expenses', e);
      return Result.failure(
        const DatabaseFailure(message: 'Failed to load expenses'),
      );
    }
  }

  @override
  Future<Result<Expense>> createExpense(Expense expense) async {
    try {
      final id = await _localDataSource.create(expense);
      return Result.success(expense.copyWith(localId: id));
    } catch (e) {
      _logger.error('Failed to create expense', e);
      return Result.failure(
        const DatabaseFailure(message: 'Failed to create expense'),
      );
    }
  }

  @override
  Future<Result<Expense>> updateExpense(Expense expense) async {
    try {
      await _localDataSource.update(expense);
      return Result.success(expense.copyWith(updatedAt: DateTime.now()));
    } catch (e) {
      _logger.error('Failed to update expense', e);
      return Result.failure(
        const DatabaseFailure(message: 'Failed to update expense'),
      );
    }
  }

  @override
  Future<Result<void>> deleteExpense(int id) async {
    try {
      await _localDataSource.delete(id);
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to delete expense: $id', e);
      return Result.failure(
        const DatabaseFailure(message: 'Failed to delete expense'),
      );
    }
  }

  @override
  Future<Result<Expense?>> getExpenseById(int id) async {
    try {
      final expense = await _localDataSource.getById(id);
      return Result.success(expense);
    } catch (e) {
      _logger.error('Failed to get expense by id: $id', e);
      return Result.failure(
        const DatabaseFailure(message: 'Failed to load expense'),
      );
    }
  }

  @override
  Future<Result<List<Expense>>> searchExpenses(String query) async {
    try {
      final expenses = await _localDataSource.search(query);
      return Result.success(expenses);
    } catch (e) {
      _logger.error('Failed to search expenses', e);
      return Result.failure(
        const DatabaseFailure(message: 'Failed to search expenses'),
      );
    }
  }

  @override
  Future<Result<List<Expense>>> getExpensesByCategory(int categoryId) async {
    try {
      final expenses = await _localDataSource.getByCategory(categoryId);
      return Result.success(expenses);
    } catch (e) {
      _logger.error('Failed to get expenses by category: $categoryId', e);
      return Result.failure(
        const DatabaseFailure(message: 'Failed to load expenses by category'),
      );
    }
  }

  @override
  Future<Result<List<Expense>>> getExpensesByDateRange(
      DateTime start, DateTime end) async {
    try {
      final expenses = await _localDataSource.getByDateRange(start, end);
      return Result.success(expenses);
    } catch (e) {
      _logger.error('Failed to get expenses by date range', e);
      return Result.failure(
        const DatabaseFailure(message: 'Failed to load expenses by date range'),
      );
    }
  }

  @override
  Future<Result<List<Expense>>> getFilteredExpenses({
    int? categoryId,
    PaymentMethod? paymentMethod,
    DateTime? startDate,
    DateTime? endDate,
    String? sortBy,
    bool descending = true,
    int? offset,
    int? limit,
  }) async {
    try {
      final expenses = await _localDataSource.getFiltered(
        categoryId: categoryId,
        paymentMethod: paymentMethod,
        startDate: startDate,
        endDate: endDate,
        sortBy: sortBy,
        descending: descending,
        offset: offset,
        limit: limit,
      );
      return Result.success(expenses);
    } catch (e) {
      _logger.error('Failed to get filtered expenses', e);
      return Result.failure(
        const DatabaseFailure(message: 'Failed to load filtered expenses'),
      );
    }
  }

  @override
  Future<Result<int>> getExpenseCount() async {
    try {
      final count = await _localDataSource.getCount();
      return Result.success(count);
    } catch (e) {
      _logger.error('Failed to get expense count', e);
      return Result.failure(
        const DatabaseFailure(message: 'Failed to get expense count'),
      );
    }
  }

  @override
  Future<Result<List<Expense>>> getRecentExpenses({int count = 5}) async {
    try {
      final expenses = await _localDataSource.getRecent(count: count);
      return Result.success(expenses);
    } catch (e) {
      _logger.error('Failed to get recent expenses', e);
      return Result.failure(
        const DatabaseFailure(message: 'Failed to load recent expenses'),
      );
    }
  }
}

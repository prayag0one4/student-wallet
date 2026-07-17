import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/group_expense_entity.dart';
import '../../domain/entities/expense_share_entity.dart';
import '../../domain/repositories/group_expense_repository.dart';
import '../datasources/group_expense_local_datasource.dart';

class GroupExpenseRepositoryImpl implements GroupExpenseRepository {
  final GroupExpenseLocalDataSource _localDataSource;
  final _logger = const AppLogger('GroupExpenseRepo');

  GroupExpenseRepositoryImpl(this._localDataSource);

  @override
  Future<Result<List<GroupExpense>>> getExpensesByGroup(int groupId, {int? offset, int? limit}) async {
    try {
      final expenses = await _localDataSource.getByGroup(groupId, offset: offset, limit: limit);
      return Result.success(expenses);
    } catch (e) {
      _logger.error('Failed to get expenses by group: $groupId', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to load expenses'));
    }
  }

  @override
  Future<Result<GroupExpense>> createExpense(GroupExpense expense, List<ExpenseShare> shares) async {
    try {
      final id = await _localDataSource.create(expense, shares);
      return Result.success(expense.copyWith(localId: id));
    } catch (e) {
      _logger.error('Failed to create expense', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to create expense'));
    }
  }

  @override
  Future<Result<GroupExpense>> updateExpense(GroupExpense expense, List<ExpenseShare> shares) async {
    try {
      await _localDataSource.update(expense, shares);
      return Result.success(expense.copyWith(updatedAt: DateTime.now()));
    } catch (e) {
      _logger.error('Failed to update expense', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to update expense'));
    }
  }

  @override
  Future<Result<void>> deleteExpense(int id) async {
    try {
      await _localDataSource.delete(id);
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to delete expense: $id', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to delete expense'));
    }
  }

  @override
  Future<Result<GroupExpense?>> getExpenseById(int id) async {
    try {
      final expense = await _localDataSource.getById(id);
      return Result.success(expense);
    } catch (e) {
      _logger.error('Failed to get expense by id: $id', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to load expense'));
    }
  }

  @override
  Future<Result<double>> getTotalByGroup(int groupId) async {
    try {
      final total = await _localDataSource.getTotalByGroup(groupId);
      return Result.success(total);
    } catch (e) {
      _logger.error('Failed to get total by group: $groupId', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to calculate total'));
    }
  }

  @override
  Future<Result<List<ExpenseShare>>> getSharesByExpense(int expenseId) async {
    try {
      final shares = await _localDataSource.getSharesByExpense(expenseId);
      return Result.success(shares);
    } catch (e) {
      _logger.error('Failed to get shares by expense: $expenseId', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to load shares'));
    }
  }

  @override
  Future<Result<List<ExpenseShare>>> getSharesByMember(int memberId) async {
    try {
      final shares = await _localDataSource.getSharesByMember(memberId);
      return Result.success(shares);
    } catch (e) {
      _logger.error('Failed to get shares by member: $memberId', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to load shares'));
    }
  }

  @override
  Future<Result<void>> updateShareSettlement(int shareId, double amount) async {
    try {
      await _localDataSource.updateShareSettlement(shareId, amount);
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to update share settlement: $shareId', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to update settlement'));
    }
  }
}

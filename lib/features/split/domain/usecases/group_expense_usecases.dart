import '../../../../core/errors/result.dart';
import '../entities/group_expense_entity.dart';
import '../entities/expense_share_entity.dart';
import '../repositories/group_expense_repository.dart';

class CreateGroupExpense {
  final GroupExpenseRepository _repository;
  CreateGroupExpense(this._repository);
  Future<Result<GroupExpense>> call(GroupExpense expense, List<ExpenseShare> shares) =>
      _repository.createExpense(expense, shares);
}

class UpdateGroupExpense {
  final GroupExpenseRepository _repository;
  UpdateGroupExpense(this._repository);
  Future<Result<GroupExpense>> call(GroupExpense expense, List<ExpenseShare> shares) =>
      _repository.updateExpense(expense, shares);
}

class DeleteGroupExpense {
  final GroupExpenseRepository _repository;
  DeleteGroupExpense(this._repository);
  Future<Result<void>> call(int id) => _repository.deleteExpense(id);
}

class GetGroupExpenseById {
  final GroupExpenseRepository _repository;
  GetGroupExpenseById(this._repository);
  Future<Result<GroupExpense?>> call(int id) => _repository.getExpenseById(id);
}

class GetGroupExpensesByGroup {
  final GroupExpenseRepository _repository;
  GetGroupExpensesByGroup(this._repository);
  Future<Result<List<GroupExpense>>> call(int groupId, {int? offset, int? limit}) =>
      _repository.getExpensesByGroup(groupId, offset: offset, limit: limit);
}

class GetGroupTotalExpense {
  final GroupExpenseRepository _repository;
  GetGroupTotalExpense(this._repository);
  Future<Result<double>> call(int groupId) => _repository.getTotalByGroup(groupId);
}

class GetSharesByExpense {
  final GroupExpenseRepository _repository;
  GetSharesByExpense(this._repository);
  Future<Result<List<ExpenseShare>>> call(int expenseId) => _repository.getSharesByExpense(expenseId);
}

class GetSharesByMember {
  final GroupExpenseRepository _repository;
  GetSharesByMember(this._repository);
  Future<Result<List<ExpenseShare>>> call(int memberId) => _repository.getSharesByMember(memberId);
}

class UpdateShareSettlement {
  final GroupExpenseRepository _repository;
  UpdateShareSettlement(this._repository);
  Future<Result<void>> call(int shareId, double amount) =>
      _repository.updateShareSettlement(shareId, amount);
}

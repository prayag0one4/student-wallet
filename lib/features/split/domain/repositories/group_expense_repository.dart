import '../../../../core/errors/result.dart';
import '../entities/group_expense_entity.dart';
import '../entities/expense_share_entity.dart';

abstract class GroupExpenseRepository {
  Future<Result<List<GroupExpense>>> getExpensesByGroup(int groupId, {int? offset, int? limit});
  Future<Result<GroupExpense?>> getExpenseById(int id);
  Future<Result<GroupExpense>> createExpense(GroupExpense expense, List<ExpenseShare> shares);
  Future<Result<GroupExpense>> updateExpense(GroupExpense expense, List<ExpenseShare> shares);
  Future<Result<void>> deleteExpense(int id);
  Future<Result<double>> getTotalByGroup(int groupId);
  Future<Result<List<ExpenseShare>>> getSharesByExpense(int expenseId);
  Future<Result<List<ExpenseShare>>> getSharesByMember(int memberId);
  Future<Result<void>> updateShareSettlement(int shareId, double amount);
}

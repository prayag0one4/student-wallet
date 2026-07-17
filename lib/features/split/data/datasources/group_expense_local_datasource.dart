import '../../domain/entities/group_expense_entity.dart';
import '../../domain/entities/expense_share_entity.dart';

abstract class GroupExpenseLocalDataSource {
  Future<List<GroupExpense>> getByGroup(int groupId, {int? offset, int? limit});
  Future<GroupExpense?> getById(int id);
  Future<int> create(GroupExpense expense, List<ExpenseShare> shares);
  Future<void> update(GroupExpense expense, List<ExpenseShare> shares);
  Future<void> delete(int id);
  Future<double> getTotalByGroup(int groupId);
  Future<List<ExpenseShare>> getSharesByExpense(int expenseId);
  Future<List<ExpenseShare>> getSharesByMember(int memberId);
  Future<void> updateShareSettlement(int shareId, double amount);
}

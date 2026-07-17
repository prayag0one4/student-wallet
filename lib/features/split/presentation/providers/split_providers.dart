import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/errors/result.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/entities/group_member_entity.dart';
import '../../domain/entities/group_expense_entity.dart';
import '../../domain/entities/expense_share_entity.dart';
import '../../domain/entities/settlement_entity.dart';
import '../../domain/services/debt_simplifier.dart';
import '../../domain/usecases/group_usecases.dart';
import '../../domain/usecases/member_usecases.dart';
import '../../domain/usecases/group_expense_usecases.dart';
import '../../domain/usecases/settlement_usecases.dart';

final groupListProvider = AsyncNotifierProvider<GroupListNotifier, List<Group>>(
  GroupListNotifier.new,
);

class GroupListNotifier extends AsyncNotifier<List<Group>> {
  @override
  Future<List<Group>> build() async {
    final usecase = GetIt.instance<GetAllGroups>();
    final result = await usecase();
    return _resolveResult(result);
  }

  void addGroupLocally(Group group) {
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data([group, ...current]);
  }

  void updateGroupLocally(Group group) {
    final current = state.valueOrNull ?? [];
    final index = current.indexWhere((g) => g.localId == group.localId);
    if (index != -1) {
      final updated = List<Group>.from(current);
      updated[index] = group;
      state = AsyncValue.data(updated);
    }
  }

  void removeGroupLocally(int id) {
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data(current.where((g) => g.localId != id).toList());
  }
}

final groupDetailProvider = FutureProvider.family<Group?, int>(
  (ref, id) async {
    final usecase = GetIt.instance<GetGroupById>();
    final result = await usecase(id);
    return _resolveResult(result);
  },
);

final memberListProvider = FutureProvider.family<List<GroupMember>, int>(
  (ref, groupId) async {
    final usecase = GetIt.instance<GetMembersByGroup>();
    final result = await usecase(groupId);
    return _resolveResult(result);
  },
);

final memberCountProvider = FutureProvider.family<int, int>(
  (ref, groupId) async {
    final usecase = GetIt.instance<GetMemberCount>();
    final result = await usecase(groupId);
    return _resolveResult(result);
  },
);

final memberDetailProvider = FutureProvider.family<GroupMember?, int>(
  (ref, id) async {
    final usecase = GetIt.instance<GetMemberById>();
    final result = await usecase(id);
    return _resolveResult(result);
  },
);

final memberShareProvider = FutureProvider.family<List<ExpenseShare>, int>(
  (ref, memberId) async {
    final usecase = GetIt.instance<GetSharesByMember>();
    final result = await usecase(memberId);
    return _resolveResult(result);
  },
);

final expenseListProvider =
    AsyncNotifierProvider.family<ExpenseListNotifier, List<GroupExpense>, int>(
  ExpenseListNotifier.new,
);

class ExpenseListNotifier extends FamilyAsyncNotifier<List<GroupExpense>, int> {
  final List<GroupExpense> _allExpenses = [];
  static const int _pageSize = 20;
  int _offset = 0;
  bool _hasMore = true;

  @override
  Future<List<GroupExpense>> build(int arg) async {
    _offset = 0;
    _allExpenses.clear();
    _hasMore = true;
    return _loadExpenses(arg);
  }

  Future<void> loadMore(int groupId) async {
    if (!_hasMore) return;
    _offset += _pageSize;
    try {
      final usecase = GetIt.instance<GetGroupExpensesByGroup>();
      final result = await usecase(groupId, offset: _offset, limit: _pageSize);
      final newExpenses = _resolveResult(result);
      if (newExpenses.length < _pageSize) _hasMore = false;
      _allExpenses.addAll(newExpenses);
      state = AsyncValue.data(List.from(_allExpenses));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void addExpenseLocally(GroupExpense expense) {
    _allExpenses.insert(0, expense);
    state = AsyncValue.data(List.from(_allExpenses));
  }

  void updateExpenseLocally(GroupExpense expense) {
    final index = _allExpenses.indexWhere((e) => e.localId == expense.localId);
    if (index != -1) {
      _allExpenses[index] = expense;
      state = AsyncValue.data(List.from(_allExpenses));
    }
  }

  void removeExpenseLocally(int id) {
    _allExpenses.removeWhere((e) => e.localId == id);
    state = AsyncValue.data(List.from(_allExpenses));
  }

  Future<List<GroupExpense>> _loadExpenses(int groupId) async {
    final usecase = GetIt.instance<GetGroupExpensesByGroup>();
    final result = await usecase(groupId, offset: _offset, limit: _pageSize);
    final expenses = _resolveResult(result);
    if (expenses.length < _pageSize) _hasMore = false;
    _allExpenses.addAll(expenses);
    return List.from(_allExpenses);
  }
}

final expenseDetailProvider = FutureProvider.family<GroupExpense?, int>(
  (ref, id) async {
    final usecase = GetIt.instance<GetGroupExpenseById>();
    final result = await usecase(id);
    return _resolveResult(result);
  },
);

final expenseSharesProvider = FutureProvider.family<List<ExpenseShare>, int>(
  (ref, expenseId) async {
    final usecase = GetIt.instance<GetSharesByExpense>();
    final result = await usecase(expenseId);
    return _resolveResult(result);
  },
);

final groupTotalExpenseProvider = FutureProvider.family<double, int>(
  (ref, groupId) async {
    final usecase = GetIt.instance<GetGroupTotalExpense>();
    final result = await usecase(groupId);
    return _resolveResult(result);
  },
);

final settlementListProvider = FutureProvider.family<List<Settlement>, int>(
  (ref, groupId) async {
    final usecase = GetIt.instance<GetSettlementsByGroup>();
    final result = await usecase(groupId);
    return _resolveResult(result);
  },
);

final settlementDetailProvider = FutureProvider.family<Settlement?, int>(
  (ref, id) async {
    final usecase = GetIt.instance<GetSettlementById>();
    final result = await usecase(id);
    return _resolveResult(result);
  },
);

final groupBalanceProvider = FutureProvider.family<GroupBalanceData, int>(
  (ref, groupId) async {
    final membersResult =
        await GetIt.instance<GetMembersByGroup>()(groupId);
    final members = _resolveResult(membersResult);

    final expensesResult =
        await GetIt.instance<GetGroupExpensesByGroup>()(groupId);
    final expenses = _resolveResult(expensesResult);

    final settlementsResult =
        await GetIt.instance<GetSettlementsByGroup>()(groupId);
    final settlements = _resolveResult(settlementsResult);

    final sharesList = <ExpenseShare>[];
    for (final expense in expenses) {
      if (expense.localId == null) continue;
      final sharesResult =
          await GetIt.instance<GetSharesByExpense>()(expense.localId!);
      sharesList.addAll(_resolveResult(sharesResult));
    }

    final expenseInputs = <ExpenseBalanceInput>[];
    for (final expense in expenses) {
      final shares = sharesList
          .where((s) => s.expenseId == expense.localId)
          .map((s) => ShareInput(memberId: s.memberId, amount: s.amount))
          .toList();
      expenseInputs.add(ExpenseBalanceInput(
        amount: expense.amount,
        paidByMemberId: expense.paidByMemberId,
        shares: shares,
      ));
    }

    final settInputs = settlements
        .map((s) => SettlementInput(
              payerId: s.payerId,
              receiverId: s.receiverId,
              amount: s.amount,
            ))
        .toList();

    final balances = DebtSimplifier.calculateBalances(
      expenses: expenseInputs,
      settlements: settInputs,
    );

    for (final member in members) {
      if (member.localId != null) {
        balances.putIfAbsent(member.localId!, () => 0.0);
      }
    }

    final simplifiedDebts = DebtSimplifier.simplify(balances);

    final memberBalances = <int, double>{};
    for (final member in members) {
      if (member.localId != null) {
        memberBalances[member.localId!] = balances[member.localId!] ?? 0;
      }
    }

    return GroupBalanceData(
      memberBalances: memberBalances,
      simplifiedDebts: simplifiedDebts,
    );
  },
);

class GroupBalanceData {
  final Map<int, double> memberBalances;
  final List<SimplifiedDebt> simplifiedDebts;

  const GroupBalanceData({
    required this.memberBalances,
    required this.simplifiedDebts,
  });
}

T _resolveResult<T>(Result<T> result) {
  return result.fold(
    onSuccess: (data) => data,
    onFailure: (failure) => throw failure,
  );
}

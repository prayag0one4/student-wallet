import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/constants/payment_method.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/usecases/expense_usecases.dart';
import 'expense_filter_state.dart';

final expenseFilterProvider =
    StateNotifierProvider<ExpenseFilterNotifier, ExpenseFilterState>(
  (ref) => ExpenseFilterNotifier(),
);

class ExpenseFilterNotifier extends StateNotifier<ExpenseFilterState> {
  ExpenseFilterNotifier() : super(const ExpenseFilterState());

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query, clearSearch: query.isEmpty);
  }

  void setDatePreset(String preset) {
    final now = DateTime.now();
    switch (preset) {
      case 'today':
        state = state.copyWith(startDate: now.startOfDay, endDate: now.endOfDay);
        break;
      case 'week':
        state = state.copyWith(startDate: now.startOfWeek, endDate: now.endOfWeek);
        break;
      case 'month':
        state = state.copyWith(startDate: now.startOfMonth, endDate: now.endOfMonth);
        break;
    }
  }

  void clearAll() {
    state = const ExpenseFilterState();
  }

  void applyFilters({
    int? categoryId,
    PaymentMethod? paymentMethod,
    String? datePreset,
    String? sortBy,
    bool descending = true,
  }) {
    final now = DateTime.now();
    DateTime? startDate;
    DateTime? endDate;

    switch (datePreset) {
      case 'today':
        startDate = now.startOfDay;
        endDate = now.endOfDay;
        break;
      case 'week':
        startDate = now.startOfWeek;
        endDate = now.endOfWeek;
        break;
      case 'month':
        startDate = now.startOfMonth;
        endDate = now.endOfMonth;
        break;
    }

    state = state.copyWith(
      categoryId: categoryId,
      clearCategory: categoryId == null,
      paymentMethod: paymentMethod,
      clearPaymentMethod: paymentMethod == null,
      startDate: startDate,
      endDate: endDate,
      clearDateRange: datePreset == null,
      sortBy: sortBy,
      descending: descending,
    );
  }
}

final expenseListProvider =
    AsyncNotifierProvider<ExpenseListNotifier, List<Expense>>(
  ExpenseListNotifier.new,
);

class ExpenseListNotifier extends AsyncNotifier<List<Expense>> {
  static const int _pageSize = 20;
  final List<Expense> _allExpenses = [];
  int _offset = 0;
  bool _hasMore = true;
  ExpenseFilterState? _lastFilter;

  @override
  Future<List<Expense>> build() async {
    ref.listen(expenseFilterProvider, (prev, next) {
      if (prev != next) {
        refresh();
      }
    });

    _allExpenses.clear();
    _offset = 0;
    _hasMore = true;
    return _loadExpenses();
  }

  Future<void> refresh() async {
    _offset = 0;
    _allExpenses.clear();
    _hasMore = true;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadExpenses());
  }

  Future<void> refreshSilent() async {
    _offset = 0;
    _allExpenses.clear();
    _hasMore = true;
    try {
      final expenses = await _loadFilteredExpenses();
      _allExpenses.addAll(expenses);
      if (expenses.length < _pageSize) _hasMore = false;
      state = AsyncValue.data(List.from(_allExpenses));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    _offset += _pageSize;
    try {
      final newExpenses = await _loadFilteredExpenses();
      if (newExpenses.length < _pageSize) _hasMore = false;
      _allExpenses.addAll(newExpenses);
      state = AsyncValue.data(List.from(_allExpenses));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void addExpenseLocally(Expense expense) {
    _allExpenses.insert(0, expense);
    state = AsyncValue.data(List.from(_allExpenses));
  }

  void updateExpenseLocally(Expense expense) {
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

  Future<List<Expense>> _loadExpenses() async {
    final expenses = await _loadFilteredExpenses();
    _allExpenses.addAll(expenses);
    if (expenses.length < _pageSize) _hasMore = false;
    return List.from(_allExpenses);
  }

  Future<List<Expense>> _loadFilteredExpenses() async {
    final filter = ref.read(expenseFilterProvider);

    if (filter.searchQuery.isNotEmpty) {
      final searchUsecase = GetIt.instance<SearchExpenses>();
      final result = await searchUsecase(filter.searchQuery);
      return _resolveResult(result);
    }

    final usecase = GetIt.instance<GetFilteredExpenses>();
    final result = await usecase(
      categoryId: filter.categoryId,
      paymentMethod: filter.paymentMethod,
      startDate: filter.startDate,
      endDate: filter.endDate,
      sortBy: filter.sortBy,
      descending: filter.descending,
      offset: _offset,
      limit: _pageSize,
    );
    return _resolveResult(result);
  }
}

T _resolveResult<T>(Result<T> result) {
  return result.fold(
    onSuccess: (data) => data,
    onFailure: (failure) => throw failure,
  );
}

final recentExpensesProvider = FutureProvider<List<Expense>>((ref) async {
  final repo = GetIt.instance<ExpenseRepository>();
  final result = await repo.getRecentExpenses(count: 5);
  return _resolveResult(result);
});

final expenseDetailProvider = FutureProvider.family<Expense?, int>(
  (ref, id) async {
    final usecase = GetIt.instance<GetExpenseById>();
    final result = await usecase(id);
    return _resolveResult(result);
  },
);

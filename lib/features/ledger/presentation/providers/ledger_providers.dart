import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/errors/result.dart';
import '../../domain/entities/ledger_entry.dart';
import '../../domain/usecases/ledger_entry_usecases.dart';

final ledgerEntryListProvider =
    AsyncNotifierProvider<LedgerEntryListNotifier, List<LedgerEntry>>(
  LedgerEntryListNotifier.new,
);

class LedgerEntryListNotifier extends AsyncNotifier<List<LedgerEntry>> {
  static const int _pageSize = 20;
  final List<LedgerEntry> _allEntries = [];
  int _offset = 0;
  bool _hasMore = true;

  @override
  Future<List<LedgerEntry>> build() async {
    _allEntries.clear();
    _offset = 0;
    _hasMore = true;
    return _loadEntries();
  }

  Future<void> refresh() async {
    _offset = 0;
    _allEntries.clear();
    _hasMore = true;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadEntries());
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    _offset += _pageSize;
    try {
      final usecase = GetIt.instance<GetAllLedgerEntries>();
      final result = await usecase(offset: _offset, limit: _pageSize);
      final entries = _resolveResult(result);
      if (entries.length < _pageSize) _hasMore = false;
      _allEntries.addAll(entries);
      state = AsyncValue.data(List.from(_allEntries));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void addEntryLocally(LedgerEntry entry) {
    _allEntries.insert(0, entry);
    state = AsyncValue.data(List.from(_allEntries));
  }

  void updateEntryLocally(LedgerEntry entry) {
    final index = _allEntries.indexWhere((e) => e.localId == entry.localId);
    if (index != -1) {
      _allEntries[index] = entry;
      state = AsyncValue.data(List.from(_allEntries));
    }
  }

  void removeEntryLocally(int id) {
    _allEntries.removeWhere((e) => e.localId == id);
    state = AsyncValue.data(List.from(_allEntries));
  }

  Future<List<LedgerEntry>> _loadEntries() async {
    final usecase = GetIt.instance<GetAllLedgerEntries>();
    final result = await usecase(offset: _offset, limit: _pageSize);
    final entries = _resolveResult(result);
    if (entries.length < _pageSize) _hasMore = false;
    _allEntries.addAll(entries);
    return List.from(_allEntries);
  }
}

final ledgerEntryDetailProvider = FutureProvider.family<LedgerEntry?, int>(
  (ref, id) async {
    final usecase = GetIt.instance<GetLedgerEntryById>();
    final result = await usecase(id);
    return _resolveResult(result);
  },
);

final contactLedgerEntriesProvider =
    FutureProvider.family<List<LedgerEntry>, int>(
  (ref, contactId) async {
    final usecase = GetIt.instance<GetLedgerEntriesByContact>();
    final result = await usecase(contactId);
    return _resolveResult(result);
  },
);

final recentLedgerEntriesProvider = FutureProvider<List<LedgerEntry>>((ref) async {
  final usecase = GetIt.instance<GetRecentLedgerEntries>();
  final result = await usecase(count: 5);
  return _resolveResult(result);
});

final overdueEntriesProvider = FutureProvider<List<LedgerEntry>>((ref) async {
  final usecase = GetIt.instance<GetOverdueEntries>();
  final result = await usecase();
  return _resolveResult(result);
});

T _resolveResult<T>(Result<T> result) {
  return result.fold(
    onSuccess: (data) => data,
    onFailure: (failure) => throw failure,
  );
}

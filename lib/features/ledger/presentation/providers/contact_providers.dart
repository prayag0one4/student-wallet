import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/errors/result.dart';
import '../../domain/entities/contact.dart';
import '../../domain/entities/ledger_entry.dart';
import '../../domain/usecases/contact_usecases.dart';
import '../../domain/usecases/ledger_entry_usecases.dart';

final contactListProvider = AsyncNotifierProvider<ContactListNotifier, List<Contact>>(
  ContactListNotifier.new,
);

class ContactListNotifier extends AsyncNotifier<List<Contact>> {
  String _searchQuery = '';

  void setSearch(String query) {
    _searchQuery = query;
    ref.read(searchQueryProvider.notifier).state = query;
    ref.invalidateSelf();
  }

  @override
  Future<List<Contact>> build() async {
    if (_searchQuery.isNotEmpty) {
      final usecase = GetIt.instance<SearchContacts>();
      final result = await usecase(_searchQuery);
      return _resolveResult(result);
    }
    final usecase = GetIt.instance<GetAllContacts>();
    final result = await usecase();
    return _resolveResult(result);
  }

  void addContactLocally(Contact contact) {
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data([contact, ...current]);
  }

  void updateContactLocally(Contact contact) {
    final current = state.valueOrNull ?? [];
    final index = current.indexWhere((c) => c.localId == contact.localId);
    if (index != -1) {
      final updated = List<Contact>.from(current);
      updated[index] = contact;
      state = AsyncValue.data(updated);
    }
  }

  void removeContactLocally(int id) {
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data(current.where((c) => c.localId != id).toList());
  }
}

final searchQueryProvider = StateProvider<String>((ref) => '');

final contactDetailProvider = FutureProvider.family<Contact?, int>(
  (ref, id) async {
    final usecase = GetIt.instance<GetContactById>();
    final result = await usecase(id);
    return _resolveResult(result);
  },
);

final dashboardSummaryProvider = FutureProvider<DashboardSummary>((ref) async {
  final contactUC = GetIt.instance<GetAllContacts>();
  final entryUC = GetIt.instance<GetLedgerEntriesByContact>();

  final contactsResult = await contactUC();
  final contacts = _resolveResult(contactsResult);

  final allNets = <int, double>{};
  for (final contact in contacts) {
    if (contact.localId == null) continue;
    final entriesResult = await entryUC(contact.localId!);
    final entries = _resolveResult(entriesResult);
    double net = 0;
    for (final e in entries) {
      if (e.type == LedgerEntryType.paid) {
        net += e.amount;
      } else {
        net -= e.amount;
      }
    }
    allNets[contact.localId!] = net;
  }

  double toReceive = 0;
  double toPay = 0;
  for (final net in allNets.values) {
    if (net > 0) {
      toReceive += net;
    } else if (net < 0) {
      toPay += net.abs();
    }
  }

  return DashboardSummary(
    totalReceivable: toReceive,
    totalPayable: toPay,
  );
});

class DashboardSummary {
  final double totalReceivable;
  final double totalPayable;

  const DashboardSummary({
    required this.totalReceivable,
    required this.totalPayable,
  });

  double get netBalance => totalReceivable - totalPayable;
}

T _resolveResult<T>(Result<T> result) {
  return result.fold(
    onSuccess: (data) => data,
    onFailure: (failure) => throw failure,
  );
}

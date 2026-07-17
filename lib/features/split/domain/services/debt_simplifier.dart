class SimplifiedDebt {
  final int payerId;
  final int receiverId;
  final double amount;

  const SimplifiedDebt({
    required this.payerId,
    required this.receiverId,
    required this.amount,
  });
}

class ExpenseBalanceInput {
  final double amount;
  final int paidByMemberId;
  final List<ShareInput> shares;

  const ExpenseBalanceInput({
    required this.amount,
    required this.paidByMemberId,
    required this.shares,
  });
}

class ShareInput {
  final int memberId;
  final double amount;
  const ShareInput({required this.memberId, required this.amount});
}

class SettlementInput {
  final int payerId;
  final int receiverId;
  final double amount;
  const SettlementInput({
    required this.payerId,
    required this.receiverId,
    required this.amount,
  });
}

class DebtSimplifier {
  DebtSimplifier._();

  static Map<int, double> calculateBalances({
    required List<ExpenseBalanceInput> expenses,
    required List<SettlementInput> settlements,
  }) {
    final balances = <int, double>{};

    for (final expense in expenses) {
      balances[expense.paidByMemberId] =
          (balances[expense.paidByMemberId] ?? 0) + expense.amount;
    }

    for (final expense in expenses) {
      for (final share in expense.shares) {
        balances[share.memberId] =
            (balances[share.memberId] ?? 0) - share.amount;
      }
    }

    for (final settlement in settlements) {
      balances[settlement.payerId] =
          (balances[settlement.payerId] ?? 0) + settlement.amount;
      balances[settlement.receiverId] =
          (balances[settlement.receiverId] ?? 0) - settlement.amount;
    }

    for (final key in balances.keys.toList()) {
      balances[key] = _roundToTwo(balances[key]!);
    }

    return balances;
  }

  static List<SimplifiedDebt> simplify(Map<int, double> balances) {
    final creditors = <_HeapEntry>[];
    final debtors = <_HeapEntry>[];

    for (final entry in balances.entries) {
      if (entry.value > 0.01) {
        creditors.add(_HeapEntry(entry.key, entry.value));
      } else if (entry.value < -0.01) {
        debtors.add(_HeapEntry(entry.key, -entry.value));
      }
    }

    creditors.sort((a, b) => b.amount.compareTo(a.amount));
    debtors.sort((a, b) => b.amount.compareTo(a.amount));

    final transactions = <SimplifiedDebt>[];

    while (creditors.isNotEmpty && debtors.isNotEmpty) {
      final creditor = creditors.removeAt(0);
      final debtor = debtors.removeAt(0);

      final settleAmount = _roundToTwo(creditor.amount < debtor.amount
          ? creditor.amount
          : debtor.amount);

      if (settleAmount > 0.01) {
        transactions.add(SimplifiedDebt(
          payerId: debtor.id,
          receiverId: creditor.id,
          amount: settleAmount,
        ));
      }

      if (creditor.amount > debtor.amount) {
        creditors.insert(0, _HeapEntry(creditor.id, creditor.amount - debtor.amount));
        creditors.sort((a, b) => b.amount.compareTo(a.amount));
      } else if (debtor.amount > creditor.amount) {
        debtors.insert(0, _HeapEntry(debtor.id, debtor.amount - creditor.amount));
        debtors.sort((a, b) => b.amount.compareTo(a.amount));
      }
    }

    return transactions;
  }

  static double _roundToTwo(double value) {
    return (value * 100).roundToDouble() / 100;
  }
}

class _HeapEntry {
  final int id;
  final double amount;
  _HeapEntry(this.id, this.amount);
}

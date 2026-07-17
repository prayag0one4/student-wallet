class Settlement {
  final int? localId;
  final int groupId;
  final int payerId;
  final int receiverId;
  final double amount;
  final DateTime settlementDate;
  final String? notes;
  final DateTime createdAt;

  const Settlement({
    this.localId,
    required this.groupId,
    required this.payerId,
    required this.receiverId,
    required this.amount,
    required this.settlementDate,
    this.notes,
    required this.createdAt,
  });

  Settlement copyWith({
    int? localId,
    int? groupId,
    int? payerId,
    int? receiverId,
    double? amount,
    DateTime? settlementDate,
    String? notes,
    DateTime? createdAt,
  }) {
    return Settlement(
      localId: localId ?? this.localId,
      groupId: groupId ?? this.groupId,
      payerId: payerId ?? this.payerId,
      receiverId: receiverId ?? this.receiverId,
      amount: amount ?? this.amount,
      settlementDate: settlementDate ?? this.settlementDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum PaymentMethod {
  cash('Cash', 0xe1a2),
  upi('UPI', 0xe3a0),
  creditCard('Credit Card', 0xe870),
  debitCard('Debit Card', 0xe7b1),
  bankTransfer('Bank Transfer', 0xe554),
  other('Other', 0xe5d4);

  final String displayName;
  final int iconCodePoint;

  const PaymentMethod(this.displayName, this.iconCodePoint);

  String get serverValue => name;
}

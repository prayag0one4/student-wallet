import 'package:isar/isar.dart';

part 'settlement_model.g.dart';

@collection
class SettlementModel {
  Id id = Isar.autoIncrement;

  @Index()
  late int groupId;

  @Index()
  late int payerId;

  @Index()
  late int receiverId;

  late double amount;

  @Index()
  late DateTime settlementDate;

  String? notes;

  late DateTime createdAt;
}

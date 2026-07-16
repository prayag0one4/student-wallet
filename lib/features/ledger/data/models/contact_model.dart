import 'package:isar/isar.dart';
import '../../../../core/database/sync_status.dart';

part 'contact_model.g.dart';

@collection
class ContactModel {
  Id id = Isar.autoIncrement;

  @Index()
  String? cloudId;

  @Index()
  late String name;

  String? phone;

  String? notes;

  late int avatarColor;

  late DateTime createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.localOnly;

  int version = 1;
}

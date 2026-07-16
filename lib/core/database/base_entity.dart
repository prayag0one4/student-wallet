import 'package:isar/isar.dart';
import 'sync_status.dart';

class BaseEntityFields {
  static const id = 'id';
  static const cloudId = 'cloudId';
  static const createdAt = 'createdAt';
  static const updatedAt = 'updatedAt';
  static const deletedAt = 'deletedAt';
  static const syncStatus = 'syncStatus';
  static const version = 'version';
}

mixin BaseEntityMixin {
  Id id = Isar.autoIncrement;

  @Index()
  String? cloudId;

  late DateTime createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.localOnly;

  int version = 1;
}

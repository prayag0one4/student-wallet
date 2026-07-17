import 'package:isar/isar.dart';
import '../../../../core/database/sync_status.dart';

part 'group_model.g.dart';

@collection
class GroupModel {
  Id id = Isar.autoIncrement;

  @Index()
  String? cloudId;

  @Index()
  late String name;

  late String icon;

  late int color;

  String? description;

  late DateTime createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.localOnly;

  int version = 1;
}

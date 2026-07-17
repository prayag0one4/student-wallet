import 'package:isar/isar.dart';
import '../../../../core/database/sync_status.dart';

part 'group_member_model.g.dart';

@collection
class GroupMemberModel {
  Id id = Isar.autoIncrement;

  @Index()
  String? cloudId;

  @Index()
  late int groupId;

  @Index()
  late String name;

  String? phone;

  late int avatarColor;

  String? notes;

  late DateTime createdAt;
  DateTime? updatedAt;

  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.localOnly;

  int version = 1;
}

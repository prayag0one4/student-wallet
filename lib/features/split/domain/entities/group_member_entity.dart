import '../../../../core/database/sync_status.dart';

class GroupMember {
  final int? localId;
  final String? cloudId;
  final int groupId;
  final String name;
  final String? phone;
  final int avatarColor;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final SyncStatus syncStatus;
  final int version;

  const GroupMember({
    this.localId,
    this.cloudId,
    required this.groupId,
    required this.name,
    this.phone,
    required this.avatarColor,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    this.syncStatus = SyncStatus.localOnly,
    this.version = 1,
  });

  GroupMember copyWith({
    int? localId,
    String? cloudId,
    int? groupId,
    String? name,
    String? phone,
    int? avatarColor,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    int? version,
  }) {
    return GroupMember(
      localId: localId ?? this.localId,
      cloudId: cloudId ?? this.cloudId,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarColor: avatarColor ?? this.avatarColor,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
    );
  }
}

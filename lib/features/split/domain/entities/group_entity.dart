import '../../../../core/database/sync_status.dart';

class Group {
  final int? localId;
  final String? cloudId;
  final String name;
  final String icon;
  final int color;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final SyncStatus syncStatus;
  final int version;

  const Group({
    this.localId,
    this.cloudId,
    required this.name,
    required this.icon,
    required this.color,
    this.description,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.syncStatus = SyncStatus.localOnly,
    this.version = 1,
  });

  Group copyWith({
    int? localId,
    String? cloudId,
    String? name,
    String? icon,
    int? color,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    SyncStatus? syncStatus,
    int? version,
  }) {
    return Group(
      localId: localId ?? this.localId,
      cloudId: cloudId ?? this.cloudId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
    );
  }
}

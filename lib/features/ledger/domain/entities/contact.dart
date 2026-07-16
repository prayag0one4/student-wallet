import '../../../../core/database/sync_status.dart';

class Contact {
  final int? localId;
  final String? cloudId;
  final String name;
  final String? phone;
  final String? notes;
  final int avatarColor;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final SyncStatus syncStatus;
  final int version;

  const Contact({
    this.localId,
    this.cloudId,
    required this.name,
    this.phone,
    this.notes,
    required this.avatarColor,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.syncStatus = SyncStatus.localOnly,
    this.version = 1,
  });

  Contact copyWith({
    int? localId,
    String? cloudId,
    String? name,
    String? phone,
    String? notes,
    int? avatarColor,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    SyncStatus? syncStatus,
    int? version,
  }) {
    return Contact(
      localId: localId ?? this.localId,
      cloudId: cloudId ?? this.cloudId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
      avatarColor: avatarColor ?? this.avatarColor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
    );
  }
}

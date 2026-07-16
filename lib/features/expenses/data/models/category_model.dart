import 'package:isar/isar.dart';
import '../../../../core/database/sync_status.dart';

part 'category_model.g.dart';

@collection
class CategoryModel {
  Id id = Isar.autoIncrement;

  @Index()
  String? cloudId;

  @Index()
  late String name;

  late String icon;

  late int color;

  bool isDefault = false;

  late DateTime createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.localOnly;

  int version = 1;
}

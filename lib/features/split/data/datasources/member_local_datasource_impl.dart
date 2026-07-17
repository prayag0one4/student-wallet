import 'package:isar/isar.dart';
import '../../../../core/database/database_service.dart';
import '../../../../core/database/entity_mapper.dart';
import '../../../../core/database/sync_status.dart';
import '../../domain/entities/group_member_entity.dart';
import '../models/group_member_model.dart';
import 'member_local_datasource.dart';

class MemberLocalDataSourceImpl implements MemberLocalDataSource {
  final DatabaseService _databaseService;
  final GroupMemberMapper _mapper;

  MemberLocalDataSourceImpl(this._databaseService, this._mapper);

  Isar get _isar => _databaseService.instance;

  @override
  Future<List<GroupMember>> getByGroup(int groupId) async {
    final models = await _isar.groupMemberModels
        .where()
        .filter()
        .groupIdEqualTo(groupId)
        .sortByName()
        .findAll();
    return models.map(_mapper.toEntity).toList();
  }

  @override
  Future<GroupMember?> getById(int id) async {
    final model = await _isar.groupMemberModels.get(id);
    if (model == null) return null;
    return _mapper.toEntity(model);
  }

  @override
  Future<int> create(GroupMember member) async {
    final model = _mapper.toModel(member);
    await _isar.writeTxn(() async {
      model.createdAt = DateTime.now();
      model.syncStatus = SyncStatus.localOnly;
      model.version = 1;
      await _isar.groupMemberModels.put(model);
    });
    return model.id;
  }

  @override
  Future<void> update(GroupMember member) async {
    if (member.localId == null) return;
    await _isar.writeTxn(() async {
      final existing = await _isar.groupMemberModels.get(member.localId!);
      if (existing == null) return;
      existing.name = member.name;
      existing.phone = member.phone;
      existing.avatarColor = member.avatarColor;
      existing.notes = member.notes;
      existing.updatedAt = DateTime.now();
      existing.version += 1;
      await _isar.groupMemberModels.put(existing);
    });
  }

  @override
  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      final model = await _isar.groupMemberModels.get(id);
      if (model != null) {
        await _isar.groupMemberModels.delete(id);
      }
    });
  }

  @override
  Future<int> getCount(int groupId) async {
    final count = await _isar.groupMemberModels
        .where()
        .filter()
        .groupIdEqualTo(groupId)
        .count();
    return count;
  }
}

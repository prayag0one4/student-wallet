import '../../domain/entities/group_member_entity.dart';

abstract class MemberLocalDataSource {
  Future<List<GroupMember>> getByGroup(int groupId);
  Future<GroupMember?> getById(int id);
  Future<int> create(GroupMember member);
  Future<void> update(GroupMember member);
  Future<void> delete(int id);
  Future<int> getCount(int groupId);
}

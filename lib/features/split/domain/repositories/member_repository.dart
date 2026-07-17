import '../../../../core/errors/result.dart';
import '../entities/group_member_entity.dart';

abstract class MemberRepository {
  Future<Result<List<GroupMember>>> getMembersByGroup(int groupId);
  Future<Result<GroupMember?>> getMemberById(int id);
  Future<Result<GroupMember>> createMember(GroupMember member);
  Future<Result<GroupMember>> updateMember(GroupMember member);
  Future<Result<void>> deleteMember(int id);
  Future<Result<int>> getMemberCount(int groupId);
}

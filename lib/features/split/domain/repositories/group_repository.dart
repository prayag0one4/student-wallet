import '../../../../core/errors/result.dart';
import '../entities/group_entity.dart';

abstract class GroupRepository {
  Future<Result<List<Group>>> getAllGroups({int? offset, int? limit});
  Future<Result<Group?>> getGroupById(int id);
  Future<Result<Group>> createGroup(Group group);
  Future<Result<Group>> updateGroup(Group group);
  Future<Result<void>> deleteGroup(int id);
  Future<Result<List<Group>>> searchGroups(String query);
}

import '../../domain/entities/group_entity.dart';

abstract class GroupLocalDataSource {
  Future<List<Group>> getAll({int? offset, int? limit});
  Future<Group?> getById(int id);
  Future<int> create(Group group);
  Future<void> update(Group group);
  Future<void> delete(int id);
  Future<List<Group>> search(String query);
}

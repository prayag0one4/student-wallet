import '../../../../core/errors/result.dart';
import '../entities/group_entity.dart';
import '../repositories/group_repository.dart';

class CreateGroup {
  final GroupRepository _repository;
  CreateGroup(this._repository);
  Future<Result<Group>> call(Group group) => _repository.createGroup(group);
}

class UpdateGroup {
  final GroupRepository _repository;
  UpdateGroup(this._repository);
  Future<Result<Group>> call(Group group) => _repository.updateGroup(group);
}

class DeleteGroup {
  final GroupRepository _repository;
  DeleteGroup(this._repository);
  Future<Result<void>> call(int id) => _repository.deleteGroup(id);
}

class GetGroupById {
  final GroupRepository _repository;
  GetGroupById(this._repository);
  Future<Result<Group?>> call(int id) => _repository.getGroupById(id);
}

class GetAllGroups {
  final GroupRepository _repository;
  GetAllGroups(this._repository);
  Future<Result<List<Group>>> call({int? offset, int? limit}) =>
      _repository.getAllGroups(offset: offset, limit: limit);
}

class SearchGroups {
  final GroupRepository _repository;
  SearchGroups(this._repository);
  Future<Result<List<Group>>> call(String query) => _repository.searchGroups(query);
}

import '../../../../core/errors/result.dart';
import '../entities/group_member_entity.dart';
import '../repositories/member_repository.dart';

class CreateMember {
  final MemberRepository _repository;
  CreateMember(this._repository);
  Future<Result<GroupMember>> call(GroupMember member) => _repository.createMember(member);
}

class UpdateMember {
  final MemberRepository _repository;
  UpdateMember(this._repository);
  Future<Result<GroupMember>> call(GroupMember member) => _repository.updateMember(member);
}

class DeleteMember {
  final MemberRepository _repository;
  DeleteMember(this._repository);
  Future<Result<void>> call(int id) => _repository.deleteMember(id);
}

class GetMemberById {
  final MemberRepository _repository;
  GetMemberById(this._repository);
  Future<Result<GroupMember?>> call(int id) => _repository.getMemberById(id);
}

class GetMembersByGroup {
  final MemberRepository _repository;
  GetMembersByGroup(this._repository);
  Future<Result<List<GroupMember>>> call(int groupId) => _repository.getMembersByGroup(groupId);
}

class GetMemberCount {
  final MemberRepository _repository;
  GetMemberCount(this._repository);
  Future<Result<int>> call(int groupId) => _repository.getMemberCount(groupId);
}

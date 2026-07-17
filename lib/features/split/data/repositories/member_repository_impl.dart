import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/group_member_entity.dart';
import '../../domain/repositories/member_repository.dart';
import '../datasources/member_local_datasource.dart';

class MemberRepositoryImpl implements MemberRepository {
  final MemberLocalDataSource _localDataSource;
  final _logger = const AppLogger('MemberRepo');

  MemberRepositoryImpl(this._localDataSource);

  @override
  Future<Result<List<GroupMember>>> getMembersByGroup(int groupId) async {
    try {
      final members = await _localDataSource.getByGroup(groupId);
      return Result.success(members);
    } catch (e) {
      _logger.error('Failed to get members by group: $groupId', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to load members'));
    }
  }

  @override
  Future<Result<GroupMember>> createMember(GroupMember member) async {
    try {
      final id = await _localDataSource.create(member);
      return Result.success(member.copyWith(localId: id));
    } catch (e) {
      _logger.error('Failed to create member', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to create member'));
    }
  }

  @override
  Future<Result<GroupMember>> updateMember(GroupMember member) async {
    try {
      await _localDataSource.update(member);
      return Result.success(member.copyWith(updatedAt: DateTime.now()));
    } catch (e) {
      _logger.error('Failed to update member', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to update member'));
    }
  }

  @override
  Future<Result<void>> deleteMember(int id) async {
    try {
      await _localDataSource.delete(id);
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to delete member: $id', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to delete member'));
    }
  }

  @override
  Future<Result<GroupMember?>> getMemberById(int id) async {
    try {
      final member = await _localDataSource.getById(id);
      return Result.success(member);
    } catch (e) {
      _logger.error('Failed to get member by id: $id', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to load member'));
    }
  }

  @override
  Future<Result<int>> getMemberCount(int groupId) async {
    try {
      final count = await _localDataSource.getCount(groupId);
      return Result.success(count);
    } catch (e) {
      _logger.error('Failed to get member count: $groupId', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to get member count'));
    }
  }
}

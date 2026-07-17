import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/repositories/group_repository.dart';
import '../datasources/group_local_datasource.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupLocalDataSource _localDataSource;
  final _logger = const AppLogger('GroupRepo');

  GroupRepositoryImpl(this._localDataSource);

  @override
  Future<Result<List<Group>>> getAllGroups({int? offset, int? limit}) async {
    try {
      final groups = await _localDataSource.getAll(offset: offset, limit: limit);
      return Result.success(groups);
    } catch (e) {
      _logger.error('Failed to get all groups', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to load groups'));
    }
  }

  @override
  Future<Result<Group>> createGroup(Group group) async {
    try {
      final id = await _localDataSource.create(group);
      return Result.success(group.copyWith(localId: id));
    } catch (e) {
      _logger.error('Failed to create group', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to create group'));
    }
  }

  @override
  Future<Result<Group>> updateGroup(Group group) async {
    try {
      await _localDataSource.update(group);
      return Result.success(group.copyWith(updatedAt: DateTime.now()));
    } catch (e) {
      _logger.error('Failed to update group', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to update group'));
    }
  }

  @override
  Future<Result<void>> deleteGroup(int id) async {
    try {
      await _localDataSource.delete(id);
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to delete group: $id', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to delete group'));
    }
  }

  @override
  Future<Result<Group?>> getGroupById(int id) async {
    try {
      final group = await _localDataSource.getById(id);
      return Result.success(group);
    } catch (e) {
      _logger.error('Failed to get group by id: $id', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to load group'));
    }
  }

  @override
  Future<Result<List<Group>>> searchGroups(String query) async {
    try {
      final groups = await _localDataSource.search(query);
      return Result.success(groups);
    } catch (e) {
      _logger.error('Failed to search groups', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to search groups'));
    }
  }
}

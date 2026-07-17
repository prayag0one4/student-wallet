import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/settlement_entity.dart';
import '../../domain/repositories/settlement_repository.dart';
import '../datasources/settlement_local_datasource.dart';

class SettlementRepositoryImpl implements SettlementRepository {
  final SettlementLocalDataSource _localDataSource;
  final _logger = const AppLogger('SettlementRepo');

  SettlementRepositoryImpl(this._localDataSource);

  @override
  Future<Result<List<Settlement>>> getSettlementsByGroup(int groupId) async {
    try {
      final settlements = await _localDataSource.getByGroup(groupId);
      return Result.success(settlements);
    } catch (e) {
      _logger.error('Failed to get settlements by group: $groupId', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to load settlements'));
    }
  }

  @override
  Future<Result<Settlement>> createSettlement(Settlement settlement) async {
    try {
      final id = await _localDataSource.create(settlement);
      return Result.success(settlement.copyWith(localId: id));
    } catch (e) {
      _logger.error('Failed to create settlement', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to create settlement'));
    }
  }

  @override
  Future<Result<void>> deleteSettlement(int id) async {
    try {
      await _localDataSource.delete(id);
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to delete settlement: $id', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to delete settlement'));
    }
  }

  @override
  Future<Result<Settlement?>> getSettlementById(int id) async {
    try {
      final settlement = await _localDataSource.getById(id);
      return Result.success(settlement);
    } catch (e) {
      _logger.error('Failed to get settlement by id: $id', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to load settlement'));
    }
  }

  @override
  Future<Result<List<Settlement>>> getSettlementsBetween(int groupId, int payerId, int receiverId) async {
    try {
      final settlements = await _localDataSource.getBetween(groupId, payerId, receiverId);
      return Result.success(settlements);
    } catch (e) {
      _logger.error('Failed to get settlements between: $payerId -> $receiverId', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to load settlements'));
    }
  }

  @override
  Future<Result<double>> getTotalSettled(int groupId, int memberId) async {
    try {
      final total = await _localDataSource.getTotalSettled(groupId, memberId);
      return Result.success(total);
    } catch (e) {
      _logger.error('Failed to get total settled: $memberId in $groupId', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to calculate settlements'));
    }
  }
}

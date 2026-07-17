import '../../../../core/errors/result.dart';
import '../entities/settlement_entity.dart';

abstract class SettlementRepository {
  Future<Result<List<Settlement>>> getSettlementsByGroup(int groupId);
  Future<Result<Settlement?>> getSettlementById(int id);
  Future<Result<Settlement>> createSettlement(Settlement settlement);
  Future<Result<void>> deleteSettlement(int id);
  Future<Result<List<Settlement>>> getSettlementsBetween(int groupId, int payerId, int receiverId);
  Future<Result<double>> getTotalSettled(int groupId, int memberId);
}

import '../../domain/entities/settlement_entity.dart';

abstract class SettlementLocalDataSource {
  Future<List<Settlement>> getByGroup(int groupId);
  Future<Settlement?> getById(int id);
  Future<int> create(Settlement settlement);
  Future<void> delete(int id);
  Future<List<Settlement>> getBetween(int groupId, int payerId, int receiverId);
  Future<double> getTotalSettled(int groupId, int memberId);
}

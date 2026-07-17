import '../../../../core/errors/result.dart';
import '../entities/settlement_entity.dart';
import '../repositories/settlement_repository.dart';

class CreateSettlement {
  final SettlementRepository _repository;
  CreateSettlement(this._repository);
  Future<Result<Settlement>> call(Settlement settlement) => _repository.createSettlement(settlement);
}

class DeleteSettlement {
  final SettlementRepository _repository;
  DeleteSettlement(this._repository);
  Future<Result<void>> call(int id) => _repository.deleteSettlement(id);
}

class GetSettlementById {
  final SettlementRepository _repository;
  GetSettlementById(this._repository);
  Future<Result<Settlement?>> call(int id) => _repository.getSettlementById(id);
}

class GetSettlementsByGroup {
  final SettlementRepository _repository;
  GetSettlementsByGroup(this._repository);
  Future<Result<List<Settlement>>> call(int groupId) => _repository.getSettlementsByGroup(groupId);
}

class GetMemberSettledTotal {
  final SettlementRepository _repository;
  GetMemberSettledTotal(this._repository);
  Future<Result<double>> call(int groupId, int memberId) =>
      _repository.getTotalSettled(groupId, memberId);
}

import 'package:isar/isar.dart';
import '../../../../core/database/database_service.dart';
import '../../../../core/database/entity_mapper.dart';
import '../../domain/entities/settlement_entity.dart';
import '../models/settlement_model.dart';
import 'settlement_local_datasource.dart';

class SettlementLocalDataSourceImpl implements SettlementLocalDataSource {
  final DatabaseService _databaseService;
  final SettlementMapper _mapper;

  SettlementLocalDataSourceImpl(this._databaseService, this._mapper);

  Isar get _isar => _databaseService.instance;

  @override
  Future<List<Settlement>> getByGroup(int groupId) async {
    final models = await _isar.settlementModels
        .where()
        .filter()
        .groupIdEqualTo(groupId)
        .sortBySettlementDateDesc()
        .findAll();
    return models.map(_mapper.toEntity).toList();
  }

  @override
  Future<Settlement?> getById(int id) async {
    final model = await _isar.settlementModels.get(id);
    if (model == null) return null;
    return _mapper.toEntity(model);
  }

  @override
  Future<int> create(Settlement settlement) async {
    final model = _mapper.toModel(settlement);
    await _isar.writeTxn(() async {
      model.createdAt = DateTime.now();
      await _isar.settlementModels.put(model);
    });
    return model.id;
  }

  @override
  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      await _isar.settlementModels.delete(id);
    });
  }

  @override
  Future<List<Settlement>> getBetween(int groupId, int payerId, int receiverId) async {
    final models = await _isar.settlementModels
        .where()
        .filter()
        .groupIdEqualTo(groupId)
        .and()
        .payerIdEqualTo(payerId)
        .and()
        .receiverIdEqualTo(receiverId)
        .sortBySettlementDateDesc()
        .findAll();
    return models.map(_mapper.toEntity).toList();
  }

  @override
  Future<double> getTotalSettled(int groupId, int memberId) async {
    final models = await _isar.settlementModels
        .where()
        .filter()
        .groupIdEqualTo(groupId)
        .and()
        .payerIdEqualTo(memberId)
        .findAll();
    double total = 0;
    for (final m in models) {
      total += m.amount;
    }
    return total;
  }
}

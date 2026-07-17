import 'package:isar/isar.dart';
import '../../../../core/database/database_service.dart';
import '../../../../core/database/entity_mapper.dart';
import '../../../../core/database/sync_status.dart';
import '../../domain/entities/group_expense_entity.dart';
import '../../domain/entities/expense_share_entity.dart';
import '../models/group_expense_model.dart';
import '../models/expense_share_model.dart';
import 'group_expense_local_datasource.dart';

class GroupExpenseLocalDataSourceImpl implements GroupExpenseLocalDataSource {
  final DatabaseService _databaseService;
  final GroupExpenseMapper _mapper;
  final ExpenseShareMapper _shareMapper;

  GroupExpenseLocalDataSourceImpl(this._databaseService, this._mapper, this._shareMapper);

  Isar get _isar => _databaseService.instance;

  @override
  Future<List<GroupExpense>> getByGroup(int groupId, {int? offset, int? limit}) async {
    final models = await _isar.groupExpenseModels
        .where()
        .filter()
        .deletedAtIsNull()
        .and()
        .groupIdEqualTo(groupId)
        .sortByExpenseDateDesc()
        .offset(offset ?? 0)
        .limit(limit ?? 100000)
        .findAll();
    return models.map(_mapper.toEntity).toList();
  }

  @override
  Future<GroupExpense?> getById(int id) async {
    final model = await _isar.groupExpenseModels.get(id);
    if (model == null || model.deletedAt != null) return null;
    return _mapper.toEntity(model);
  }

  @override
  Future<int> create(GroupExpense expense, List<ExpenseShare> shares) async {
    final model = _mapper.toModel(expense);
    await _isar.writeTxn(() async {
      model.createdAt = DateTime.now();
      model.syncStatus = SyncStatus.localOnly;
      model.version = 1;
      await _isar.groupExpenseModels.put(model);

      for (final share in shares) {
        final shareModel = _shareMapper.toModel(share.copyWith(expenseId: model.id));
        await _isar.expenseShareModels.put(shareModel);
      }
    });
    return model.id;
  }

  @override
  Future<void> update(GroupExpense expense, List<ExpenseShare> shares) async {
    if (expense.localId == null) return;
    await _isar.writeTxn(() async {
      final existing = await _isar.groupExpenseModels.get(expense.localId!);
      if (existing == null || existing.deletedAt != null) return;
      existing.title = expense.title;
      existing.amount = expense.amount;
      existing.paidByMemberId = expense.paidByMemberId;
      existing.splitType = expense.splitType.name;
      existing.notes = expense.notes;
      existing.expenseDate = expense.expenseDate;
      existing.updatedAt = DateTime.now();
      existing.version += 1;
      await _isar.groupExpenseModels.put(existing);

      final oldShares = await _isar.expenseShareModels
          .where()
          .filter()
          .expenseIdEqualTo(existing.id)
          .findAll();
      await _isar.expenseShareModels.deleteAll(oldShares.map((s) => s.id).toList());

      for (final share in shares) {
        final shareModel = _shareMapper.toModel(share.copyWith(expenseId: existing.id));
        await _isar.expenseShareModels.put(shareModel);
      }
    });
  }

  @override
  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      final model = await _isar.groupExpenseModels.get(id);
      if (model != null) {
        model.deletedAt = DateTime.now();
        model.syncStatus = SyncStatus.deleted;
        await _isar.groupExpenseModels.put(model);
      }
    });
  }

  @override
  Future<double> getTotalByGroup(int groupId) async {
    final models = await _isar.groupExpenseModels
        .where()
        .filter()
        .deletedAtIsNull()
        .and()
        .groupIdEqualTo(groupId)
        .findAll();
    double total = 0;
    for (final m in models) {
      total += m.amount;
    }
    return total;
  }

  @override
  Future<List<ExpenseShare>> getSharesByExpense(int expenseId) async {
    final models = await _isar.expenseShareModels
        .where()
        .filter()
        .expenseIdEqualTo(expenseId)
        .findAll();
    return models.map(_shareMapper.toEntity).toList();
  }

  @override
  Future<List<ExpenseShare>> getSharesByMember(int memberId) async {
    final models = await _isar.expenseShareModels
        .where()
        .filter()
        .memberIdEqualTo(memberId)
        .findAll();
    return models.map(_shareMapper.toEntity).toList();
  }

  @override
  Future<void> updateShareSettlement(int shareId, double amount) async {
    await _isar.writeTxn(() async {
      final model = await _isar.expenseShareModels.get(shareId);
      if (model != null) {
        model.settledAmount += amount;
        await _isar.expenseShareModels.put(model);
      }
    });
  }
}

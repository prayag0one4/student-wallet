import 'package:isar/isar.dart';
import '../../../../core/database/database_service.dart';
import '../../../../core/database/entity_mapper.dart';
import '../../../../core/database/sync_status.dart';
import '../../../../core/constants/payment_method.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/expense.dart';
import '../models/expense_model.dart';
import 'expense_local_datasource.dart';

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final DatabaseService _databaseService;
  final ExpenseMapper _mapper;
  final _logger = const AppLogger('ExpenseDS');

  ExpenseLocalDataSourceImpl(this._databaseService, this._mapper);

  Isar get _isar => _databaseService.instance;

  @override
  Future<List<Expense>> getAll({int? offset, int? limit}) async {
    final models = await _isar.expenseModels
        .where()
        .filter()
        .deletedAtIsNull()
        .sortByExpenseDateDesc()
        .offset(offset ?? 0)
        .limit(limit ?? 100000)
        .findAll();
    return models.map(_mapper.toEntity).toList();
  }

  @override
  Future<Expense?> getById(int id) async {
    final model = await _isar.expenseModels.get(id);
    if (model == null || model.deletedAt != null) return null;
    return _mapper.toEntity(model);
  }

  @override
  Future<int> create(Expense expense) async {
    final model = _mapper.toModel(expense);
    await _isar.writeTxn(() async {
      model.createdAt = DateTime.now();
      model.syncStatus = SyncStatus.localOnly;
      model.version = 1;
      await _isar.expenseModels.put(model);
    });
    return model.id;
  }

  @override
  Future<void> update(Expense expense) async {
    if (expense.localId == null) return;

    await _isar.writeTxn(() async {
      final existing = await _isar.expenseModels.get(expense.localId!);
      if (existing == null || existing.deletedAt != null) return;

      existing.amount = expense.amount;
      existing.categoryId = expense.categoryId;
      existing.description = expense.description;
      existing.paymentMethod = expense.paymentMethod.name;
      existing.expenseDate = expense.expenseDate;
      existing.merchantName = expense.merchantName;
      existing.notes = expense.notes;
      existing.tags = expense.tags;
      existing.updatedAt = DateTime.now();
      existing.version += 1;
      await _isar.expenseModels.put(existing);
    });
  }

  @override
  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      final model = await _isar.expenseModels.get(id);
      if (model != null) {
        model.deletedAt = DateTime.now();
        model.syncStatus = SyncStatus.deleted;
        await _isar.expenseModels.put(model);
      }
    });
  }

  @override
  Future<List<Expense>> search(String query) async {
    if (query.isEmpty) return getAll();
    final models = await _isar.expenseModels
        .where()
        .filter()
        .deletedAtIsNull()
        .and()
        .group((q) => q
            .descriptionContains(query, caseSensitive: false)
            .or()
            .merchantNameContains(query, caseSensitive: false)
            .or()
            .notesContains(query, caseSensitive: false))
        .sortByExpenseDateDesc()
        .findAll();
    return models.map(_mapper.toEntity).toList();
  }

  @override
  Future<List<Expense>> getByCategory(int categoryId) async {
    final models = await _isar.expenseModels
        .where()
        .filter()
        .deletedAtIsNull()
        .and()
        .categoryIdEqualTo(categoryId)
        .sortByExpenseDateDesc()
        .findAll();
    return models.map(_mapper.toEntity).toList();
  }

  @override
  Future<List<Expense>> getByDateRange(DateTime start, DateTime end) async {
    final models = await _isar.expenseModels
        .where()
        .filter()
        .deletedAtIsNull()
        .and()
        .expenseDateBetween(start, end)
        .sortByExpenseDateDesc()
        .findAll();
    return models.map(_mapper.toEntity).toList();
  }

  @override
  Future<List<Expense>> getFiltered({
    int? categoryId,
    PaymentMethod? paymentMethod,
    DateTime? startDate,
    DateTime? endDate,
    String? sortBy,
    bool descending = true,
    int? offset,
    int? limit,
  }) async {
    final query = _isar.expenseModels.where();
    query.anyCategoryId();
    query.anyExpenseDate();

    var filter = query.filter().deletedAtIsNull();

    if (categoryId != null) {
      filter = filter.and().categoryIdEqualTo(categoryId);
    }
    if (paymentMethod != null) {
      filter = filter.and().paymentMethodEqualTo(paymentMethod.name);
    }
    if (startDate != null && endDate != null) {
      filter = filter.and().expenseDateBetween(startDate, endDate);
    } else if (startDate != null) {
      filter = filter.and().expenseDateGreaterThan(startDate);
    } else if (endDate != null) {
      filter = filter.and().expenseDateLessThan(endDate);
    }

    var models = await filter
        .sortByExpenseDateDesc()
        .offset(offset ?? 0)
        .limit(limit ?? 100000)
        .findAll();

    // Sort in memory for amount-based ordering
    if (sortBy == 'amount') {
      models.sort((a, b) => descending
          ? b.amount.compareTo(a.amount)
          : a.amount.compareTo(b.amount));
    } else if (sortBy == 'expenseDate' && !descending) {
      models = models.reversed.toList();
    }

    return models.map(_mapper.toEntity).toList();
  }

  @override
  Future<int> getCount() async {
    return _isar.expenseModels
        .where()
        .filter()
        .deletedAtIsNull()
        .count();
  }

  @override
  Future<List<Expense>> getRecent({int count = 5}) async {
    final models = await _isar.expenseModels
        .where()
        .filter()
        .deletedAtIsNull()
        .sortByExpenseDateDesc()
        .limit(count)
        .findAll();
    return models.map(_mapper.toEntity).toList();
  }
}

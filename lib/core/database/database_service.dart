import 'dart:io';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../../features/expenses/data/models/expense_model.dart';
import '../../features/expenses/data/models/category_model.dart';
import '../../features/ledger/data/models/contact_model.dart';
import '../../features/ledger/data/models/ledger_entry_model.dart';
import '../../features/split/data/models/group_model.dart';
import '../../features/split/data/models/group_member_model.dart';
import '../../features/split/data/models/group_expense_model.dart';
import '../../features/split/data/models/expense_share_model.dart';
import '../../features/split/data/models/settlement_model.dart';
import '../logging/app_logger.dart';

class DatabaseService {
  late final Isar _isar;
  bool _isInitialized = false;
  final _logger = const AppLogger('DatabaseService');

  static const _dbVersionKey = 'db_version';
  static const int _currentVersion = 6;

  Isar get instance {
    if (!_isInitialized) {
      throw StateError('DatabaseService not initialized. Call init() first.');
    }
    return _isar;
  }

  Future<void> init() async {
    if (_isInitialized) return;

    final dir = await getApplicationDocumentsDirectory();
    final prefs = await SharedPreferences.getInstance();
    final savedVersion = prefs.getInt(_dbVersionKey) ?? 1;

    if (savedVersion < _currentVersion) {
      await _migrate(dir, savedVersion);
      await prefs.setInt(_dbVersionKey, _currentVersion);
    }

    _isar = await Isar.open(
      [ExpenseModelSchema, CategoryModelSchema, ContactModelSchema, LedgerEntryModelSchema,
       GroupModelSchema, GroupMemberModelSchema, GroupExpenseModelSchema, ExpenseShareModelSchema, SettlementModelSchema],
      directory: dir.path,
      name: AppConstants.databaseName,
      maxSizeMiB: 256,
      inspector: true,
    );
    _isInitialized = true;
  }

  Future<void> _migrate(Directory dir, int oldVersion) async {
    _logger.info('Migrating database from v$oldVersion to v$_currentVersion');

    final dbPath = '${dir.path}${Platform.pathSeparator}${AppConstants.databaseName}';
    final dbDir = Directory(dbPath);

    if (await dbDir.exists()) {
      try {
        await dbDir.delete(recursive: true);
        _logger.info('Old database deleted for migration');
      } catch (e) {
        _logger.error('Failed to delete old database during migration', e);
      }
    }
  }

  Future<void> close() async {
    if (_isInitialized) {
      await _isar.close();
      _isInitialized = false;
    }
  }
}

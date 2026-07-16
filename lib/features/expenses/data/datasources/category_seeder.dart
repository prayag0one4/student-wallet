import 'package:isar/isar.dart';
import '../../../../core/database/database_service.dart';
import '../../../../core/database/sync_status.dart';
import '../../../../core/logging/app_logger.dart';
import '../models/category_model.dart';

class CategorySeeder {
  final DatabaseService _databaseService;
  final _logger = const AppLogger('CategorySeeder');

  CategorySeeder(this._databaseService);

  Future<void> seedIfNeeded() async {
    final isar = _databaseService.instance;

    try {
      final allDefaults = await isar.categoryModels
          .where()
          .filter()
          .isDefaultEqualTo(true)
          .findAll();

      final needsReseed = allDefaults.any((c) {
        try {
          int.parse(c.icon, radix: 16);
          return false;
        } catch (_) {
          return true;
        }
      });

      if (!needsReseed && allDefaults.isNotEmpty) {
        _logger.info('Categories already seeded (${allDefaults.length} valid)');
        return;
      }

      if (needsReseed) {
        _logger.info('Detected corrupted icon data, re-seeding...');
        await isar.writeTxn(() async {
          for (final cat in allDefaults) {
            await isar.categoryModels.delete(cat.id);
          }
        });
      }
    } catch (_) {
      // Seeding for first time
    }

    _logger.info('Seeding default categories...');
    final now = DateTime.now();

    final categories = [
      _category('Food', 'e57a', 0xFFE57373, now),
      _category('Transport', 'e530', 0xFF64B5F6, now),
      _category('Shopping', 'e54c', 0xFFFFB74D, now),
      _category('Hostel', 'e8a0', 0xFF9575CD, now),
      _category('Rent', 'e8b1', 0xFF4DB6AC, now),
      _category('Education', 'e80c', 0xFF7986CB, now),
      _category('Entertainment', 'e638', 0xFFFF8A65, now),
      _category('Subscription', 'e63a', 0xFF4DD0E1, now),
      _category('Medical', 'e004', 0xFFE53935, now),
      _category('Utilities', 'e23f', 0xFFA1887F, now),
      _category('Miscellaneous', 'e52e', 0xFF90A4AE, now),
    ];

    await isar.writeTxn(() async {
      await isar.categoryModels.putAll(categories);
    });

    _logger.info('Seeded ${categories.length} default categories');
  }

  CategoryModel _category(String name, String icon, int color, DateTime now) {
    return CategoryModel()
      ..name = name
      ..icon = icon
      ..color = color
      ..isDefault = true
      ..createdAt = now
      ..syncStatus = SyncStatus.localOnly
      ..version = 1;
  }
}

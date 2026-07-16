import 'notification_service.dart';
import '../../core/logging/app_logger.dart';

abstract class NotificationScheduler {
  Future<void> scheduleDailyReminder({required int hour, required int minute});
  Future<void> scheduleOverspendingWarning(double dailyThreshold);
  Future<void> scheduleBudgetAlert(double budget, double spent);
  Future<void> cancelScheduled();
}

class LocalNotificationScheduler implements NotificationScheduler {
  final NotificationService _notificationService;
  final _logger = const AppLogger('NotificationScheduler');

  LocalNotificationScheduler(this._notificationService);

  @override
  Future<void> scheduleDailyReminder({required int hour, required int minute}) async {
    _logger.info('Daily reminder scheduling deferred');
  }

  @override
  Future<void> scheduleOverspendingWarning(double dailyThreshold) async {
    _logger.info('Overspending warning scheduling deferred');
  }

  @override
  Future<void> scheduleBudgetAlert(double budget, double spent) async {
    _logger.info('Budget alert scheduling deferred');
  }

  @override
  Future<void> cancelScheduled() async {
    await _notificationService.cancelAll();
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;

const String subuhReminderPayload = 'subuh_reminder';
const String subuhLastChancePayload = 'subuh_last_chance';

final ValueNotifier<bool> pendingRandomAnonDonationNotifier =
    ValueNotifier(false);

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kuala_Lumpur'));

    const androidSettings = AndroidInitializationSettings('notification_icon');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onTap,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundTap,
    );

    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp == true &&
        launchDetails?.notificationResponse != null) {
      _handleTap(launchDetails!.notificationResponse!);
    }

    await _scheduleDailyReminder();
    await _scheduleLastChanceWindow();
  }

  Future<void> _scheduleDailyReminder({int hour = 6, int minute = 0}) async {
    final scheduledFor = _nextInstanceOf(hour, minute);
    await _plugin.zonedSchedule(
      id: 0,
      title: 'Peluang Sedekah Subuh',
      body: 'Tunaikan segera sehingga 7:30 pagi',
      scheduledDate: scheduledFor,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel_id',
          'Daily Notifications',
          channelDescription: 'Daily reminder channel',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: subuhReminderPayload,
    );
  }

  static const int _lastChanceDaysAhead = 14;

  /// Call on app resume to keep the rolling 7:30 window topped up.
  Future<void> refreshLastChanceWindow() => _scheduleLastChanceWindow();

  int _epochDay(tz.TZDateTime date) =>
      tz.TZDateTime(tz.local, date.year, date.month, date.day)
          .millisecondsSinceEpoch ~/
      (Duration.millisecondsPerDay);

  int _lastChanceIdFor(tz.TZDateTime date) => 30000 + _epochDay(date);

  static int? _cancelledLastChanceEpochDay;

  Future<void> _scheduleLastChanceWindow({int hour = 7, int minute = 0}) async {
    final now = tz.TZDateTime.now(tz.local);

    for (int dayOffset = 0; dayOffset < _lastChanceDaysAhead; dayOffset++) {
      final scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day + dayOffset,
        hour,
        minute,
      );
      if (scheduled.isBefore(now)) {
        continue;
      }

      final epochDay = _epochDay(scheduled);
      if (epochDay == _cancelledLastChanceEpochDay) {
        continue;
      }

      final id = _lastChanceIdFor(scheduled);
      await _plugin.zonedSchedule(
        id: id,
        title: 'Peluang Terakhir!!!',
        body: 'Tunaikan sebelum ditutup 7:30 pagi',
        scheduledDate: scheduled,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_channel_id',
            'Daily Notifications',
            channelDescription: 'Daily reminder channel',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: subuhLastChancePayload,
      );
    }
  }

  Future<void> cancelReminder() async {
    await _plugin.cancel(id: 0);
    final now = tz.TZDateTime.now(tz.local);
    for (int dayOffset = 0; dayOffset < _lastChanceDaysAhead; dayOffset++) {
      final date =
          tz.TZDateTime(tz.local, now.year, now.month, now.day + dayOffset);
      await _plugin.cancel(id: _lastChanceIdFor(date));
    }
  }

  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static void _onTap(NotificationResponse response) {
    _handleTap(response);
  }

  @pragma('vm:entry-point')
  static void _onBackgroundTap(NotificationResponse response) {
    _handleTap(response);
  }

  static void _handleTap(NotificationResponse response) {
    if (response.payload == subuhReminderPayload) {
      final today = tz.TZDateTime.now(tz.local);
      final todayEpochDay =
          tz.TZDateTime(tz.local, today.year, today.month, today.day)
                  .millisecondsSinceEpoch ~/
              Duration.millisecondsPerDay;
      final todayId = 30000 + todayEpochDay;
      FlutterLocalNotificationsPlugin().cancel(id: todayId);
      _cancelledLastChanceEpochDay = todayEpochDay;
    } else if (response.payload == subuhLastChancePayload) {
      pendingRandomAnonDonationNotifier.value = true;
    }
  }
}

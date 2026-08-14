import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class AlarmService {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  static const int yesterdayAlarmId = 1001;
  static const String channelId = 'yesterday_history_alarm';

  final StreamController<String> _onNotificationTapController =
      StreamController<String>.broadcast();
  Stream<String> get onNotificationTap => _onNotificationTapController.stream;

  Future<void> initialize() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          final payload = response.payload;
          if (payload != null && payload.isNotEmpty) {
            _onNotificationTapController.add(payload);
          }
        },
      );

      // Create Android Notification Channel
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        const channel = AndroidNotificationChannel(
          channelId,
          'Yesterday History Rule Alarm',
          description:
              'Hourly alarm ringing when yesterday history is less than 100 words',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        );
        await androidImplementation.createNotificationChannel(channel);
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('Failed to initialize local notifications: $e');
    }
  }

  /// Request permissions on Android 13+ & iOS
  Future<bool> requestPermissions() async {
    if (!_isInitialized) await initialize();

    // iOS permissions
    final iosImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (iosImplementation != null) {
      await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // Android permissions
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }

    return true;
  }

  /// Schedule hourly reminder alarm for yesterday's unfulfilled entry
  Future<void> scheduleYesterdayHourlyAlarm({
    required String yesterdayDateKey,
    required int remainingWords,
  }) async {
    if (!_isInitialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      channelId,
      'Yesterday History Rule Alarm',
      channelDescription:
          'Hourly alarm ringing when yesterday history is less than 100 words',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notificationsPlugin.periodicallyShow(
        yesterdayAlarmId,
        '⚠️ Yesterday History Unfinished',
        'You have not recorded yesterday\'s experience yet ($remainingWords words left). Tap here to write now!',
        RepeatInterval.hourly,
        notificationDetails,
        payload: yesterdayDateKey,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      debugPrint('Scheduled hourly alarm for yesterday entry.');
    } catch (e) {
      debugPrint('Error scheduling hourly alarm: $e');
    }
  }

  /// Cancel the alarm once yesterday's entry reaches 100+ words
  Future<void> cancelYesterdayAlarm() async {
    if (!_isInitialized) await initialize();
    try {
      await _notificationsPlugin.cancel(yesterdayAlarmId);
      debugPrint('Cancelled yesterday history hourly alarm.');
    } catch (e) {
      debugPrint('Error cancelling alarm: $e');
    }
  }

  /// Trigger an immediate test notification for UI testing
  Future<void> triggerTestAlarm({
    required String yesterdayDateKey,
    required String title,
    required String body,
  }) async {
    if (!_isInitialized) await initialize();
    await requestPermissions();

    const androidDetails = AndroidNotificationDetails(
      channelId,
      'Yesterday History Rule Alarm',
      channelDescription: 'Channel for testing alarms',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notificationsPlugin.show(
        999,
        title,
        body,
        details,
        payload: yesterdayDateKey,
      );
    } catch (e) {
      debugPrint('Error triggering test alarm: $e');
    }
  }
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _rideReminderChannel =
      AndroidNotificationChannel(
    'ride_reminders_channel',
    'Ride reminders',
    description: 'Notifications for upcoming shared rides',
    importance: Importance.high,
  );

  static Future<void> init() async {
    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(settings: initializationSettings);

    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(_rideReminderChannel);

    await androidPlugin?.requestNotificationsPermission();
  }

  static Future<void> scheduleRideReminder({
    required int notificationId,
    required DateTime departureTime,
  }) async {
    final reminderTime = departureTime.subtract(const Duration(hours: 2));

    if (reminderTime.isAfter(DateTime.now())) {
      await _scheduleNotification(
        id: notificationId,
        scheduledTime: reminderTime,
      );
    } else {
      await showRideReminderNow(id: notificationId);
    }
  }

  // static Future<void> _scheduleNotification({
  //   required int id,
  //   required DateTime scheduledTime,
  // }) async {
  //   await _plugin.zonedSchedule(
  //     id: id,
  //     title: 'Напомняне за пътуване',
  //     body: 'Пътуването ви започва скоро.',
  //     tz.TZDateTime.from(scheduledTime, tz.local),
  //     const NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'ride_reminders_channel',
  //         'Ride reminders',
  //         channelDescription: 'Notifications for upcoming shared rides',
  //         importance: Importance.high,
  //         priority: Priority.high,
  //         icon: '@mipmap/ic_launcher',
  //       ),
  //     ),
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //   );
  // }

  static Future<void> _scheduleNotification({
    required int id,
    required DateTime scheduledTime,
  }) async {
    await _plugin.zonedSchedule(
      id: id,
      title: 'Напомняне за пътуване',
      body: 'Пътуването ви започва скоро.',
      scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'ride_reminders_channel',
          'Ride reminders',
          channelDescription: 'Notifications for upcoming shared rides',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      // This enum is defined within the flutter_local_notifications package
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> showRideReminderNow({
    required int id,
  }) async {
    await _plugin.show(
      id: id,
      title: 'Напомняне за пътуване',
      body: 'Пътуването ви започва скоро.',
      notificationDetails: const NotificationDetails( // Explicitly named 'notificationDetails'
      android: AndroidNotificationDetails(
        'ride_reminders_channel',
        'Ride reminders',
        channelDescription: 'Notifications for upcoming shared rides',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
    ),
    );
  }

  

  static Future<void> cancelRideReminder({
    required int notificationId,
  }) async {
    await _plugin.cancel(id: notificationId);
  }
}

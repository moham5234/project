import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();


  static Future<void> initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Riyadh'));
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidInit);

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        print('📥 تم استقبال الإشعار: ${response.payload}');
      },
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
      const AndroidNotificationChannel(
        'appointments_channel',
        'Appointment Reminders',
        description: 'Channel for appointment reminder notifications',
        importance: Importance.max,
      ),
    );
  }
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final now = DateTime.now();
    final notificationTime = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    print('🕓 الآن: $now');
    print('📅 موعد الإشعار المجدول: $notificationTime');

    if (notificationTime.isBefore(tz.TZDateTime.now(tz.local))) {
      print('🚫 وقت الإشعار في الماضي. لن يتم جدولة الإشعار.');
      return;
    }

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      notificationTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'appointments_channel',
          'Appointment Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }



  static DateTime? parseAppointmentDateTime(String date, String time) {
    try {
      time = time.replaceAll('ص', 'AM').replaceAll('م', 'PM');
      final combined = '$date $time';
      final format = DateFormat('yyyy-MM-dd h:mm a');
      final parsed = format.parse(combined);
      print('✅ تم تحليل التاريخ والوقت بنجاح: $time ➜ $parsed');
      return parsed;
    } catch (e) {
      print('⚠️ خطأ في تحويل التاريخ والوقت: $e');
      return null;
    }
  }

}

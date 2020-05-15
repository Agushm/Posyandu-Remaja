import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Serves as a way to communicate with the notification system.
class NotificationsProvider with ChangeNotifier {
  final _notifications = FlutterLocalNotificationsPlugin();

  final _notificationDetails = NotificationDetails(
    AndroidNotificationDetails(
      'channel.posyandu',
      'Posyandu Remaja Kuncup Melati Notifications',
      'Posyandu Remaja Kuncup Melati Dusun Jengglong',
      importance: Importance.High,
    ),
    IOSNotificationDetails(),
  );

  NotificationsProvider() {
    init();
  }

  /// Initializes the notifications system
  Future<void> init() async {
    await _notifications.initialize(InitializationSettings(
      AndroidInitializationSettings('notification_launch'),
      IOSInitializationSettings(),
    ));
  }

  /// Cancels all pending notifications
  Future<void> cancelAll() async => _notifications.cancelAll();

  Future<void> setNextLaunchDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'notifications.launches.upcoming',
      date.toIso8601String(),
    );
  }

  /// Checks if it's necceasry to update scheduled notifications
  Future<bool> needsToUpdate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      return prefs.getString('notifications.launches.upcoming') !=
          date.toIso8601String();
    } catch (_) {
      return true;
    }
  }

  /// Schedule new notifications
  Future<void> scheduleNotifications(
    BuildContext context, {
    String title,
    DateTime date,
    List notifications,
  }) async {
    for (final notification in notifications) {
      await _notifications.schedule(
        notifications.indexOf(notification),
        title,
        notification['subtitle'],
        date.subtract(notification['subtract']),
        _notificationDetails,
        androidAllowWhileIdle: true,
      );
    }
  }

  Future<void> schedule5detik() async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration());
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Posyandu Kuncup Melati id',
        'Posyandu Kuncup Melati',
        'Posyandu Kuncup Melati Sechedule Workout',
        icon: '@mipmap/ic_launcher',
        // sound: RawResourceAndroidNotificationSound('slow_spring_board'),
        // largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        vibrationPattern: vibrationPattern,
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500);
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(sound: 'slow_spring_board.aiff');
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await _notifications.schedule(
        0,
        'Remainder Aktifitas Workout',
        'Apakah sudah bakar kalori hari ini?',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }
}

import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';

typedef SelectNotificationCallback = Future<dynamic> Function(String payload);

class NotificationHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  registerLocalNotification(){
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  showNotification(String title, String body,
      {String payload,
      @required SelectNotificationCallback onSelectNotification}) async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'posyandu_channel_id', 'posyandu_channel', 'posyandu_channel_description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker',
        visibility: NotificationVisibility.Public);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload);
  }
    
  Future selectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
  
    
}

Future _showNotificationWithSound() async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max,
      priority: Priority.High);
  var iOSPlatformChannelSpecifics =
      new IOSNotificationDetails(sound: "slow_spring_board.aiff");
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'New Post',
    'How to Show Notification in Flutter',
    platformChannelSpecifics,
    payload: 'Custom_Sound',
  );
}

Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
}

  NotificationHelper() {
    this.flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }
}

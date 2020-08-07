import 'package:animations/animations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:posyandu_kuncup_melati/Constants/Dictionary.dart';
import 'package:posyandu_kuncup_melati/Constants/Navigation.dart';
import 'package:posyandu_kuncup_melati/Node_Providers/Auth.dart';
import 'package:posyandu_kuncup_melati/Node_Providers/Notification.dart';
import 'package:posyandu_kuncup_melati/Node_Providers/Pertanyaan.dart';
import 'package:posyandu_kuncup_melati/Providers/Auth.dart';
import 'package:posyandu_kuncup_melati/Providers/Corona.dart';
import 'package:posyandu_kuncup_melati/Providers/DaftarAnggota.dart';
import 'package:posyandu_kuncup_melati/Providers/Messages.dart';
import 'package:posyandu_kuncup_melati/Providers/Notifications.dart';
import 'package:posyandu_kuncup_melati/Providers/PemeriksaanLain.dart';
import 'package:posyandu_kuncup_melati/Providers/PemeriksaanUmum.dart';
import 'package:posyandu_kuncup_melati/Providers/User.dart';
import 'package:posyandu_kuncup_melati/Services/NotificationService.dart';
import 'package:posyandu_kuncup_melati/config/Routes.dart';
import 'package:provider/provider.dart';
import 'Constants/Colors.dart';
import 'Node_Providers/Periksa.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  initState() {
    super.initState();
    registerFCM();
    configLocalNotification();
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void registerFCM() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        if (message['data']['imageUrl'] == null) {
          return NotificationService()
              .showNotification(message, flutterLocalNotificationsPlugin);
        }
        if (message['data']['imageUrl'] != null) {
          return NotificationService()
              .showBigPictureNotificationHideExpandedLargeIcon(
                  message, flutterLocalNotificationsPlugin);
        }
        return NotificationService()
            .showNotification(message, flutterLocalNotificationsPlugin);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    //_firebaseMessaging.getToken().then((token) => print(token));

    _firebaseMessaging.subscribeToTopic('posyandu2');
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  // Future<void> _showNotification(message) async {
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'your channel id', 'your channel name', 'your channel description',
  //       importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  //   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //       0, message['notification']['title'], message['notification']['body'], platformChannelSpecifics,
  //       payload: 'payload');
  // }

  // Future<String> _downloadAndSaveFile(String url, String fileName) async {
  //   var directory = await getApplicationDocumentsDirectory();
  //   var filePath = '${directory.path}/$fileName';
  //   var response = await http.get(url);
  //   var file = File(filePath);
  //   await file.writeAsBytes(response.bodyBytes);
  //   return filePath;
  // }

  //  Future<void> _showBigPictureNotificationHideExpandedLargeIcon(message) async {
  //   var largeIconPath = await _downloadAndSaveFile(
  //       message['data']['imageUrl'], 'largeIcon');
  //   var bigPicturePath = await _downloadAndSaveFile(
  //       message['data']['imageUrl'], 'bigPicture');
  //   var bigPictureStyleInformation = BigPictureStyleInformation(
  //       FilePathAndroidBitmap(bigPicturePath),
  //       hideExpandedLargeIcon: true,
  //       contentTitle: '<b>${message['notification']['title']}</b>',
  //       htmlFormatContentTitle: true,
  //       summaryText: message['notification']['body'],
  //       htmlFormatSummaryText: true);
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'big text channel id',
  //       'big text channel name',
  //       'big text channel description',
  //       largeIcon: FilePathAndroidBitmap(largeIconPath),
  //       styleInformation: bigPictureStyleInformation);
  //   var platformChannelSpecifics =
  //       NotificationDetails(androidPlatformChannelSpecifics, null);
  //   await flutterLocalNotificationsPlugin.show(
  //       0, message['notification']['title'], message['notification']['body'], platformChannelSpecifics);
  // }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: ColorBase.pink));

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
         ChangeNotifierProvider.value(
          value: PeriksaProvider(),
        ),
        ChangeNotifierProvider.value(
          value: NotificationProvider(),
        ),
        ChangeNotifierProvider.value(
          value: PertanyaanProvider(),
        ),
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: UserProvider(),
        ),
        ChangeNotifierProvider.value(
          value: CoronaProvider(),
        ),
        ChangeNotifierProvider.value(
          value: DaftarAnggotaProvider(),
        ),
        ChangeNotifierProvider.value(
          value: PemeriksaanUmumProvider(),
        ),
        ChangeNotifierProvider.value(
          value: PemeriksaanLainProvider(),
        ),
        ChangeNotifierProvider.value(
          value: Messages(),
        ),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '${Dictionary.appName}',
        theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: SharedAxisPageTransitionsBuilder(
                    transitionType: SharedAxisTransitionType.horizontal,
                  ),
                  TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
                    transitionType: SharedAxisTransitionType.horizontal,
                  ),
                },
              ),
              textTheme: TextTheme(),
              primaryColor: ColorBase.pink),
        initialRoute: '/',
        onGenerateRoute: generateRoutes,
        navigatorKey: NavigationConstants.navKey,
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posyandu Remaja Kuncup Melati"),
      ),
    );
  }
}

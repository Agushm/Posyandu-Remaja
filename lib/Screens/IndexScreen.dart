import 'dart:convert';

import 'package:bottom_navigation_badge/bottom_navigation_badge.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:posyandu_kuncup_melati/Constants/Dictionary.dart';
import 'package:posyandu_kuncup_melati/Providers/User.dart';
import 'package:posyandu_kuncup_melati/Screens/home/HomeScreen.dart';
import 'package:posyandu_kuncup_melati/Screens/messages/home_screen.dart';
import 'package:posyandu_kuncup_melati/Screens/profile/ProfileScreen.dart';
import 'package:posyandu_kuncup_melati/Services/NotificationService.dart';
import 'package:posyandu_kuncup_melati/Utils/NotificationHelper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'messages/MassagesHome.dart';

class IndexScreen extends StatefulWidget {
  final String email;
  IndexScreen({this.email});
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  int _currentIndex = 0;

  BottomNavigationBadge badger;
  List<BottomNavigationBarItem> items;

  @override
  void initState() {
    timeago.setLocaleMessages('id', timeago.IdMessages());
    _initializeBottomNavigationBar();
      
    getData();
    super.initState();
  }


  
  void getData()async{
    final prefs = await SharedPreferences.getInstance();
    final loginData = prefs.getString('loginData');
    print(loginData);
    if(loginData == null){
      await Provider.of<UserProvider>(context, listen: false)
          .fetchUserWithEmail(widget.email);
    }
    return;
  }
  

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

    _initializeBottomNavigationBar() {
    badger = BottomNavigationBadge(
        backgroundColor: Colors.red,
        badgeShape: BottomNavigationBadgeShape.circle,
        textColor: Colors.white,
        position: BottomNavigationBadgePosition.topRight,
        textSize: 8);

    items = [
      BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 16),
          title: Column(
            children: <Widget>[
              SizedBox(height: 4),
              Text(Dictionary.home),
            ],
          )),
      BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble, size: 16),
          title: Column(
            children: <Widget>[
              SizedBox(height: 4),
              Text(Dictionary.message),
            ],
          )),
      BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 16),
          title: Column(
            children: <Widget>[
              SizedBox(height: 4),
              Text(Dictionary.profile),
            ],
          )),
    ];
  }

 

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainScaffold(context);
  }

  _buildMainScaffold(BuildContext context) {
    return Scaffold(
      body: _buildContent(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: items),
    );
  }

  Widget _buildContent(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        //AnalyticsHelper.setLogEvent(Analytics.tappedMessage);
        return MessagesHome();

      case 2:
        //AnalyticsHelper.setLogEvent(Analytics.tappedFaq);
        return ProfileScreen();

      default:
        return HomeScreen();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
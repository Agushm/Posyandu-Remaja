import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Providers/Notifications.dart';

import 'package:provider/provider.dart';

class RemainderWorkout extends StatefulWidget {
  @override
  _RemainderWorkoutState createState() => _RemainderWorkoutState();
}

class _RemainderWorkoutState extends State<RemainderWorkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NotificationsProvider>(
        builder: (context,prov,_)=> Center(
          child: FlatButton(onPressed: (){
            prov.schedule5detik();
          }, child: Text('Schedule Notification')),
        ),
      ),
    );
  }
}
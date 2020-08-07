import 'package:flutter/material.dart';

import 'package:posyandu_kuncup_melati/Providers/User.dart';
import 'package:posyandu_kuncup_melati/Screens/messages/components/ListKonsultan.dart';
import 'package:posyandu_kuncup_melati/Screens/messages/components/ListRoom.dart';

class MessagesHome extends StatefulWidget {
  final UserModel user;
  MessagesHome({this.user});
  @override
  _MessagesHomeState createState() => _MessagesHomeState();
}

class _MessagesHomeState extends State<MessagesHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.pink[100],
        title: Text(
          'Konsultasi',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.message), onPressed: () {}),
        ],
      ),
      body: Center(child: Text("Comming Soon"),)
    );
  }
}

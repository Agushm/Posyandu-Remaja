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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 5, left: 10),
              child: Text(
                "Daftar Konsultan",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.pink,
                    fontWeight: FontWeight.bold),
              )),
          ListKonsultan(),
          Divider(),
          Expanded(child: ListRoom())
        ],
      ),
    );
  }
}

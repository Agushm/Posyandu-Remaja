import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Providers/Auth.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:FlatButton(
          color: ColorBase.pink,
          onPressed: (){
            Provider.of<Auth>(context,listen: false).logout();
          },
          child: Text("Log out"),
        ),
      ),
    );
  }
}
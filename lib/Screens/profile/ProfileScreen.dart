import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Node_Providers/Auth.dart';
import 'package:posyandu_kuncup_melati/Services/SharedPref.dart';
import 'package:posyandu_kuncup_melati/models/user.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserClass>(
        future: SharedPref.getUser(),
        builder: (context,snap){
          if(snap.connectionState == ConnectionState.waiting){
            return CircularProgressIndicator();
          }
          if(snap.data != null){
            final u = snap.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,            
            children: <Widget>[
              Text(u.userID),
              Text(u.nama),
              Text(u.email),
              FlatButton(
              color: ColorBase.pink,
              onPressed: (){
                Provider.of<AuthProvider>(context,listen: false).logout();
              },
              child: Text("Log out"),
        ),
            ],
          );
          }
          return Container();
        },
      ),
    );
  }
}
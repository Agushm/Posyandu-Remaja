import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/ViewModel/Auth.dart';
import 'package:posyandu_kuncup_melati/Screens/WelcomeScreen.dart';
import 'package:posyandu_kuncup_melati/Services/SharedPref.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
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
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snap.data != null) {
            final u = snap.data;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: u.jnsKelamin == "P" ? Colors.pinkAccent:Colors.blue,
                    radius: 40,
                    child: Text(
                      u.nama[0],
                      style:
                          TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20,),
                  _buildBio("ID", u.userID),
                  _buildBio("Nama", u.nama),
                  _buildBio("Jenis Kelamin",
                      u.jnsKelamin == "P" ? "Perempuan" : "Laki-Laki"),
                  _buildBio("Tempat Lahir", u.tempatLahir),
                  _buildBio("Tanggal Lahir",
                      tanggal(DateTime.parse(u.tglLahir.toString()))),
                  _buildBio("Email", u.email),
                  SizedBox(height: 20,),
                  FlatButton(
                    color: ColorBase.pink,
                    onPressed: () {
                      Provider.of<AuthProvider>(context, listen: false)
                          .logout();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>WelcomeScreen()));
                    },
                    child: Text(
                      "Log out",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}

Widget _buildBio(String title, String content) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(
        width: 20,
      ),
      Text(content),
    ],
  );
}

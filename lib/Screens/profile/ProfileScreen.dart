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
      backgroundColor: Color(0xfff1f1f1),
      appBar: AppBar(
        elevation: 0,
        title: Text("Profil"),
      ),
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
                    radius: 60,
                    child: Text(
                      u.nama[0],
                      style:
                          TextStyle(color: Colors.white,fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20,),
                  detailBio(u),
                  SizedBox(height: 20,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal:20),
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical:15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: ColorBase.pink,
                          width: 2
                        )
                      ),
                      color: Colors.white,
                      onPressed: () {
                        Provider.of<AuthProvider>(context, listen: false)
                            .logout();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>WelcomeScreen()));
                      },
                      child: Text(
                        "Keluar Akun",
                        style: TextStyle(color: ColorBase.pink),
                      ),
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

Widget detailBio(UserClass u){
  return Container(
    margin: EdgeInsets.symmetric(horizontal:20),
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20)
    ),
    child: Column(
      children: <Widget>[
        _buildBio("ID", u.userID),
        Divider(),
                    _buildBio("Nama", u.nama),
                    Divider(),
                    _buildBio("Jenis Kelamin",
                  
                        u.jnsKelamin == "P" ? "Perempuan" : "Laki-Laki"),
                    Divider(),
                    _buildBio("Tempat Lahir", u.tempatLahir),
                    Divider(),
                    _buildBio("Tanggal Lahir",
                        tanggal(DateTime.parse(u.tglLahir.toString()))),
                    Divider(),
                    _buildBio("Email", u.email),
      ],
    ),
  );
}

Widget _buildBio(String title, String content) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      SizedBox(
        width: 20,
      ),
      Text(content),
    ],
  );
}

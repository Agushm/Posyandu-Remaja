import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Constants/FontFamily.dart';
import 'package:posyandu_kuncup_melati/Providers/PemeriksaanLain.dart';
import 'package:posyandu_kuncup_melati/Providers/User.dart';
import 'package:posyandu_kuncup_melati/Screens/UserMenu/DetailPemeriksaanLain.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:provider/provider.dart';

class UserPemeriksaanLain extends StatefulWidget {
  @override
  _UserPemeriksaanLainState createState() => _UserPemeriksaanLainState();
}

class _UserPemeriksaanLainState extends State<UserPemeriksaanLain> {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Consumer2<UserProvider, PemeriksaanLainProvider>(
      builder: (context, userProv, periksa, _) {
        if (periksa.items == null) {
          periksa.fetchPeriksaByUserId(userProv.user.userId);
          return Scaffold(
            backgroundColor: ColorBase.pink,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/helicopter.png',
                    scale: 5,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          backgroundColor: ColorBase.pink,
          body: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorBase.pink,
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Center(
                            child: Text(
                              'Daftar Pemeriksaan Rutin',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Container(
                          child: Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              child: userProv.user.imageUrl == ' '
                                  ? CircleAvatar(
                                      backgroundColor: Colors.lightBlue,
                                      child: Text(
                                        userProv.user.nama[0],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(userProv.user.imageUrl),
                                    ),
                            ),
                          ),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: ColorBase.blue,
                              borderRadius: BorderRadius.circular(180)),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Text(
                          userProv.user.nama,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Stack(
                children: <Widget>[
                  Container(
                    height: 70,
                    color: ColorBase.pink,
                  ),
                  Positioned(
                    top: 27,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60)),
                        color: Colors.white,
                      ),
                      height: 45,
                      width: deviceSize.width,
                    ),
                  ),
                  Positioned(
                    left: 35,
                    child: Card(
                      elevation: 4,
                      child: Container(
                        padding: EdgeInsets.only(right: 20),
                        height: 60.0,
                        width: deviceSize.width - 80,
                        color: ColorBase.blue,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                width: 120,
                                height: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(60)),
                                    color: Colors.pinkAccent),
                                child: Center(
                                    child: Text(
                                  'Total Periksa: ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ))),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.pinkAccent),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'totalPeriksa',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10),
                    child: ListView.builder(
                      itemCount: periksa.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DetailPemeriksaanLain(periksa: periksa.items[index])));
                          },
                                                  child: Container(
                            margin: EdgeInsets.only(bottom:10),
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical:10),
                            decoration: BoxDecoration(
                              color:ColorBase.blue,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child:
                                Text(formatTgl(periksa.items[index].tglPeriksa),textAlign: TextAlign.center,style: TextStyle(
                                  color:ColorBase.white,
                                  fontFamily: FontsFamily.productSans,
                                  fontSize:20,
                                  fontWeight: FontWeight.bold
                                ),),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
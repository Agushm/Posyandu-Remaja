import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Constants/Dictionary.dart';
import 'package:posyandu_kuncup_melati/Constants/FontFamily.dart';
import 'package:posyandu_kuncup_melati/Constants/TextStyle.dart';
import 'package:posyandu_kuncup_melati/Environment/Environment.dart';
import 'package:posyandu_kuncup_melati/Screens/home/components/BannerListSlider.dart';
import 'package:posyandu_kuncup_melati/Screens/home/components/InfoKesehatanScreen.dart';
import 'package:posyandu_kuncup_melati/Screens/home/components/MenuList.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _versionText = Dictionary.version;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorBase.grey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ColorBase.pink,
        title: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              child: Center(
                child: Image.asset('${Environment.iconAssets}logo.png',
                    width: 40.0, height: 40.0),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Dictionary.appName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.intro,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        Dictionary.subTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          fontFamily: FontsFamily.intro,
                        ),
                      ),
                    )
                  ],
                )),
              
          ],
        ),
        actions: <Widget>[
          IconButton(

            color: Colors.white,
            onPressed: (){},
            icon: Icon(
              
              Icons.notifications),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.10,
            color: ColorBase.pink,
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        child: BannerListSlider()),
                    // Container(
                    //   color: ColorBase.white,
                    //   child: StatusCorona(),
                    // ),
                    Container(
                      child:MenuList()
                    ),
                    Container(
                      color: ColorBase.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Informasi Kesehatan",
                              style: ConsTextStyle.judulMenuHome),
                        ],
                      ),
                    ),
                    Container(
                      color: ColorBase.white,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: DefaultTabController(
                        length: 2,
                        child: Column(
                          children: <Widget>[
                            TabBar(
                              labelColor: Colors.black,
                              indicatorColor: ColorBase.pink,
                              indicatorWeight: 2.8,
                              tabs: <Widget>[
                                Tab(
                                  child: Text(
                                    Dictionary.informasiRemaja,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: FontsFamily.productSans,
                                        fontSize: 13.0),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    Dictionary.informasiUmum,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: FontsFamily.productSans,
                                        fontSize: 13.0),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              height: 400,
                              child: TabBarView(
                                children: <Widget>[
                                  InfoKesehatanScreen(
                                    kesehatan: Dictionary.informasiRemaja,
                                    maxLength: 3,
                                  ),
                                  InfoKesehatanScreen(
                                    kesehatan: Dictionary.informasiUmum,
                                    maxLength: 3,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 500,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

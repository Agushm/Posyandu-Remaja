import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Constants/Dictionary.dart';
import 'package:posyandu_kuncup_melati/Constants/TextStyle.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorBase.pink,
      body: Center(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            Dictionary.posyandu,
            style: ConsTextStyle.judulLoginScreen,
          ),
          Text(
            Dictionary.posName,
            style: ConsTextStyle.judulLoginScreen,
          ),
          Text(
            Dictionary.desa,style: ConsTextStyle.subJudulLoginScreen,
          ),
          ],
        ),
      ),
    );
  }
}
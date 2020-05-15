import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Constants/FontFamily.dart';

class ConsTextStyle {
  static TextStyle judulWelcomeScreen = TextStyle(
      fontFamily: FontsFamily.productSans,
      color: ColorBase.white,
      fontSize: 20,
      fontWeight: FontWeight.bold);
  static TextStyle judulLoginScreen = TextStyle(
      fontFamily: FontsFamily.productSans,
      color: ColorBase.white,
      fontSize: 30,
      fontWeight: FontWeight.bold);
  static TextStyle subJudulLoginScreen = TextStyle(
      fontFamily: FontsFamily.productSans,
      color: ColorBase.white,
      fontSize: 20,
      fontWeight: FontWeight.w100);
  static TextStyle loginScreenTextField = TextStyle(
      color: ColorBase.white,
      fontFamily: FontsFamily.productSans,
      fontSize: 18,
      fontWeight: FontWeight.bold);
      static TextStyle loginScreenErrTextField = TextStyle(
      color: ColorBase.orange,
      fontFamily: FontsFamily.productSans,
      fontSize: 14,
      fontWeight: FontWeight.bold);
  static TextStyle loginScreenHint = TextStyle(
      color: ColorBase.white,
      fontFamily: FontsFamily.productSans,
      fontSize: 15);
  static TextStyle loginScreenInput = TextStyle(
      color: ColorBase.white,
      fontFamily: FontsFamily.productSans,
      fontSize: 18);
  static TextStyle btnLogin = TextStyle(
      color: ColorBase.pink,
      fontFamily: FontsFamily.productSans,
      fontSize: 20,
      fontWeight: FontWeight.bold);
  static TextStyle judulMenuHome = TextStyle(
                              color: ColorBase.pink,
                              fontFamily: FontsFamily.productSans,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            );
  static TextStyle statusCorona = TextStyle(
      color: ColorBase.white,
      fontSize: 15,
      fontFamily: FontsFamily.productSans,
      fontWeight: FontWeight.bold);
  static TextStyle jumlahCorona = TextStyle(
      color: ColorBase.white,
      fontSize: 18,
      fontFamily: FontsFamily.productSans,
      fontWeight: FontWeight.bold);

  static TextStyle kTglPeriksaTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.pink,
  fontWeight: FontWeight.bold,
);

static TextStyle timeAgoLastChat =  TextStyle(
                        color: Colors.black54,
                        fontFamily: FontsFamily.productSans,
                        fontSize: 10
                      );
}

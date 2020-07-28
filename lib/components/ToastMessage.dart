import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage{
  static void message(String msg){
    Fluttertoast.showToast(msg: msg );
  }

  static void errorMessage(String msg){
    Fluttertoast.showToast(msg: msg,backgroundColor: Colors.red,);
  }
}
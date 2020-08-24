import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';

class FromInputDecoration{
  static InputDecoration outlineInputCari(String label,String hint) {
    return InputDecoration(
      suffixIcon: Icon(Icons.search),
        labelText: label,
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorBase.pink, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorBase.pink, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      );
  }
}
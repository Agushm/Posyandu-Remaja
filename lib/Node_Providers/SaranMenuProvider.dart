import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:posyandu_kuncup_melati/Services/SharedPref.dart';
import 'package:posyandu_kuncup_melati/config/BaseAPI.dart';
import 'package:posyandu_kuncup_melati/config/HeaderHttp.dart';
import 'package:posyandu_kuncup_melati/models/menu.dart';

class SaranMenuProvider with ChangeNotifier{
List<Menu> makananPokok;
List<Menu> makananLauk;
List<Menu> makanan;

Future<void> getSaranMakanan(String periksaID)async{
  final token = await SharedPref.getToken();
  try{
    final res = await http.get(BaseAPI.saranMenu,headers: bearerHeader(token));
    final resData = json.decode(res.body);
  }catch(err){
    print(err);
  }
}
}
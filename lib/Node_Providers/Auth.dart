import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:posyandu_kuncup_melati/Services/SharedPref.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:posyandu_kuncup_melati/components/ToastMessage.dart';
import 'package:posyandu_kuncup_melati/config/BaseAPI.dart';
import 'dart:convert';

import 'package:posyandu_kuncup_melati/config/HeaderHttp.dart';
import 'package:posyandu_kuncup_melati/models/user.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  String _email;
  User _user;
  User get user =>_user;
  String get token => _token;
  String get email => _email;
  
  bool get isAuth {
    return user != null;
  }



  Future<String> daftar(
      {String email,
      password,
      String nama,
      String gender,
      DateTime tglLahir,
      String tempatLahir}) async {
    final uri = BaseAPI.register;
    try {
      final res = await http.post(uri,
          headers: bearerHeader(null),
          body: json.encode({
            "nama": nama,
            "tempat_lahir": tempatLahir,
            "tgl_lahir": formatTglMysql(tglLahir),
            "jns_kel": gender,
            "email": email,
            "password": password,
          }));
      final resData = json.decode(res.body);
      print(res.body);
      if (resData["status"] == "OK") {
        ToastMessage.message(resData["messages"]);
        return resData["status"];
      } else {
        ToastMessage.errorMessage(resData["messages"]);
        return resData["status"];
      }
    } catch (err) {
      ToastMessage.errorMessage("Maaf terjadi kesalahan");
      print(err);
    }
  }

  Future<String> login({String email, String password}) async {
    final uri = BaseAPI.login;
    try {
      final res = await http.post(uri,
          headers: bearerHeader(null),
          body: json.encode({
            "email": email,
            "password": password,
          }));
      final resData = json.decode(res.body);
      print(resData);
      if (resData["status"] == "OK") {
        ToastMessage.message(resData["messages"]);
        _token = resData["token"];
        _email = email;

        User userData = User(
          auth: resData["token"],
          user: UserClass.fromJson(
            resData["userData"],
          ),
        );
        // final userJson = json.encode({
        //   "auth":userData.auth,
        //   "user":user.user
        // });
        _user = userData;
        print(userData.auth);
        await SharedPref.saveData("userData", json.encode(userData));
        notifyListeners();
        return resData["status"];
      } else {
        ToastMessage.errorMessage(resData["messages"]);
        return resData["status"];
      }
    } catch (err) {
      ToastMessage.errorMessage("Maaf terjadi kesalahan");
      print(err);
    }
  }
  Future<void> getOfflineData()async{
    final user = await SharedPref.getUserData();
    _user =user;
    _token = user.auth;
    notifyListeners();
  }
  void simpanData(String key, String data) {
    SharedPref.saveData(key, data);
  }
}

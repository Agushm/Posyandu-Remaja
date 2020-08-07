import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:posyandu_kuncup_melati/components/ToastMessage.dart';
import 'package:posyandu_kuncup_melati/config/BaseAPI.dart';
import 'package:posyandu_kuncup_melati/config/HeaderHttp.dart';
import 'package:posyandu_kuncup_melati/models/user.dart';


class DaftarAnggotaProvider with ChangeNotifier {
  List<UserClass> _items;

  List<UserClass> get items => _items;

  List<UserClass> byRole(String role) {
    return _items.where((anggota) => anggota.role == role).toList();
  }

  UserClass findById(String id) {
    return _items.firstWhere((anggota) => anggota.userID == id);
  }

  Future<void> fetchDaftarAnggota() async {
    var url = BaseAPI.anggota;
    try {
      var res = await http.get(url, headers: bearerHeader(null));
      var resData = json.decode(res.body);
      print(resData);
      if (resData == null) {
        return;
      }

      if (resData["status"] == "OK") {
        final List<UserClass> loadedAnggota = [];
        final d = resData["data"] as List;
        d.forEach((e) {
          loadedAnggota.add(UserClass.fromJson(e));
        });
        _items = loadedAnggota;
        notifyListeners();
      }
      if (resData["status"] == "ERROR") {
        _items = [];
        notifyListeners();
      }
    } catch (error) {
      _items = [];
      notifyListeners();
      throw error;
    }
  }

  Future<String> tambahAnggota(
      {String email,
      String password,
      String nama,
      String gender,
      DateTime tglLahir,
      String tempatLahir,
      String role,
      String active
      }) async {
    final uri = BaseAPI.tambahAnggota;
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
            "role":role,
            "active":active
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
      return "ERROR";
    }
  }

  Future<String> editAnggota(
      {
        String userID,
        String email,
      
      String nama,
      String gender,
      DateTime tglLahir,
      String tempatLahir,
      String role,
      String active,
      }) async {
    final uri = BaseAPI.editAnggota;
    try {
      final res = await http.patch(uri,
          headers: bearerHeader(null),
          body: json.encode({
            "user_ID":userID,
            "nama": nama,
            "tempat_lahir": tempatLahir,
            "tgl_lahir": formatTglMysql(tglLahir),
            "jns_kel": gender,
            "email": email,
            "role":role,
            "active":active,
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
      return "ERROR";
    }
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:posyandu_kuncup_melati/Services/SharedPref.dart';
import 'package:posyandu_kuncup_melati/config/BaseAPI.dart';
import 'package:posyandu_kuncup_melati/config/HeaderHttp.dart';
import 'package:posyandu_kuncup_melati/models/Periksa.dart';
import 'package:posyandu_kuncup_melati/widgets/Toast.dart';

class PeriksaProvider with ChangeNotifier {
  List<Periksa> _items;
  List<Periksa> get items => _items;

  void destroy() {
    _items = null;
    notifyListeners();
  }

  Future<void> fetchPeriksaByUserID(String userID) async {
    final token = await SharedPref.getToken();
    final uri = BaseAPI.periksa + userID;
    print(uri);
    try {
      final res = await http.get(uri, headers: bearerHeader(token));
      final resData = json.decode(res.body);
      print(resData);
      if (resData["status"] == "OK") {
        List<Periksa> _load = [];
        final d = resData["data"] as List;
        d.forEach((e) {
          _load.add(Periksa.fromJson(e));
        });
        _items = _load;
        notifyListeners();
      } else {
        _items = [];
        notifyListeners();
      }
    } catch (err) {
      _items = [];
      notifyListeners();
      print(err);
    }
  }

  Future<void> tambahPeriksa({Map<String,String> dataPeriksa}) async {
    final petugas = await SharedPref.getUser();
    final token = await SharedPref.getToken();
    final uri = BaseAPI.tambahPeriksa;

    try {
      final res = await http.post(uri,
          headers: bearerHeader(token),
          body: json.encode({
            "user_ID": dataPeriksa["user_ID"],
            "petugas_ID": petugas.userID,
            "tb": dataPeriksa["tb"],
            "bb": dataPeriksa["bb"],
            "td": dataPeriksa["td"],
            "lila": dataPeriksa["lila"],
            "hpmt": dataPeriksa["hpmt"],
            "ttd": dataPeriksa["ttd"],
            "tindakan": dataPeriksa["tindakan"]
          }));
      final resData = json.decode(res.body);
      print(resData);
      if (resData["status"] == "OK") {
        Fluttertoast.showToast(msg: resData["messages"]);
      } else {
        Fluttertoast.showToast(msg: "Gagal menambah data periksa", backgroundColor: Colors.red);
      }
    } catch (err) {
  
      errorToast("Terjadi kesalahan");
      print(err);
    }
  }

  Future<void> updatePeriksa({Map<String,String> dataPeriksa}) async {
    final petugas = await SharedPref.getUser();
    final token = await SharedPref.getToken();
    final uri = BaseAPI.updatePeriksa;

    try {
      final res = await http.patch(uri,
          headers: bearerHeader(token),
          body: json.encode({
            "periksa_ID":dataPeriksa["periksa_ID"],
            "user_ID": dataPeriksa["user_ID"],
            "petugas_ID": petugas.userID,
            "tb": dataPeriksa["tb"],
            "bb": dataPeriksa["bb"],
            "td": dataPeriksa["td"],
            "lila": dataPeriksa["lila"],
            "hpmt": dataPeriksa["hpmt"],
            "ttd": dataPeriksa["ttd"],
            "tindakan": dataPeriksa["tindakan"],
            "tglPeriksa":dataPeriksa["tglPeriksa"]
          }));
      final resData = json.decode(res.body);
      print(resData);
      if (resData["status"] == "OK") {
        Fluttertoast.showToast(msg: resData["messages"]);
      } else {
        errorToast("Gagal mengupdate data periksa");
      }
    } catch (err) {
      errorToast("Terjadi kesalahan");
      print(err);
    }
  }

  void batalHapus(int index, Periksa periksa){
    _items.insert(index, periksa);
    notifyListeners();
  }

  Future<void> deletePeriksa({String periksaID}) async {
    final token = await SharedPref.getToken();
    final uri = BaseAPI.deletePeriksa+periksaID;
    try {
      final res = await http.delete(uri,
          headers: bearerHeader(token));
      final resData = json.decode(res.body);
      print(resData);
      if (resData["status"] == "OK") {
        dropFromList(periksaID);
        Fluttertoast.showToast(msg: resData["messages"]);
      } else {
        Fluttertoast.showToast(msg: "Gagal menghapus data periksa", backgroundColor: Colors.red);
      }
    } catch (err) {
      errorToast("Terjadi kesalahan");
      print(err);
    }
  }

  void dropFromList(String periksaID){
    final periksa = _items.firstWhere((e) => e.periksaId == periksaID);
    int index = _items.indexOf(periksa);
    _items.removeAt(index);
    notifyListeners();
  }
}

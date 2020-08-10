import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:posyandu_kuncup_melati/Services/SharedPref.dart';
import 'package:posyandu_kuncup_melati/config/BaseAPI.dart';
import 'package:posyandu_kuncup_melati/config/HeaderHttp.dart';
import 'package:posyandu_kuncup_melati/models/informasi.dart';
import 'package:http/http.dart' as http;

class InformasiProvider with ChangeNotifier {
  List<Informasi> _informasi;
  List<Informasi> get informasi => _informasi;

  Future<void> getInformasi() async {
    final token = await SharedPref.getToken();
    try {
      final res =
          await http.get(BaseAPI.getInformasi, headers: bearerHeader(token));

      final resData = json.decode(res.body);
      print(resData);
      if (resData["status"] == "OK") {
        final d = resData["data"] as List;
        List<Informasi> load = [];
        d.forEach((e) {
          load.add(Informasi.fromJson(e));
        });
        _informasi = load;
        notifyListeners();
      } else {
        _informasi = [];
        notifyListeners();
      }
    } catch (err) {
      print(err);
      _informasi = [];
      notifyListeners();
    }
  }
}

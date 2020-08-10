import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:posyandu_kuncup_melati/Services/SharedPref.dart';
import 'package:posyandu_kuncup_melati/config/BaseAPI.dart';
import 'package:posyandu_kuncup_melati/config/HeaderHttp.dart';
import 'package:posyandu_kuncup_melati/models/banner.dart';
import 'package:http/http.dart' as http;

class BannerProvider with ChangeNotifier {
  List<Banner> _banner;
  List<Banner> get banner => _banner;

  Future<void> getBanner() async {
    final token = await SharedPref.getToken();
    try {
      final res =
          await http.get(BaseAPI.getInformasi, headers: bearerHeader(token));
      final resData = json.decode(res.body);
      if (resData["status"] == "OK") {
        final d = resData["data"] as List;
        List<Banner> load = [];
        d.forEach((e) {
          load.add(Banner.fromJson(e));
        });
        _banner = load;
        notifyListeners();
      } else {
        _banner = [];
        notifyListeners();
      }
    } catch (err) {
      print(err);
      _banner = [];
      notifyListeners();
    }
  }
}

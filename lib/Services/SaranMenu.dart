import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:posyandu_kuncup_melati/Services/SharedPref.dart';
import 'package:posyandu_kuncup_melati/config/BaseAPI.dart';
import 'package:posyandu_kuncup_melati/config/HeaderHttp.dart';
import 'package:posyandu_kuncup_melati/models/Periksa.dart';
import 'package:posyandu_kuncup_melati/models/aktifitas.dart';
import 'package:posyandu_kuncup_melati/models/jawaban.dart';
import 'package:posyandu_kuncup_melati/models/menu.dart';

class SaranMenu {
  static Future<Map<String, dynamic>> getSaranMenu() async {
    final token = await SharedPref.getToken();
    final user = await SharedPref.getUser();
    final uri = BaseAPI.saranMenu + '${user.userID}';
    try {
      final res = await http.get(uri, headers: bearerHeader(token));
      print(res.body);
      final resData = json.decode(res.body);
      if (resData["status"] == "OK") {
        final pokok = resData["pokok"] as List;
        List<Menu> loadPokok = [];
        pokok.forEach((e) {
          loadPokok.add(Menu.fromJson(e));
        });
        final lauk = resData["lauk"] as List;
        List<Menu> loadLauk = [];
        lauk.forEach((e) {
          loadLauk.add(Menu.fromJson(e));
        });
        final sayur = resData["sayur"] as List;
        List<Menu> loadSayur = [];
        sayur.forEach((e) {
          loadSayur.add(Menu.fromJson(e));
        });
        final buah = resData["buah"] as List;
        List<Menu> loadBuah = [];
        buah.forEach((e) {
          loadBuah.add(Menu.fromJson(e));
        });
        final minuman = resData["minuman"] as List;
        List<Menu> loadMinuman = [];
        minuman.forEach((e) {
          loadMinuman.add(Menu.fromJson(e));
        });
        final selingan = resData["selingan"] as List;
        List<Menu> loadSelingan= [];
        selingan.forEach((e) {
          loadSelingan.add(Menu.fromJson(e));
        });
        Periksa dataPeriksa = Periksa(
            tglPeriksa: resData["dataPeriksa"]["tgl_periksa"],
            tb: resData["dataPeriksa"]["tb"].toString(),
            bb: resData["dataPeriksa"]["bb"].toString(),
            imt: resData["dataPeriksa"]["imt"].toString(),
            kategoriImt: resData["dataPeriksa"]["kategori_imt"]);
        Jawaban dataJawaban = Jawaban.fromJson(resData["dataJawaban"]);
        Aktifitas dataAktifitas = Aktifitas.fromJson(resData["dataAktifitas"]);
        return {
          "status": "OK",
          "dataPeriksa": dataPeriksa,
          "dataJawaban": dataJawaban,
          "dataAktifitas": dataAktifitas,
          "pokok": loadPokok,
          "lauk": loadLauk,
          "sayur": loadSayur,
          "buah": loadBuah,
          "minuman": loadMinuman,
          "selingan": loadSelingan,
          "totalKalori": resData["totalKalori"]
        };
      } else {
        if (resData["dataPeriksa"] != null) {
          Periksa dataPeriksa = Periksa(
              tglPeriksa: resData["dataPeriksa"]["tgl_periksa"],
              tb: resData["dataPeriksa"]["tb"].toString(),
              bb: resData["dataPeriksa"]["bb"].toString(),
              imt: resData["dataPeriksa"]["imt"].toString(),
              kategoriImt: resData["dataPeriksa"]["kategori_imt"]);
          return {"status": "ERROR", "dataPeriksa": dataPeriksa};
        } else {
          return null;
        }
      }
    } catch (err) {
      print(err);
      return null;
    }
  }

  static Future<Map<String, dynamic>> getSaranCustom() async {
    final token = await SharedPref.getToken();
    final user = await SharedPref.getUser();
    final uri = BaseAPI.saranCustom + '${user.userID}';
    try {
      final res = await http.get(uri, headers: bearerHeader(token));
      print(res.body);
      final resData = json.decode(res.body);
      if (resData["status"] == "OK") {
        Periksa dataPeriksa = Periksa(
            tglPeriksa: resData["dataPeriksa"]["tgl_periksa"],
            tb: resData["dataPeriksa"]["tb"].toString(),
            bb: resData["dataPeriksa"]["bb"].toString(),
            imt: resData["dataPeriksa"]["imt"].toString(),
            kategoriImt: resData["dataPeriksa"]["kategori_imt"]);
        Jawaban dataJawaban = Jawaban.fromJson(resData["dataJawaban"]);
        Aktifitas dataAktifitas = Aktifitas.fromJson(resData["dataAktifitas"]);
        return {
          "status": "OK",
          "dataPeriksa": dataPeriksa,
          "dataJawaban": dataJawaban,
          "dataAktifitas": dataAktifitas,
          "minKalori": resData["minKalori"].toString(),
          "maxKalori": resData["maxKalori"].toString()
        };
      } else {
        if (resData["dataPeriksa"] != null) {
          Periksa dataPeriksa = Periksa(
              tglPeriksa: resData["dataPeriksa"]["tgl_periksa"],
              tb: resData["dataPeriksa"]["tb"].toString(),
              bb: resData["dataPeriksa"]["bb"].toString(),
              imt: resData["dataPeriksa"]["imt"].toString(),
              kategoriImt: resData["dataPeriksa"]["kategori_imt"]);
          return {"status": "ERROR", "dataPeriksa": dataPeriksa};
        } else {
          return null;
        }
      }
    } catch (err) {
      print(err);
      return null;
    }
  }

  static Future<List<Menu>> getPilihanMenu(String jenis) async {
    final token = await SharedPref.getToken();
    final uri = BaseAPI.getMenu + '$jenis';
    try {
      print(uri);
      final res = await http.get(uri, headers: bearerHeader(token));
      print(res.body);
      final resData = json.decode(res.body);
      if (resData["status"] == "OK") {
        final data = resData["data"] as List;
        List<Menu> loaded = [];
        data.forEach((e) {
          loaded.add(Menu.fromJson(e));
        });
        return loaded;
      } else {
        return null;
      }
    } catch (err) {
      print(err);
      return null;
    }
  }
}

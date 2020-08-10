import 'package:flutter/foundation.dart';
import 'package:posyandu_kuncup_melati/Services/SaranMenu.dart';
import 'package:posyandu_kuncup_melati/models/Periksa.dart';

import 'package:posyandu_kuncup_melati/models/aktifitas.dart';
import 'package:posyandu_kuncup_melati/models/jawaban.dart';
import 'package:posyandu_kuncup_melati/models/menu.dart';

class SaranMenuProvider with ChangeNotifier {
  bool error = false;
  List<Menu> _pokok;
  List<Menu> _lauk;
  List<Menu> _sayur;
  List<Menu> _buah;
  List<Menu> _minuman;

  List<Menu> get pokok=>_pokok;
  List<Menu> get sarapan {
    List<Menu> load = [];
    load.add(_pokok[0]);
    load.add(_lauk[0]);
    load.add(_sayur[0]);
    load.add(_buah[0]);
    load.add(_minuman[0]);
    return load;
  }

  List<Menu> get siang {
    List<Menu> load = [];
    load.add(_pokok[1]);
    load.add(_lauk[1]);
    load.add(_sayur[1]);
    load.add(_buah[1]);
    load.add(_minuman[1]);
    return load;
  }

  List<Menu> get malam {
    List<Menu> load = [];
    load.add(_pokok[2]);
    load.add(_lauk[2]);
    load.add(_sayur[2]);
    load.add(_buah[2]);
    load.add(_minuman[2]);
    return load;
  }



  Periksa dataPeriksa;
  Jawaban dataJawaban;
  Aktifitas dataAktifitas;
  String totalKaloriMakan;

  Future<void> getSaranMakanan() async {
    final data = await SaranMenu.getSaranMenu();
    if (data != null &&data["status"] == "OK") {
      _pokok = data["pokok"];
      _lauk = data["lauk"];
      _sayur = data["sayur"];
      _buah = data["buah"];
      _minuman = data["minuman"];
      dataPeriksa = data["dataPeriksa"];
      dataJawaban = data["dataJawaban"];
      dataAktifitas = data["dataAktifitas"];
      totalKaloriMakan = data["totalKalori"].toString();
      notifyListeners();
    }
    if (data != null &&data["status"] == "ERROR") {
      error = true;
      dataPeriksa = data["dataPeriksa"];
      notifyListeners();
      return;
    }
  }
}

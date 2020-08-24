import 'package:flutter/foundation.dart';
import 'package:posyandu_kuncup_melati/Services/SaranMenu.dart';
import 'package:posyandu_kuncup_melati/Utils/dataPertanyaan.dart';
import 'package:posyandu_kuncup_melati/models/Periksa.dart';

import 'package:posyandu_kuncup_melati/models/aktifitas.dart';
import 'package:posyandu_kuncup_melati/models/jawaban.dart';
import 'package:posyandu_kuncup_melati/models/menu.dart';
import 'package:posyandu_kuncup_melati/models/pertanyaan.dart';

class SaranMenuProvider with ChangeNotifier {
  bool error = false;
  List<Menu> _pokok;
  List<Menu> _lauk;
  List<Menu> _sayur;
  List<Menu> _buah;
  List<Menu> _minuman;
  List<Menu> _selingan;

  List<Menu> get pokok => _pokok;
  List<Menu> get sarapan {
    List<Menu> load = [];
    load.add(_pokok[0]);
    load.add(_lauk[0]);
    load.add(_sayur[0]);
    load.add(_buah[0]);
    load.add(_minuman[0]);
    load.add(_selingan[0]);
    return load;
  }

  List<Menu> get siang {
    List<Menu> load = [];
    load.add(_pokok[1]);
    load.add(_lauk[1]);
    load.add(_sayur[1]);
    load.add(_buah[1]);
    load.add(_minuman[1]);
    load.add(_selingan[1]);
    return load;
  }

  List<Menu> get malam {
    List<Menu> load = [];
    load.add(_pokok[2]);
    load.add(_lauk[2]);
    load.add(_sayur[2]);
    load.add(_buah[2]);
    load.add(_minuman[2]);
    load.add(_selingan[2]);
    return load;
  }

  Periksa dataPeriksa;
  Jawaban dataJawaban;
  Aktifitas dataAktifitas;
  String totalKaloriMakan;

  Future<void> getSaranMakanan() async {
    final data = await SaranMenu.getSaranMenu();
    if (data != null && data["status"] == "OK") {
      print(">>>>>>>>>>>> jalan");
      _pokok = data["pokok"];
      _lauk = data["lauk"];
      _sayur = data["sayur"];
      _buah = data["buah"];
      _minuman = data["minuman"];
      _selingan = data["selingan"];
      dataPeriksa = data["dataPeriksa"];
      dataJawaban = data["dataJawaban"];
      dataAktifitas = data["dataAktifitas"];
      totalKaloriMakan = data["totalKalori"].toString();
      jawaban();
      notifyListeners();
    }
    if (data != null && data["status"] == "ERROR") {
      error = true;
      dataPeriksa = data["dataPeriksa"];
      notifyListeners();
      return;
    }
  }

  List<Map<String, String>> quiz = [
    {
      "soal": "1",
      "pertanyaan": DataPertanyaan.dataPertanyaan[0].isiPertanyaan,
      "jawaban": "",
    },
    {
      "soal": "2",
      "pertanyaan": DataPertanyaan.dataPertanyaan[1].isiPertanyaan,
      "jawaban": ""
    },
    {
      "soal": "3",
      "pertanyaan": DataPertanyaan.dataPertanyaan[2].isiPertanyaan,
      "jawaban": ""
    },
    {
      "soal": "4",
      "pertanyaan": DataPertanyaan.dataPertanyaan[3].isiPertanyaan,
      "jawaban": ""
    },
    {
      "soal": "5",
      "pertanyaan": DataPertanyaan.dataPertanyaan[4].isiPertanyaan,
      "jawaban": ""
    }
  ];
  void jawaban(){
    List jawaban = dataJawaban.jawaban.split(':');
    quiz[0]["jawaban"]= jawaban[0];
    quiz[1]["jawaban"]= jawaban[1];
    quiz[2]["jawaban"]= jawaban[2];
    quiz[3]["jawaban"]= jawaban[3];
    quiz[4]["jawaban"]= jawaban[4];
    notifyListeners();
  }

  Pilihan getJawabanByKode(String kode, int index){
    return DataPertanyaan.dataPertanyaan[index].pilihan.firstWhere((e) => e.pilihanId == kode);
  }
}

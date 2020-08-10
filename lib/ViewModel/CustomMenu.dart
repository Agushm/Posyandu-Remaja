import 'package:flutter/cupertino.dart';
import 'package:posyandu_kuncup_melati/Services/SaranMenu.dart';
import 'package:posyandu_kuncup_melati/models/Periksa.dart';
import 'package:posyandu_kuncup_melati/models/aktifitas.dart';
import 'package:posyandu_kuncup_melati/models/jawaban.dart';

class CustomMenu with ChangeNotifier{
  Periksa _dataPeriksa;
  Jawaban _dataJawaban;
  Aktifitas _dataAktifitas;

  Periksa get dataPeriksa=>_dataPeriksa;
  Jawaban get dataJawaban => _dataJawaban;
  Aktifitas get dataAktifitas => _dataAktifitas;
  double minKalori;
  double maxKalori;
  bool error = false;

  Future<void> getSaranCustom()async{
    final data = await SaranMenu.getSaranCustom();
    if(data["status"] == "OK"){
      _dataPeriksa = data["dataPeriksa"];
      _dataJawaban = data["dataJawaban"];
      _dataAktifitas = data["dataAktifitas"];
      minKalori = double.parse(data["minKalori"].toString());
      maxKalori = double.parse(data["maxKalori"].toString());
      notifyListeners();
    }else{
      error = true;
      _dataPeriksa =data["dataPeriksa"];
      notifyListeners();
    }
  }
}
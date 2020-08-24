import 'package:flutter/cupertino.dart';
import 'package:posyandu_kuncup_melati/Services/SaranMenu.dart';
import 'package:posyandu_kuncup_melati/models/Periksa.dart';
import 'package:posyandu_kuncup_melati/models/aktifitas.dart';
import 'package:posyandu_kuncup_melati/models/jawaban.dart';
import 'package:posyandu_kuncup_melati/models/menu.dart';

class CustomMenu with ChangeNotifier{
  Periksa _dataPeriksa;
  Jawaban _dataJawaban;
  Aktifitas _dataAktifitas;

  Periksa get dataPeriksa => _dataPeriksa;
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
      // minKalori = double.parse(data["minKalori"].toString());
      // maxKalori = double.parse(data["maxKalori"].toString());
      notifyListeners();
    }else{
      error = true;
      _dataPeriksa =data["dataPeriksa"];
      notifyListeners();
    }
  }
  Map<String,Menu> sarapan ={
    "pokok":Menu(
      jmlKalori: 0,
    ),
    "sayur":Menu(
      jmlKalori: 0,
    ),
    "lauk":Menu(
      jmlKalori: 0,
    ),
    "buah":Menu(
      jmlKalori: 0,
    ),
    "minuman":Menu(
      jmlKalori: 0,
    ),
    "selingan":Menu(
      jmlKalori: 0,
    ),
  };
  Map<String,Menu> menuSiang ={
    "pokok":Menu(
      jmlKalori: 0,
    ),
    "sayur":Menu(
      jmlKalori: 0,
    ),
    "lauk":Menu(
      jmlKalori: 0,
    ),
    "buah":Menu(
      jmlKalori: 0,
    ),
    "minuman":Menu(
      jmlKalori: 0,
    ),
    "selingan":Menu(
      jmlKalori: 0,
    ),
  };
  Map<String,Menu> menuMalam ={
    "pokok":Menu(
      jmlKalori: 0,
    ),
    "sayur":Menu(
      jmlKalori: 0,
    ),
    "lauk":Menu(
      jmlKalori: 0,
    ),
    "buah":Menu(
      jmlKalori: 0,
    ),
    "minuman":Menu(
      jmlKalori: 0,
    ),
    "selingan":Menu(
      jmlKalori: 0,
    ),
  };


  List<Menu> _pilihanMenu;

  List<Menu> get pilihanMenu => _pilihanMenu;

  List<Menu> filterPilihanMenu(String keyword){
   
      return pilihanMenu.where((e) => e.namaMakanan.toLowerCase().contains(keyword.toLowerCase())).toList();
    
  }
  Future<void> getPilihanMenu(String jenis)async{
    final data = await SaranMenu.getPilihanMenu(jenis);
    if(data != null){
      _pilihanMenu = data;
      notifyListeners();
    }else{
      _pilihanMenu = [];
      notifyListeners();
    }
  }
  void updateMenu(String jenis,String menu, Menu item){
    if(menu == "sarapan"){
      sarapan[jenis]=item;
      notifyListeners();
    }
    if(menu == "siang"){
      menuSiang[jenis]=item;
      notifyListeners();
    }
    if(menu == "malam"){
      menuMalam[jenis]=item;
      notifyListeners();
    }
  }

  double get totalSarapan{
    double totalSarapan = (sarapan['pokok'].jmlKalori + sarapan['sayur'].jmlKalori + sarapan['lauk'].jmlKalori + sarapan['buah'].jmlKalori + sarapan['minuman'].jmlKalori + sarapan['selingan'].jmlKalori).toDouble();
    return totalSarapan;
  }
  double get totalSiang{
    double totalSiang = (menuSiang['pokok'].jmlKalori + menuSiang['sayur'].jmlKalori + menuSiang['lauk'].jmlKalori + menuSiang['buah'].jmlKalori + menuSiang['minuman'].jmlKalori + menuSiang['selingan'].jmlKalori).toDouble();
    return totalSiang;
  }
  double get totalMalam{
    double totalMalam = (menuMalam['pokok'].jmlKalori + menuMalam['sayur'].jmlKalori + menuMalam['lauk'].jmlKalori + menuMalam['buah'].jmlKalori + menuMalam['minuman'].jmlKalori + menuMalam['selingan'].jmlKalori).toDouble();
    return totalMalam;
  }

  double get totalKalori{
    double total = totalSarapan +totalSiang + totalMalam;
    return total;
  }
}
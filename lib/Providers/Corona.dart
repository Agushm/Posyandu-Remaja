import'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CoronaModel{
  String kodeProv;
  String provName;
  String kasusPositif;
  String kasusSembuh;
  String kasusMeinggal;
  CoronaModel({
    this.kodeProv,
    this.provName,
    this.kasusPositif,
    this.kasusSembuh,
    this.kasusMeinggal
  });
}

class CoronaProvider with ChangeNotifier{
  List<CoronaModel> _items;
  List<CoronaModel> get coronaData => _items;
  CoronaModel findByProv(String prov) {
    return _items.firstWhere((kasus) => kasus.provName == prov);
  }
  Future<void> getCorona()async{
    try{
      final res = await http.get("https://api.kawalcorona.com/indonesia/provinsi/");
      final resData = json.decode(res.body) as List;
      List<CoronaModel> loadedData = [];
      resData.forEach((value){
        loadedData.add(CoronaModel(
          kodeProv: value['attributes']['Kode_Provi'].toString(),
          provName: value['attributes']['Provinsi'].toString(),
          kasusPositif: value['attributes']['Kasus_Posi'].toString(),
          kasusSembuh: value['attributes']['Kasus_Semb'].toString(),
          kasusMeinggal: value['attributes']['Kasus_Meni'].toString(),
        ));
      });
      _items = loadedData;
      notifyListeners();
    }catch(err){
      throw err;
    }
  }
}
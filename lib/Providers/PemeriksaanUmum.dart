import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class PeriksaUmumModel {
  final String id;
  final String userId;
  final double bb;
  final double tb;
  final double imt;
  final String td;
  final double lila;
  final String ttd;
  final String hpmt;
  final String tindakan;
  DateTime tglPeriksa;
  PeriksaUmumModel({
  @required this.id,
    @required this.userId,
    @required this.bb,
    @required this.tb,
    @required this.imt,
    @required this.td,
    @required this.lila,
    @required this.ttd,
    @required this.hpmt,
    @required this.tindakan,
    @required this.tglPeriksa
  }); 
}

class PemeriksaanUmumProvider with ChangeNotifier {
  List<PeriksaUmumModel> _items;
  List<PeriksaUmumModel> get items => _items;
  List<PeriksaUmumModel> byUserId(String userId) {
    return _items.where((periksa) => periksa.userId == userId).toList();
  }

  
  PeriksaUmumModel findById(String id) {
    return _items.firstWhere((periksa) => periksa.id == id);
  }

  void resetData(String userId){
    if(_items.isEmpty){
      _items = null;
      notifyListeners();
    }else if(_items[0].userId == userId){
      return null;
    }
      _items = null;
      notifyListeners();
  }
  Future<void> fetchPeriksaByUserId (String userId) async{
    final url ='https://project-posyandu.firebaseio.com/periksaUmum.json?orderBy="userId"&equalTo="$userId"';
    try{
      var response = await http.get(url);
      var extractedData = json.decode(response.body)as Map<String,dynamic>;
      if(extractedData == null){
        return;
      }
      final List<PeriksaUmumModel> loadedPeriksa = [];
      extractedData.forEach((periksaId, periksaData){
        loadedPeriksa.add(PeriksaUmumModel(
          id: periksaId,
          userId: periksaData['userId'],
          bb: periksaData['bb'],
          tb: periksaData['tb'],
          imt: periksaData['imt'],
          td: periksaData['td'],
          lila: periksaData['lila'],
          hpmt: periksaData['hpmt'],
          ttd:periksaData['ttd'],
          tindakan: periksaData['tindakan'],
          tglPeriksa: DateTime.parse(periksaData['tglPeriksa']),
        )
        );
      });
      _items = loadedPeriksa;
      notifyListeners();
    }catch(error){
      throw error;
    }
  }

  Future<void> addPeriksa(PeriksaUmumModel periksa) async {
    final url = 'https://project-posyandu.firebaseio.com/periksaUmum.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'userId': periksa.userId,
          'bb': periksa.bb,
          'tb': periksa.tb,
          'imt': periksa.imt,
          'td': periksa.td,
          'lila': periksa.lila,
          'ttd': periksa.ttd,
          'hpmt': periksa.hpmt,
          'tindakan': periksa.tindakan,
          'tglPeriksa': periksa.tglPeriksa.toString()
        }),
      );
      print(response);
      final newPost = PeriksaUmumModel(
          id: json.decode(response.body)['name'],
          userId: periksa.userId,
          bb: periksa.bb,
          tb: periksa.tb,
          imt: periksa.imt,
          td: periksa.td,
          lila: periksa.lila,
          ttd: periksa.ttd,
          hpmt: periksa.hpmt,
          tindakan: periksa.tindakan,
          tglPeriksa: periksa.tglPeriksa
      );

      _items.add(newPost);
      notifyListeners();
    } catch (er) {
      print(er);
      throw er;
    }
  }

  Future<void> updateProduct(String id, PeriksaUmumModel periksaBaru) async {
    final periksaIndex = _items.indexWhere((periksa) => periksa.id == id);
    if (periksaIndex >= 0) {
      final url =
          'https://project-posyandu.firebaseio.com/periksaUmum.json/$id.json';
      await http.patch(url,
          body: json.encode({
            'userId': periksaBaru.userId,
            'bb': periksaBaru.bb,
            'tb': periksaBaru.tb,
            'imt': periksaBaru.imt,
            'td': periksaBaru.td,
            'lila': periksaBaru.lila,
            'ttd': periksaBaru.ttd,
            'hpmt': periksaBaru.hpmt,
            'tindakan': periksaBaru.tindakan,
            'tglPeriksa': periksaBaru.tglPeriksa.toString()
          }));
          _items[periksaIndex] = periksaBaru;
          notifyListeners();
    }else{
      print('....');
    }
  }
  
  Future<void> deletePeriksaById(String periksaId)async{
    final url = 'https://project-posyandu.firebaseio.com/periksaUmum/$periksaId.json';
    final existingPeriksaIndex = _items.indexWhere((periksa)=> periksa.id == periksaId);
    var existingPeriksa = _items[existingPeriksaIndex];
    _items.removeAt(existingPeriksaIndex);
    notifyListeners();
    final res = await http.delete(url);
    if(res.statusCode >= 400){
      _items.insert(existingPeriksaIndex, existingPeriksa);
      notifyListeners();
    }
    existingPeriksa = null;
  }
}

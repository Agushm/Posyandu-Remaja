import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart'as http;

class PeriksaLainModel with ChangeNotifier{
  final String id;
  final String userId;
  final String jenisPeriksa;
  final String ketPeriksa;
  DateTime tglPeriksa;
  PeriksaLainModel({
    @required this.id,
    @required this.userId,
    @required this.jenisPeriksa,
    @required  this.ketPeriksa,
    @required this.tglPeriksa
  });
}

class PemeriksaanLainProvider with ChangeNotifier{
  List<PeriksaLainModel> _items;
  
  List<PeriksaLainModel> get items => _items;
  List<PeriksaLainModel> byUserId(String userId){
    return _items.where((periksa) => periksa.userId == userId).toList();
  }
  PeriksaLainModel findById(String id) {
    return _items.firstWhere((periksa) => periksa.id == id);
  }

  void resetData(String userId){
    if(_items[0].userId == userId){
      return null;
    }else{
      _items = null;
      notifyListeners();
    }
  }

  Future<void> addPeriksa(PeriksaLainModel periksa) async {
    final url = 'https://project-posyandu.firebaseio.com/periksaLain.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'userId': periksa.userId,
          'jenisPeriksa':periksa.jenisPeriksa,
          'ketPeriksa': periksa.ketPeriksa,
          'tglPeriksa': periksa.tglPeriksa.toString(), 
        }),
      );
      final newPost = PeriksaLainModel(
          id: json.decode(response.body)['name'],
          userId: periksa.userId,
          jenisPeriksa: periksa.jenisPeriksa,
          ketPeriksa: periksa.ketPeriksa,
          tglPeriksa: periksa.tglPeriksa
      );

      _items.add(newPost);
      notifyListeners();
    } catch (er) {
      print(er);
      throw er;
    }
  }

  Future<void> updateProduct(String id, PeriksaLainModel periksa) async {
    final periksaIndex = _items.indexWhere((periksa) => periksa.id == id);
    if (periksaIndex >= 0) {
      final url =
          'https://project-posyandu.firebaseio.com/periksaLain.json/$id.json';
      await http.patch(url,
          body: json.encode({
            'userId': periksa.userId,
            'jenisPeriksa':periksa.jenisPeriksa,
            'ketPeriksa': periksa.ketPeriksa,
            'tglPeriksa': periksa.tglPeriksa.toString()
          }));
          _items[periksaIndex] = periksa;
          notifyListeners();
    }else{
      print('....');
    }
  }

  Future<void> fetchPeriksaByUserId (String userId) async{
    final url ='https://project-posyandu.firebaseio.com/periksaLain.json?orderBy="userId"&equalTo="$userId"';
    try{
      var response = await http.get(url);
      var extractedData = json.decode(response.body)as Map<String,dynamic>;
      if(extractedData == null){
        return;
      }
      final List<PeriksaLainModel> loadedPeriksa = [];
      extractedData.forEach((periksaId, periksaData){
        loadedPeriksa.add(PeriksaLainModel(
          id: periksaId,
          userId: periksaData['userId'],
          jenisPeriksa: periksaData['jenisPeriksa'],
          ketPeriksa: periksaData['ketPeriksa'],
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
  Future<void> deletePeriksaById(String periksaId)async{
    final url = 'https://project-posyandu.firebaseio.com/periksaLain/$periksaId.json';
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


import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:posyandu_kuncup_melati/Services/SharedPref.dart';
import 'package:posyandu_kuncup_melati/config/BaseAPI.dart';
import 'package:posyandu_kuncup_melati/config/HeaderHttp.dart';
import 'package:posyandu_kuncup_melati/models/Periksa.dart';

class PeriksaProvider with ChangeNotifier{
  List<Periksa> _items;
  List<Periksa> get items =>_items;

  void destroy(){
    _items = null;
    notifyListeners();
  }

  Future<void> fetchPeriksaByUserID(String userID)async{
    final user = await SharedPref.getUser();
    print(user.userID.toString());
    final uri = BaseAPI.periksa+user.userID;
    
    try{
      final res = await http.get(uri,headers: bearerHeader(null));
    final resData = json.decode(res.body);
    print(resData);
    if(resData["status"] == "OK"){
      List<Periksa> _load = [];
      final d = resData["data"] as List;
      d.forEach((e) {
        _load.add(Periksa.fromJson(e));
      });
      _items = _load;
      notifyListeners();
    }else{
      _items = [];
      notifyListeners();
    }
    }catch(err){
      _items = [];
      notifyListeners();
      print(err);
    }
    
  }
}
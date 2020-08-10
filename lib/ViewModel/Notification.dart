import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:posyandu_kuncup_melati/Services/SharedPref.dart';
import 'package:posyandu_kuncup_melati/config/BaseAPI.dart';
import 'package:posyandu_kuncup_melati/config/HeaderHttp.dart';
import 'package:posyandu_kuncup_melati/models/Notification.dart';
import 'package:http/http.dart' as http;
import 'package:posyandu_kuncup_melati/widgets/Toast.dart';

class NotificationProvider with ChangeNotifier{
  List<Notif> _notif;
  List<Notif> get notif =>_notif;

  Future<void> getNotif()async{
    final token = await SharedPref.getToken();
    final user = await SharedPref.getUser();
    final uri = BaseAPI.notification+'${user.userID}';
    print(uri);
    try{
      final res = await http.get(uri,headers: bearerHeader(token));
      final resData = json.decode(res.body);
      print(resData);
      if(resData["status"] == "OK"){
        final d = resData["data"] as List;
        List<Notif> loaded =[];
        d.forEach((e) {
          loaded.add(Notif.fromJson(e));
        });
        _notif = loaded;
        notifyListeners();
      }else{
        errorToast("Gagal mengambil data notfifikasi");
        _notif = [];
        notifyListeners();
      }
    }catch(err){

        errorToast("Terjadi kesalahan");
      _notif = [];
        notifyListeners();
      print(err); 
    }
  }
}
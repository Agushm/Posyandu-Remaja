import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:posyandu_kuncup_melati/Providers/User.dart';
import 'package:posyandu_kuncup_melati/config/BaseAPI.dart';
import 'package:posyandu_kuncup_melati/config/HeaderHttp.dart';
import 'package:posyandu_kuncup_melati/models/user.dart';

class Anggota with ChangeNotifier {
  final String id;
  final String nama;
  final String userId;
  final String email;
  final String role;
  final DateTime tglLahir;
  String imageUrl = "";
  Anggota(
      {@required this.id,
      @required this.nama,
      @required this.userId,
      @required this.email,
      @required this.role,
      @required this.tglLahir,
      this.imageUrl});
}

class DaftarAnggotaProvider with ChangeNotifier {
  List<UserClass> _items;

  List<UserClass> get items => _items;

  List<UserClass> byRole(String role) {
    return _items.where((anggota) => anggota.role == role).toList();
  }

  UserClass findById(String id) {
    return _items.firstWhere((anggota) => anggota.userID == id);
  }

  Future<void> fetchDaftarAnggota() async {
    var url = BaseAPI.anggota;
    try {
      var res = await http.get(url, headers: bearerHeader(null));
      var resData = json.decode(res.body);
      print(resData);
      if (resData == null) {
        return;
      }

      if (resData["status"] == "OK") {
        final List<UserClass> loadedAnggota = [];
        final d = resData["data"] as List;
        d.forEach((e) {
          loadedAnggota.add(UserClass.fromJson(e));
        });
        _items = loadedAnggota;
        notifyListeners();
      }
      if (resData["status"] == "ERROR") {
        _items = [];
        notifyListeners();
      }
    } catch (error) {
      _items = [];
      notifyListeners();
      throw error;
    }
  }

  // Future<void> fetchListAnggota() async{
  //   final url = 'https://project-posyandu.firebaseio.com/Users.json';
  //   final response = await http.get(url);
  //   final List<UserModel> loadedAnggotas = [];
  //   final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //   if(extractedData == null){
  //     return;
  //   }
  //   extractedData.forEach((anggotaId, anggotaData){
  //     loadedAnggotas.add(
  //       UserModel(
  //         gender: anggotaData['gender'],
  //         keys: anggotaId,
  //         id: anggotaId,
  //         userId: anggotaData['userId'],
  //         email: anggotaData['email'],
  //         nama: anggotaData['nama'],
  //         role: anggotaData['role'],
  //         imageUrl: anggotaData['imageUrl'],
  //         tglLahir: DateTime.parse(anggotaData['tglLahir']),
  //         createdAt: anggotaData['createdAt'],
  //         updatedAt: anggotaData['updatedAt'],
  //         deletedAt: anggotaData['deletedAt'],
  //       ),
  //     );
  //   });
  // _items = loadedAnggotas;
  // notifyListeners();
  // }
}

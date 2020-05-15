
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:posyandu_kuncup_melati/Providers/User.dart';

class Anggota with ChangeNotifier{
  final String id;
  final String nama;
  final String userId;
  final String email;
  final String role;
  final DateTime tglLahir;
  String imageUrl = ""; 
  Anggota({
    @required this.id,
    @required this.nama,
    @required this.userId,
    @required this.email,
    @required this.role,
    @required this.tglLahir,
    this.imageUrl
  });

}

class DaftarAnggotaProvider with ChangeNotifier{
  List<UserModel> _items;

  List<UserModel> get items => _items;

  List<UserModel> byRole(String role){
    return _items.where((anggota) => anggota.role == role).toList();
  }

  UserModel findById(String id){
    return _items.firstWhere((anggota)=>anggota.userId == id);
  }
  Future<void> fetchDaftarAnggota() async{
    var url = 'https://project-posyandu.firebaseio.com/Users.json';
    try{
      var response = await http.get(url);
      var extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      if (extractedData == null){
        return;
      }
      final List<UserModel> loadedAnggota=[];
      extractedData.forEach((anggotaId, anggotaData){
        loadedAnggota.add(UserModel(
          gender: anggotaData['gender'],
          keys: anggotaId,
          id: anggotaId,
          userId: anggotaData['userId'],
          email: anggotaData['email'],
          nama: anggotaData['nama'],
          role: anggotaData['role'],
          imageUrl: anggotaData['imageUrl'],
          tglLahir: DateTime.parse(anggotaData['tglLahir']),
          //createdAt: DateTime.parse(anggotaData['createdAt']),
          
        ));
      });
      _items = loadedAnggota;
      notifyListeners();
    }catch(error){
      throw error;
    }
  }

  Future<void> fetchListAnggota() async{
    final url = 'https://project-posyandu.firebaseio.com/Users.json';
    final response = await http.get(url);
    final List<UserModel> loadedAnggotas = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData == null){
      return;
    }
    extractedData.forEach((anggotaId, anggotaData){
      loadedAnggotas.add(
        UserModel(
          gender: anggotaData['gender'],
          keys: anggotaId,
          id: anggotaId,
          userId: anggotaData['userId'],
          email: anggotaData['email'],
          nama: anggotaData['nama'],
          role: anggotaData['role'],
          imageUrl: anggotaData['imageUrl'],
          tglLahir: DateTime.parse(anggotaData['tglLahir']),
          createdAt: anggotaData['createdAt'],
          updatedAt: anggotaData['updatedAt'],
          deletedAt: anggotaData['deletedAt'],
        ),
      );
    });
  _items = loadedAnggotas;
  notifyListeners();
  }
}
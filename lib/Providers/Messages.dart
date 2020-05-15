import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:posyandu_kuncup_melati/Providers/User.dart';

class PeerData {
  final String userId;
  final String nama;
  final String imageUrl;
  PeerData({
    @required this.userId,
    @required this.nama,
    @required this.imageUrl
  }
  );
}

class Messages with ChangeNotifier{
  final Firestore _db = Firestore.instance;
  List<UserModel> _konsultan;
  List<UserModel> get konsultan => _konsultan;

  UserModel findById(String id){
    return _konsultan.firstWhere((konsultan)=>konsultan.userId == id);
  }

  Future<void> addChatRoom({String userId,String namaUser,String imageUser, String konsultanId})async{
    String groupId = '$userId-$konsultanId';
          await _db.collection('chatRoom').document(groupId).setData({
              'userId':userId,
              'namaUser':namaUser,
              'imageUser': imageUser,
              'konsultanId':konsultanId,
              'createdAt':DateTime.now(),
              'deletedAt':null,
      });
  }

  Future<void> fetchKonsultan() async{
    var url = 'https://project-posyandu.firebaseio.com/Users.json?orderBy="role"&equalTo="konsultan"';

   try{
     var res = await http.get(url);
     var extractedData = json.decode(res.body)as Map<String, dynamic>;
     if(extractedData == null){
       return;
     }
     print(res.body);
     final List<UserModel> loadedKonsultan=[];
     extractedData.forEach((konsultanId,konsultanData){
       loadedKonsultan.add(UserModel(
         id: konsultanId,
         userId: konsultanData['userId'],
         nama: konsultanData['nama'],
         role: konsultanData['role'],
         imageUrl: konsultanData['imageUrl']
       ));
     });
     _konsultan = loadedKonsultan;
     notifyListeners();
   } catch(error){
     throw error;
   }
  }
  Future<void> getRoomList(String userId,String role)async{
    if(role =="konsultan"){
      var snap=  Firestore.instance
                  .collection('chatRoom')
                  .where('konsultanId', isEqualTo: userId)
                  .snapshots();
      print(snap);
    }else{
      var snap=  Firestore.instance
                  .collection('chatRoom')
                  .where('userId', isEqualTo: userId)
                  .snapshots();
      print(snap);
    }
    
  }
}
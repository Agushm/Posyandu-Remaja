import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:posyandu_kuncup_melati/Services/SharedPref.dart';
import 'package:posyandu_kuncup_melati/config/BaseAPI.dart';
import 'package:posyandu_kuncup_melati/config/HeaderHttp.dart';

import 'package:posyandu_kuncup_melati/models/user.dart';
import 'package:http/http.dart' as http;

class ServiceChat {
  static DatabaseReference messegRef(UserClass user, UserClass peer) {
    final postsRef = FirebaseDatabase.instance
        .reference()
        .child('chat_konsultasi')
        .child(user.userID)
        .child('message')
        .child(peer.userID);
    return postsRef;
  }

  static DatabaseReference userRef(UserClass user, UserClass peer, String message) {
    final userRef = FirebaseDatabase.instance
        .reference()
        .child('chat_konsultasi')
        .child(user.nama.trim())
        .child('user')
        .child(peer.nama.trim());
    return userRef;
  }

  static DatabaseReference recentChat(UserClass user) {
    final userRef = FirebaseDatabase.instance
        .reference()
        .child('chat_konsultasi')
        .child(user.userID)
        .child('user');
    return userRef;
  }

  static DatabaseReference isTypingRef(String user, String peer) {
    final userRef = FirebaseDatabase.instance
        .reference()
        .child('chat_private')
        .child(user)
        .child('user')
        .child(peer);
    return userRef;
  }

  static Future sendMessage({UserClass user, UserClass peer}) {
    print("Send message");
    Map<String, dynamic> userData = {
      "username": "kosultan nama",
      "send": "konsultan nama",
      "sendBy": "pengirim nama",
      "timestamp": DateTime.now().toString()
    };

    Map<String, dynamic> messageData = {
      "image": "",
      "load": "",
      "send": "kosultan nama",
      "sendBy": "pengirim nama",
      "message": "Coba Firestore referance",
      "timestamp": DateTime.now().toString()
    };

    Firestore.instance
        .collection('chat_konsultasi')
        .document("userID")
        .collection('user')
        .document("ID konsultan")
        .collection(DateTime.now().toString())
        .add(userData)
        .then((doc) {
      doc.setData(userData);
    });
    Firestore.instance
        .collection('chat_konsultasi')
        .document("userID")
        .collection('message')
        .document("ID Konsultan")
        .collection(DateTime.now().toString())
        .add(messageData)
        .then((doc) {
      doc.setData(messageData);
    });
  }


  static Future sendMessage2(
      {UserClass user,
      UserClass peer,
      String message,
      String image,
      String type}) async {
    final postsRef = FirebaseDatabase.instance
        .reference()
        .child('chat_konsultasi')
        .child("18")
        .child('message')
        .child("12")
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    final postsPeerRef = FirebaseDatabase.instance
        .reference()
        .child('chat_konsultasi')
        .child("12")
        .child('message')
        .child("18")
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    final userRef = FirebaseDatabase.instance
        .reference()
        .child('chat_konsultasi')
        .child("18")
        .child('user')
        .child("12");
    final peerRef = FirebaseDatabase.instance
        .reference()
        .child('chat_konsultasi')
        .child("12")
        .child('user')
        .child("18");

    Map<String, dynamic> messageData = {
      "type": type,
      "image": image,
      "load": "",
      "send": "Agus Konsultan",
      "sendBy": "Agus Anggota",
      "message": message,
      "timestamp": DateTime.now().millisecondsSinceEpoch
    };

    Map<String, dynamic> userData = {
      "username": "Agus Anggota",
      "image": null,
      "send": "Agus Anggota",
      "sendBy": "Agus Nama",
      "new": true,
      "type": type,
      "message": message,
      "timestamp": DateTime.now().millisecondsSinceEpoch
    };

    Map<String, dynamic> peerData = {
      "username": "Agus Konsultan",
      "image": null,
      "send": "Agus Konsultan",
      "sendBy": "Agus Nama",
      "new": true,
      "type": type,
      "message": message,
      "timestamp": DateTime.now().millisecondsSinceEpoch
    };

    await postsRef.set(messageData);
    await postsPeerRef.set(messageData);
    await userRef.update(userData);
    await peerRef.update(peerData);
  }

  static DatabaseReference getRecentChat(UserClass user) {
    final ref = FirebaseDatabase.instance
        .reference()
        .child('chat_private')
        .child(user.nama.trim())
        .child('user');

    return ref;
  }


  static Future<int> getRecentMessageCount(
      UserClass user, UserClass peer) async {
    int message;
    await FirebaseDatabase.instance
        .reference()
        .child('chat_private')
        .child(peer.nama.trim())
        .child('user')
        .child(user.nama.trim())
        .once()
        .then((snapshot) {
      if (snapshot.value == null) {
        return message = 0;
      } else {
        Map data = snapshot.value;
        return message = data["message_count"];
      }
    });
    return message;
  }

  static Future<int> getTotalMessageCount(UserClass user
      ) async {
    int totalMessage = 0;
    await FirebaseDatabase.instance
        .reference()
        .child('chat_private')
        .child(user.nama.trim())
        .child('user')
        .once()
        .then((snapshot) {
      
        Map data = snapshot.value;
        data.forEach((index, value) { 
          int sebelum = totalMessage;
          totalMessage = sebelum+ value["message_count"];
          
        });
      
    });
    return totalMessage;
  }

  static Future<int> getNewMessage() async {
    final user = await SharedPref.getUser();
    int totalMessage = 0;
    await FirebaseDatabase.instance
        .reference()
        .child('chat_private')
        .child(user.nama.trim())
        .child('user')
        .once()
        .then((snapshot) {
        Map data = snapshot.value;
        data.forEach((index, value) { 
          int sebelum = totalMessage;
          int loadData;
          if(value["message_count"] == null){
            loadData= 0;
          }else{
            loadData = value["message_count"];
          }
          totalMessage = sebelum+ loadData;
          
        });
      
    });
    return totalMessage;
  }

  static DatabaseReference getChat(UserClass user, UserClass peer) {
    final ref = FirebaseDatabase.instance
        .reference()
        .child('chat_private')
        .child(user.nama.trim())
        .child('message')
        .child(peer.nama.trim());
    return ref;
  }

  static Future<List<UserClass>> getKonsultan()async{
    final token = await SharedPref.getToken();
    var url = BaseAPI.konsultan;
    try {
      var res = await http.get(url, headers: bearerHeader(token));
      var resData = json.decode(res.body);
      
      if (resData["status"] == "OK") {
        final List<UserClass> loadedAnggota = [];
        final d = resData["data"] as List;
        d.forEach((e) {
          loadedAnggota.add(UserClass.fromJson(e));
        });
        return loadedAnggota; 
      }
      if (resData["status"] == "ERROR") {
        return null;
      }
      return null;
    } catch (err) {
      print(err);
      return null;
    }
  
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final String id;
  final String keys;
  final String userId;
  final String email;
  final String nama;
  final String gender;
  String imageUrl = "";
  String role;
  final DateTime tglLahir;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;
  UserModel(
      {this.id,
      this.keys,
      this.userId,
      this.email,
      this.nama,
      this.role,
      this.gender,
      this.imageUrl,
      this.tglLahir,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});
}

class UserProvider with ChangeNotifier {
  UserModel _user;
  List<UserModel> _konsultan;

  UserModel get user => _user;
  List<UserModel> get konsultan => _konsultan;

  Future<void> fetchUserWithEmail(String email) async {
    var url =
        'https://project-posyandu.firebaseio.com/Users.json?orderBy="email"&equalTo="$email"';

    try {
      var response = await http.get(url);
      var jsonObject = json.decode(response.body);
      if (jsonObject == null) {
        return null;
      }
      var userData = (jsonObject as Map<String, dynamic>).values.toList();
      var keys = (json.decode(response.body) as Map<String, dynamic>);
      //print(keys.keys.toList()[0]);
      print(userData[0]['userId']);
      UserModel loaded = UserModel(
        keys: keys.keys.toList()[0],
        userId: userData[0]['userId'],
        nama: userData[0]['nama'],
        imageUrl: userData[0]['imageUrl'],
        role: userData[0]['role'],
        email: userData[0]['email'],
        gender: userData[0]['gender'],
        tglLahir: DateTime.parse(userData[0]['tglLahir']),
        createdAt: DateTime.parse(userData[0]['createdAt']),
       );
      print(loaded.role + '////////////////////////////////////// Loaded');
      final prefs = await SharedPreferences.getInstance();
      final loginData = json.encode({
        'keys': loaded.keys,
        'email': email,
        'userId': loaded.userId,
        'nama': loaded.nama,
        'imageUrl': loaded.imageUrl,
        'role': loaded.role,
        'gender': loaded.gender,
        'tglLahir': loaded.tglLahir.toString(),
        'createdAt': loaded.createdAt.toString(),
      });
      prefs.setString('loginData', loginData);
      _user = loaded;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<UserModel> fetchUserWithUserId(String userId) async {
    var url =
        'https://project-posyandu.firebaseio.com/Users.json?orderBy="userId"&equalTo="$userId"';

    try {
      var response = await http.get(url);
      var jsonObject = json.decode(response.body);
      if (jsonObject == null) {
        return null;
      }
      var userData = (jsonObject as Map<String, dynamic>).values.toList();
      UserModel dataNe = UserModel(
        userId: userData[0]['userId'],
        nama: userData[0]['nama'],
        imageUrl: userData[0]['imageUrl'],
        role: userData[0]['role'],
        email: userData[0]['email'],
        gender: userData[0]['gender'],
        tglLahir: DateTime.parse(userData[0]['tglLahir']),
        createdAt: DateTime.parse(userData[0]['createdAt']),
      );
      return dataNe;
    } catch (error) {
      throw error;
    }
  }

  Future<void> getUserDataOffline() async {
    final prefs = await SharedPreferences.getInstance();
    final extractedLoginData =
        json.decode(prefs.getString('loginData')) as Map<String, Object>;
    UserModel loadedData = UserModel(
        keys: extractedLoginData['keys'],
        email: extractedLoginData['email'],
        userId: extractedLoginData['userId'],
        nama: extractedLoginData['nama'],
        imageUrl: extractedLoginData['imageUrl'],
        role: extractedLoginData['role'],
        gender: extractedLoginData['gender'],
        tglLahir: DateTime.parse(extractedLoginData['tglLahir']),
        createdAt: DateTime.parse(extractedLoginData['createdAt']),
        );
    print('${extractedLoginData['role']}/////////////////// Offline action');
    _user = loadedData;
    notifyListeners();
  }

  Future<void> fetchKonsultan() async {
    var url =
        'https://project-posyandu.firebaseio.com/Users.json?orderBy="role"&equalTo="konsultan"';

    try {
      var res = await http.get(url);
      var extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<UserModel> loadedKonsultan = [];
      extractedData.forEach((konsultanId, konsultanData) {
        loadedKonsultan.add(UserModel(
            id: konsultanId,
            userId: konsultanData['userId'],
            nama: konsultanData['nama'],
            role: konsultanData['role'],
            imageUrl: konsultanData['imageUrl'],
            email: konsultanData['email'],
            tglLahir: konsultanData['tglLahir'],
            gender: konsultanData['gender'],
            createdAt: konsultanData['createdAt'],
            ));
      });
      _konsultan = loadedKonsultan;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateUserData(String keys, String uploadUrl, String userId,
      String nama, String role, DateTime tglLahir) async {
    final url = 'https://project-posyandu.firebaseio.com/Users/$keys.json';
    try {
      await http.patch(url,
          body: json.encode({
            'nama': nama,
            'tglLahir': tglLahir,
            'imageUrl': uploadUrl,
          }));
      final prefs = await SharedPreferences.getInstance();
      final extractedLoginData =
          json.decode(prefs.getString('loginData')) as Map<String, Object>;

      final updateLoginData = json.encode({
        'keys': keys,
        'nama': nama,
        'imageUrl': uploadUrl,
        'email': extractedLoginData['email'],
        'userId': extractedLoginData['userId'],
        'role': extractedLoginData['role'],
        'gender': extractedLoginData['gender'],
        'tglLahir': extractedLoginData['tglLahir'],
        'createdAt': extractedLoginData['createdAt'],
        'updatedAt': extractedLoginData['updatedAt'],
        'deletedAt': extractedLoginData['deletedAt']
      });
      prefs.setString('loginData', updateLoginData);
    } catch (err) {
      print(err);
      throw err;
    }
  }
}

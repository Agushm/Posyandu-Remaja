import 'dart:convert';
import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  String _email;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get email{
    return _email;
  }
  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(String email, password, String nama, String gender,
      DateTime tglLahir , String role) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBnPZq1WDBDPV2PrLtVNA_habvE4S81xdY";
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      _userId = responseData['localId'];
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      try {
        saveSignup(email, nama, gender, tglLahir, role, responseData['localId']);
      } catch (error) {
        print(error);
      }
     
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> saveSignup(
      String email, String nama, String gender, DateTime tglLahir, String role, String userId) async {
    const url = 'https://project-posyandu.firebaseio.com/Users.json';
    try {
      await http.post(url,
          body: json.encode({
            'email': email,
            'nama': nama,
            'gender': gender,
            'tglLahir': tglLahir.toString(),
            'role': role,
            'userId':userId,
            'imageUrl': " ",
            'createAt':DateTime.now().toString(),
            'updateAt':null.toString(),
            'deletedAt':null.toString(),
          }));
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> loginUser(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBnPZq1WDBDPV2PrLtVNA_habvE4S81xdY';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
     
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _email=email;
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      _updateTokenFCM(_userId);
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token':_token,
        'userId':_userId,
        'email':_email,
        'expiryDate':_expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
      
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<bool> tryAutoLogin()async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String,Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _email = extractedUserData['email'];
    _expiryDate= expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout ()async{
    final prefs = await SharedPreferences.getInstance();
    
    prefs.setString('userData', null);
    
      prefs.setString('loginData', null);
      _token = null;
      _email= null;
      _userId=null;
      _expiryDate=null;
      if(_authTimer != null){
        _authTimer.cancel();
        _authTimer=null;
      }
      notifyListeners();
  }

  void _autoLogout(){
    if(_authTimer != null){
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry),logout);
  }

  FirebaseMessaging _fcm = FirebaseMessaging();
  Future<void> _updateTokenFCM(String userId)async{
    await _fcm.getToken().then((token) async{
      print('token: $token');
      var tokens = Firestore.instance
          .collection('users')
          .document(userId)
          .collection('tokens')
          .document(token);
      await tokens.setData({
        'fcmToken': token,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem
        });
    }).catchError((err) {
      print(err);
      throw err; 
    });
  }
}

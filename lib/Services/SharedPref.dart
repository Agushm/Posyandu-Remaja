import 'dart:convert';

import 'package:posyandu_kuncup_melati/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  static Future<String> getToken()async{
    final prefs = await SharedPreferences.getInstance();
    final loadData = prefs.getString('userData');
    final jsonObject = json.decode(loadData) as Map<String, dynamic>;
    User user = User.fromJson(jsonObject);
    return user.auth;
  }
   static Future<UserClass> getUser()async{
    final prefs = await SharedPreferences.getInstance();
    final loadData = prefs.getString('userData');
    final jsonObject = json.decode(loadData) as Map<String, dynamic>;
    User user = User.fromJson(jsonObject);
    return user.user;
  }
  
  static Future<User> getUserData()async{
    final prefs = await SharedPreferences.getInstance();
    final loadData = prefs.getString('userData');
    if(loadData == null){
      return null;
    }else{
      final jsonObject = json.decode(loadData) as Map<String, dynamic>;
    User user = User.fromJson(jsonObject);
    return user;
    }
    
  }

  static Future<bool> isIntroViewed()async{
    final prefs = await SharedPreferences.getInstance();
    final loadData = prefs.getString('isIntroShow');
    if(loadData != null){
      final jsonObject = json.decode(loadData) as bool;
      return jsonObject;
    }else{
      return false;
    }
    
    
  }
  static Future<void> saveData(String key, String data)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, data);
  }
}
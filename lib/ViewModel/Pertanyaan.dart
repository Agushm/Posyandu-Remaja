import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:posyandu_kuncup_melati/Services/SharedPref.dart';
import 'package:posyandu_kuncup_melati/Utils/dataPertanyaan.dart';
import 'package:posyandu_kuncup_melati/config/BaseAPI.dart';
import 'package:posyandu_kuncup_melati/config/HeaderHttp.dart';
import 'package:posyandu_kuncup_melati/models/pertanyaan.dart';
import 'package:posyandu_kuncup_melati/widgets/Toast.dart';

class PertanyaanProvider with ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  bool selesai = false;

  List<Pertanyaan> _listPertanyaan = DataPertanyaan.dataPertanyaan;
  List<Pertanyaan> get listPertanyaan => _listPertanyaan;

  List<Map<String, dynamic>> _jawaban = [];
  List<Map<String, dynamic>> get jawaban => _jawaban;

  void tambahJawaban(int index, String pertanyaanID, String jawabanID) {
    if (index == (_listPertanyaan.length - 1)) {
      selesai = true;
      notifyListeners();
    }
    _jawaban.insert(index, {
      "pertanyaanID": pertanyaanID,
      "jawabanID": jawabanID,
    });
    _currentIndex = _currentIndex + 1;
    notifyListeners();
  }

  void back(int index) {
    _currentIndex = index - 1;
    _jawaban.removeAt(index - 1);
    notifyListeners();
  }

  String finalJawaban() {
    String finalJawaban = "";
    _jawaban.forEach((e) {
      finalJawaban = finalJawaban + "${e["jawabanID"]}:";
    });
    print(finalJawaban);
    return finalJawaban.substring(0,finalJawaban.length-1);
  }

  Future<void> kirimJawaban(BuildContext context,String periksaID) async {
    final user = await SharedPref.getUser();
    final token = await SharedPref.getToken();
    final uri = BaseAPI.simpanJawaban;

    try {
      final res = await http.post(uri,
          headers: bearerHeader(token),
          body: json.encode({
            "user_ID": user.userID,
            "periksa_ID": periksaID,
            "jawaban": finalJawaban()
          }));
      final resData = json.decode(res.body);
      print(resData);
      if (resData["status"] == "OK") {
        Fluttertoast.showToast(msg: resData["messages"]);
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
            msg: "Gagal menambah data periksa", backgroundColor: Colors.red);
      }
    } catch (err) {
      errorToast("Terjadi kesalahan");
      print(err);
    }
  }
}

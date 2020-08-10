import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:posyandu_kuncup_melati/ViewModel/CustomMenu.dart';
import 'package:provider/provider.dart';

class CustomMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Custom Menu"),
      ),
      body: Consumer<CustomMenu>(
        builder: (context, prov, _) {
          if (prov.error && prov.dataPeriksa != null) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Anda belum mengisi kuisoner pemeriksaan terbaru",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _buildData("Tanggal periksa",
                    tanggal(DateTime.parse(prov.dataPeriksa.tglPeriksa))),
                _buildData("Tinggi Badan", prov.dataPeriksa.tb),
                _buildData("Berat Badan", prov.dataPeriksa.bb),
                _buildData("Indeks Masa Tubuh", prov.dataPeriksa.imt),
                _buildData("Kategori IMT", prov.dataPeriksa.kategoriImt),
              ],
            ));
          }
          if (prov.dataPeriksa == null && prov.dataJawaban == null) {
            prov.getSaranCustom();
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                _buildData("Tanggal periksa",
                    tanggal(DateTime.parse(prov.dataPeriksa.tglPeriksa))),
                _buildData("Aktifitas", prov.dataAktifitas.kode),
                _buildData("BMR", "${prov.dataJawaban.bmr} kkal"),
                _buildData("Kebutuhan kalori perhari",
                    "${prov.dataJawaban.kalori} kkal"),
                prov.dataPeriksa.kategoriImt == "normal"
                    ? Container()
                    : prov.dataPeriksa.kategoriImt == "kegemukan" ||
                            prov.dataPeriksa.kategoriImt == "obesitas"
                        ? _buildData("Saran penurunan",
                            "${prov.dataJawaban.kalori - 500} - ${prov.dataJawaban.kalori - 300} kkal")
                        : _buildData("Saran kenaikan",
                            "${prov.dataJawaban.kalori + 300} - ${prov.dataJawaban.kalori + 500} kkal"),
                 _buildData("Minimal Menu Kalori",
                    "${prov.minKalori} kkal"),
                    _buildData("Maksimal Menu Kalori",
                    "${prov.maxKalori} kkal"),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _buildData(String title, String content) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          content,
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

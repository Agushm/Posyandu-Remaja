import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/ViewModel/SaranMenuProvider.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:posyandu_kuncup_melati/models/menu.dart';
import 'package:provider/provider.dart';

class SaranMenuScreen extends StatefulWidget {
  @override
  _SaranMenuScreenState createState() => _SaranMenuScreenState();
}

class _SaranMenuScreenState extends State<SaranMenuScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Saran Menu"),
      ),
      body: Consumer<SaranMenuProvider>(
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
          if (prov.dataPeriksa == null && prov.pokok == null) {
            prov.getSaranMakanan();
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
                SizedBox(
                  height: 20,
                ),
                _buildMenuMakanan("Menu Sarapan", prov.sarapan),
                _buildMenuMakanan("Menu Siang", prov.siang),
                _buildMenuMakanan("Menu Malam", prov.malam),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: _buildData("TOTAL", "${prov.totalKaloriMakan} kkal"),
                ),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          );
        },
      ),
    );
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

  Widget _buildListItemMenuMakan(
      String jenis, String namaMenu, String jmlKalori) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            jenis,
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                namaMenu,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                jmlKalori,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuMakanan(String waktuMakan, List<Menu> menu) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Text(
              waktuMakan,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
                bottom: BorderSide(color: Colors.black),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: menu
                  .map(
                    (e) => _buildListItemMenuMakan(
                        e.jenis, e.namaMakanan, "${e.jmlKalori} kkal"),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

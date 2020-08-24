import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:posyandu_kuncup_melati/ViewModel/CustomMenu.dart';
import 'package:posyandu_kuncup_melati/models/menu.dart';
import 'package:provider/provider.dart';
import 'MenuPickerScreen.dart';

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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            "${(prov.dataJawaban.kalori - 500).toStringAsFixed(2)} - ${prov.dataJawaban.kalori - 300} kkal")
                        : _buildData("Saran kenaikan",
                            "${prov.dataJawaban.kalori + 300} - ${prov.dataJawaban.kalori + 500} kkal"),
                SizedBox(
                  height: 20,
                ),
                menuSarapan(),
                SizedBox(
                  height: 10,
                ),
                menuSiang(),
                SizedBox(
                  height: 10,
                ),
                menuMalam(),
                SizedBox(
                  height: 20,
                ),
                _buildPesan(),
                _buildData("Total Kalori", prov.totalKalori.toString()),
                SizedBox(
                  height: 100,
                ),
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

Widget _buildDataMenu(String title, String content) {
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

Widget menuSarapan() {
  return Consumer<CustomMenu>(
    builder: (context, prov, _) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              "Sarapan",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            pilihanMenu(
                menu: "sarapan",
                prov: prov.sarapan,
                jenis: "Pokok",
                context: context),
            pilihanMenu(
                menu: "sarapan",
                prov: prov.sarapan,
                jenis: "Sayur",
                context: context),
            pilihanMenu(
                menu: "sarapan",
                prov: prov.sarapan,
                jenis: "Lauk",
                context: context),
            pilihanMenu(
                menu: "sarapan",
                prov: prov.sarapan,
                jenis: "Buah",
                context: context),
            pilihanMenu(
                menu: "sarapan",
                prov: prov.sarapan,
                jenis: "Minuman",
                context: context),
            pilihanMenu(
                menu: "sarapan",
                prov: prov.sarapan,
                jenis: "Selingan",
                context: context),
            SizedBox(
                  height: 10,
                ),
            _buildData("Total Kalori", prov.totalSarapan.toString())
          ],
        ),
      );
    },
  );
}

Widget menuSiang() {
  return Consumer<CustomMenu>(
    builder: (context, prov, _) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              "Makan Siang",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            pilihanMenu(
                menu: "siang",
                prov: prov.menuSiang,
                jenis: "Pokok",
                context: context),
            pilihanMenu(
                menu: "siang",
                prov: prov.menuSiang,
                jenis: "Sayur",
                context: context),
            pilihanMenu(
                menu: "siang",
                prov: prov.menuSiang,
                jenis: "Lauk",
                context: context),
            pilihanMenu(
                menu: "siang",
                prov: prov.menuSiang,
                jenis: "Buah",
                context: context),
            pilihanMenu(
                menu: "siang",
                prov: prov.menuSiang,
                jenis: "Minuman",
                context: context),
            pilihanMenu(
                menu: "siang",
                prov: prov.menuSiang,
                jenis: "Selingan",
                context: context),
            SizedBox(
                  height: 10,
                ),
            _buildData("Total Kalori", prov.totalSiang.toString())
          ],
        ),
      );
    },
  );
}

Widget menuMalam() {
  return Consumer<CustomMenu>(
    builder: (context, prov, _) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              "Makan Malam",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            pilihanMenu(
                menu: "malam",
                prov: prov.menuMalam,
                jenis: "Pokok",
                context: context),
            pilihanMenu(
                menu: "malam",
                prov: prov.menuMalam,
                jenis: "Sayur",
                context: context),
            pilihanMenu(
                menu: "malam",
                prov: prov.menuMalam,
                jenis: "Lauk",
                context: context),
            pilihanMenu(
                menu: "malam",
                prov: prov.menuMalam,
                jenis: "Buah",
                context: context),
            pilihanMenu(
                menu: "malam",
                prov: prov.menuMalam,
                jenis: "Minuman",
                context: context),
            pilihanMenu(
                menu: "malam",
                prov: prov.menuMalam,
                jenis: "Selingan",
                context: context),
            SizedBox(
                  height: 10,
                ),
            
            _buildData("Total Kalori", prov.totalMalam.toString())
          ],
        ),
      );
    },
  );
}

Widget pilihanMenu(
    {String menu, Map<String, Menu> prov, String jenis, BuildContext context}) {
  return Column(
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
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MenuPickerScreen(
                            jenis: jenis.toLowerCase(),
                            menu: menu,
                          )));
            },
            child: prov[jenis.toLowerCase()].namaMakanan == null
                ? Text(
                    "Pilih Menu",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  )
                : Text(prov[jenis.toLowerCase()].namaMakanan),
          ),
          prov[jenis.toLowerCase()].namaMakanan == null
              ? Container()
              : Text("${prov[jenis.toLowerCase()].jmlKalori} kkal")
        ],
      ),
    ],
  );
}

Widget _buildPesan(){
  return Consumer<CustomMenu>(
    builder: (context,prov,_){
      double saranMin;
      if(prov.dataPeriksa.kategoriImt == "kurus"){
        saranMin = prov.dataJawaban.kalori +300;
      }
      if(prov.dataPeriksa.kategoriImt == "kegemukan" || prov.dataPeriksa.kategoriImt == "obesitas" ){
        saranMin = prov.dataJawaban.kalori - 500;
      }
      if(prov.totalKalori < saranMin){
        return Container(
          margin: EdgeInsets.symmetric(horizontal:20,vertical: 10),
          child: Text("Anda harus mengisi menu total kalori seperti saran minimal",style: TextStyle(
            fontStyle: FontStyle.italic
          ),));
      }
      if(prov.totalKalori > prov.dataJawaban.kalori){
        return Container(
          margin: EdgeInsets.symmetric(horizontal:20,vertical: 10),
          child: Text("Anda anda memasukan menu melebihi kebutuhan kalori perhari"));
      }
      return Container();
    },
    );
}
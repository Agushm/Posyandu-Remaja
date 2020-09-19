import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/ViewModel/SaranMenuProvider.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:posyandu_kuncup_melati/models/menu.dart';
import 'package:posyandu_kuncup_melati/widgets/LoadingCenter.dart';
import 'package:provider/provider.dart';

class SaranMenuScreen extends StatefulWidget {
  @override
  _SaranMenuScreenState createState() => _SaranMenuScreenState();
}

class _SaranMenuScreenState extends State<SaranMenuScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  getSaranMenu() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<SaranMenuProvider>(context, listen: false)
        .getSaranMakanan();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Saran Menu"),
      ),
      body: _isLoading
          ? LoadingCenter()
          : Consumer<SaranMenuProvider>(
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
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
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
                      buildQuiz(),
                      SizedBox(
                        height: 20,
                      ),
                      _buildMenuMakanan("Menu Sarapan", prov.sarapan),
                      _buildMenuMakanan("Menu Siang", prov.siang),
                      _buildMenuMakanan("Menu Malam", prov.malam),
                      _buildPesan(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: _buildData(
                            "TOTAL", "${prov.totalKaloriMakan} kkal"),
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

  bool showJawaban = false;
  Widget buildQuiz() {
    return Consumer<SaranMenuProvider>(
      builder: (context, prov, _) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Jawaban Quiz Aktifitas",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        showJawaban = !showJawaban;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        showJawaban == false ? "Lihat" : "Tutup",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              showJawaban == false
                  ? Container()
                  : ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: prov.quiz.length,
                      itemBuilder: (context, i) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                prov.quiz[i]["pertanyaan"],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                prov
                                    .getJawabanByKode(
                                        prov.quiz[i]["jawaban"], i)
                                    .isiPilihan,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPesan() {
    return Consumer<SaranMenuProvider>(
      builder: (context, prov, _) {
        double saranMin;
        double saranMax;
        if (prov.dataPeriksa.kategoriImt == "normal") {
          saranMin = prov.dataJawaban.kalori;
          saranMax = prov.dataJawaban.kalori;
        }
        if (prov.dataPeriksa.kategoriImt == "kurus") {
          saranMin = prov.dataJawaban.kalori + 300;
          saranMax = prov.dataJawaban.kalori + 500;
        }
        if (prov.dataPeriksa.kategoriImt == "kegemukan" ||
            prov.dataPeriksa.kategoriImt == "obesitas") {
          saranMin = prov.dataJawaban.kalori - 500;
          saranMax = prov.dataJawaban.kalori - 300;
        }
        if (double.parse(prov.totalKaloriMakan) < saranMin) {
          return Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Anda dapat menambahkan minuman atau makanan selingan untuk menutup kekurangan kalori",
                style: TextStyle(fontStyle: FontStyle.italic),
              ));
        }
        if (double.parse(prov.totalKaloriMakan) > saranMax) {
          return Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                  "Anda dapat mengurangi atau menghilangkan makanan selingan agar pas dengan saran kebutuhan kalori",
                  style: TextStyle(fontStyle: FontStyle.italic)));
        }
        return Container();
      },
    );
  }
}

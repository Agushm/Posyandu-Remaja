import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/ViewModel/Pertanyaan.dart';
import 'package:posyandu_kuncup_melati/models/pertanyaan.dart';
import 'package:provider/provider.dart';

class PertanyaanScreen extends StatefulWidget {
  final String periksaID;
  PertanyaanScreen({
    this.periksaID
  });
  @override
  _PertanyaanScreenState createState() => _PertanyaanScreenState();
}

class _PertanyaanScreenState extends State<PertanyaanScreen> {
  bool selesai = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Pertanyaan"),
      ),
      body:Consumer<PertanyaanProvider>(
        builder: (context, prov, _) {
          if (prov.selesai) {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Container()),
                Center(child: Text("Terimakasih telah menjawab pertanyaan",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),)),
                Expanded(child: Container(),),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal:20,vertical:20),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    color: ColorBase.pink,
                    padding: EdgeInsets.all(15),
                    onPressed: (){
                      prov.kirimJawaban(
                        context,
                        widget.periksaID
                      );
                  }, child: Text("Simpan Jawaban",style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),)),
                )
              ],
            ));
          } else if(prov.currentIndex <= prov.listPertanyaan.length) {
            Pertanyaan p = prov.listPertanyaan[prov.currentIndex];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                prov.currentIndex == 0
                    ? Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(20)),
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Text(
                          "Jawab pertanyaan berikut untuk melengkapi data pemeriksaan dan mendapatkan saran menu makanan yang sesuai dengan kebutuhan kalori anda.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    : Container(),
                Expanded(child: Container()),
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      p.isiPertanyaan,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 40, top: 20),
                    primary: false,
                    itemCount: p.pilihan.length,
                    itemBuilder: (context, i) {
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(15),
                          color: ColorBase.pink,
                          onPressed: () {
                            prov.tambahJawaban(prov.currentIndex,
                                p.pertanyaanId, p.pilihan[i].pilihanId);
                            print(prov.jawaban);
                          },
                          child: Text(
                            p.pilihan[i].isiPilihan,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }),
                Expanded(child: Container()),
                prov.currentIndex == 0
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(bottom: 20, left: 20),
                        child: FlatButton(
                            onPressed: () {
                              prov.back(prov.currentIndex);
                            },
                            child: Text("Kembali",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                      )
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}

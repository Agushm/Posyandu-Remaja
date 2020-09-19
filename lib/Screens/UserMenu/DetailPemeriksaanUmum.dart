import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Constants/FontFamily.dart';
import 'package:posyandu_kuncup_melati/Screens/SaranMenu/SaranMenuScreen.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:posyandu_kuncup_melati/models/Periksa.dart';

class DetailPemeriksaanUmum extends StatelessWidget {
  final Periksa periksa;
  DetailPemeriksaanUmum({
    @required this.periksa,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back), onPressed: ()=>Navigator.pop(context),),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Detail Pemeriksaan",style: TextStyle(color: Colors.black),),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10,horizontal:20),
                  child: Text(
                    tanggal(DateTime.parse(periksa.tglPeriksa)),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: FontsFamily.productSans,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin:EdgeInsets.only(right:20),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: periksa.kategoriImt == "normal"?Colors.blue:Colors.red,
                  ),
                  child: Text(periksa.kategoriImt[0].toUpperCase()+periksa.kategoriImt.substring(1),style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left:20,right: 20,bottom:20),
              child: Text(
                "Petugas : ${periksa.petugas.nama}",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: FontsFamily.productSans,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.only(bottom:20),
              decoration: BoxDecoration(
                  color: ColorBase.blue,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: <Widget>[
                  _buildDetailPeriksa(
                    title: "Berat Badan",
                    content: periksa.bb.toString()+" kg",
                  ),
                 
                  _buildDetailPeriksa(
                    title: "Tinggi Badan",
                    content: periksa.tb.toString()+" cm",
                  ),
                 
                  _buildDetailPeriksa(
                    title: "Index Massa Tubuh",
                    content: periksa.imt.toString(),
                  ),
                  
                  _buildDetailPeriksa(
                    title: "Kategori Berat Badan",
                    content: periksa.kategoriImt.toString(),
                  ),
                  
                  _buildDetailPeriksa(
                    title: "Tekanan Darah",
                    content: periksa.td.toString(),
                  ),
                  
                  periksa.lila.toString() == "null"?Container():_buildDetailPeriksa(
                    title: "Lingkar Lengan Atas",
                    content: periksa.lila.toString(),
                  ),
                 
                  periksa.ttd.toString() == "null"?Container():_buildDetailPeriksa(
                    title: "Tablet Tambah Darah",
                    content: periksa.ttd.toString(),
                  ),
                
                  periksa.hpmt.toString() == "null"?Container():_buildDetailPeriksa(
                    title: "Hari Pertama Menstruasi",
                    content: periksa.hpmt.toString(),
                  ),
                  
                  _buildDetailPeriksa(
                    title: "Tindakan",
                    content: periksa.tindakan.toString()*100,
                  ),
                ],
              ),
            ),
            SizedBox(height: 100,),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: double.infinity,
        child: FlatButton(
          
          padding: EdgeInsets.all(20),
          color: ColorBase.pink,
          onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>SaranMenuScreen()));
        }, child: Text("SARAN MENU",style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: FontsFamily.productSans
        ),)),
      ),
    );
  }

  _buildDetailPeriksa({String title, String content}) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: FontsFamily.productSans,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Container(),
              ),
              Container(
                width: 120,
                alignment: Alignment.centerRight,
                child: Text(
                  content,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: FontsFamily.productSans,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
        Divider(
          color: Colors.white,
        )
      ],
    );
  }
}

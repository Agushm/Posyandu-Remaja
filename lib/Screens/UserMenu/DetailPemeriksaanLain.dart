import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Constants/FontFamily.dart';
import 'package:posyandu_kuncup_melati/Providers/PemeriksaanLain.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';

class DetailPemeriksaanLain extends StatelessWidget {
  final PeriksaLainModel periksa;
  DetailPemeriksaanLain({
    @required this.periksa,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorBase.pink,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top:40.0),
          child: Column(
            children: <Widget>[
               Container(
                 margin: EdgeInsets.symmetric(vertical:20),
                 child: Text(
                  formatTgl(periksa.tglPeriksa),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: FontsFamily.productSans,
                      fontWeight: FontWeight.bold),
              ),
               ),
              Container(
                margin: EdgeInsets.symmetric(horizontal:20),
                decoration: BoxDecoration(
                  color: ColorBase.blue,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: <Widget>[
                   
                    _buildDetailPeriksa(
                      title: "Jenis Pemeriksaan",
                      content: periksa.jenisPeriksa.toString(),
                    ),
                    _buildDetailPeriksa(
                      title: "Keterangan Pemeriksaan",
                      content: periksa.ketPeriksa.toString(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildDetailPeriksa({String title, String content}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: FontsFamily.productSans,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
          margin: EdgeInsets.symmetric(vertical:10),

            child: Text(
              content,
              textAlign: TextAlign.justify,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: FontsFamily.productSans,
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}

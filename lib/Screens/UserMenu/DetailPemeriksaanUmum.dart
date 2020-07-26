import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Constants/FontFamily.dart';
import 'package:posyandu_kuncup_melati/Providers/PemeriksaanUmum.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';

class DetailPemeriksaanUmum extends StatelessWidget {
  final PeriksaUmumModel periksa;
  DetailPemeriksaanUmum({
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
                      title: "Berat Badan",
                      content: periksa.bb.toString(),
                    ),
                    _buildDetailPeriksa(
                      title: "Tinggi Badan",
                      content: periksa.tb.toString(),
                    ),
                    _buildDetailPeriksa(
                      title: "Index Massa Tubuh",
                      content: periksa.imt.toString(),
                    ),
                    _buildDetailPeriksa(
                      title: "Tekanan Darah",
                      content: periksa.td.toString(),
                    ),
                    _buildDetailPeriksa(
                      title: "Lingkar Lengan Atas",
                      content: periksa.lila.toString(),
                    ),
                    _buildDetailPeriksa(
                      title: "Tablet Tambah Darah",
                      content: periksa.ttd.toString(),
                    ),
                    _buildDetailPeriksa(
                      title: "Hari Pertama Menstruasi",
                      content: periksa.hpmt.toString(),
                    ),
                    _buildDetailPeriksa(
                      title: "Tindakan",
                      content: periksa.tindakan.toString(),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: FontsFamily.productSans,
                fontWeight: FontWeight.bold),
          ),
          Text(
            content,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: FontsFamily.productSans,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}

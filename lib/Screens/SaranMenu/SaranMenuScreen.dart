import 'package:flutter/material.dart';

class SaranMenuScreen extends StatefulWidget {
  @override
  _SaranMenuScreenState createState() => _SaranMenuScreenState();
}

class _SaranMenuScreenState extends State<SaranMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Saran Menu"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            _buildData("Tanggal periksa", "02 Agustus 2020"),
            _buildData("Kebutuhan kalori perhari", "2000 kkal"),
            _buildData("Saran penurunan", "1500 - 1700 kkal"),
            SizedBox(
              height: 20,
            ),
            _buildMenuMakanan("Menu Sarapan"),
            _buildMenuMakanan("Menu Siang"),
            _buildMenuMakanan("Menu Malam"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _buildData("TOTAL","1500 kkal"),
            ),
            SizedBox(height: 100,)
          ],
        ),
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

  Widget _buildListItemMenuMakan(String jenis,String namaMenu, String jmlKalori){
    return Container(
      margin: EdgeInsets.only(bottom:20),
      child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      jenis,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
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

  Widget _buildMenuMakanan(String waktuMakan){
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
                  children: <Widget>[
                    _buildListItemMenuMakan("Makanan Pokok", "Bubur Ayam", "200 kkal"),
                    _buildListItemMenuMakan("Lauk", "Tempe", "80 kkal"),
                    _buildListItemMenuMakan("Buah", "Pisang Raja", "126 kkal"),
                    _buildListItemMenuMakan("Minuman", "Teh Hangat", "80 kkal"),
                  ],
                ),
              )
        ],
      ),
    );
           
  }
}

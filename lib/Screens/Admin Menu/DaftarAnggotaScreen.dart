import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Screens/Admin%20Menu/components/ListAnggota.dart';

class DaftarAnggotaScreen extends StatefulWidget {
  @override
  _DaftarAnggotaScreenState createState() => _DaftarAnggotaScreenState();
}

class _DaftarAnggotaScreenState extends State<DaftarAnggotaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Anggota"),
        actions: <Widget>[
        
        ],
      ),
      body: ListAnggota(),
      floatingActionButton: FloatingActionButton(onPressed: (){},child: Icon(Icons.add),),
    );
  }
}
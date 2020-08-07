import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Screens/AdminMenu/AdminEditAnggota.dart';
import 'package:posyandu_kuncup_melati/Screens/AdminMenu/components/ListAnggota.dart';

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
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminEditAnggota(
                            userData: null,
                          )),
                );
      },child: Icon(Icons.add),),
    );
  }
}
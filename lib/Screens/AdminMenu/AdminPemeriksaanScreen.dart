import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Screens/AdminMenu/components/PemeriksaanUmum.dart';
import 'package:posyandu_kuncup_melati/models/user.dart';

class AdminPemeriksaanScreen extends StatefulWidget {
  final UserClass user;
  AdminPemeriksaanScreen({
    this.user
  });
  @override
  _AdminPemeriksaanScreenState createState() => _AdminPemeriksaanScreenState();
}

class _AdminPemeriksaanScreenState extends State<AdminPemeriksaanScreen> {
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(widget.user.nama),
          bottom: TabBar(
            indicatorColor: ColorBase.orange,
            tabs: <Widget>[
              Tab(
                
                text: 'Daftar Pemeriksaan',
              ),
              // Tab(
              //   icon: Icon(Icons.view_list),
              //   text: 'Pemeriksaan Lain',
              // ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            PemeriksaanUmum(user: widget.user,), 
            //PemeriksaanLain(user: widget.user,)
            ],
        ),
      ),
    );
  }
}
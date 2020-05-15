import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Providers/User.dart';
import 'package:posyandu_kuncup_melati/Screens/Admin%20Menu/components/PemeriksaanLain.dart';
import 'package:posyandu_kuncup_melati/Screens/Admin%20Menu/components/PemeriksaanUmum.dart';

class AdminPemeriksaanScreen extends StatefulWidget {
  final UserModel user;
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
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.user.nama),
          bottom: TabBar(
            indicatorColor: ColorBase.orange,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.list),
                text: 'Pemeriksaan Umum',
              ),
              Tab(
                icon: Icon(Icons.view_list),
                text: 'Pemeriksaan Lain',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            PemeriksaanUmum(user: widget.user,), 
            PemeriksaanLain(user: widget.user,)],
        ),
      ),
    );
  }
}
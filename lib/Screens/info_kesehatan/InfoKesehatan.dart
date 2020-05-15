import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Constants/Dictionary.dart';
import 'package:posyandu_kuncup_melati/Constants/FontFamily.dart';
import 'package:posyandu_kuncup_melati/Screens/home/components/InfoKesehatanScreen.dart';
class  InfoKesehatan extends StatefulWidget {
  final String materi;

  InfoKesehatan({this.materi});

  @override
  _InfoKesehatanState createState() => _InfoKesehatanState();
}

class _InfoKesehatanState extends State<InfoKesehatan> with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    new Tab(
      child: Text(
        Dictionary.informasiRemaja,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontFamily: FontsFamily.productSans,
            fontSize: 13.0),
      ),
    ),
    new Tab(
        child: Text(
      Dictionary.informasiUmum,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontFamily: FontsFamily.productSans,
          fontSize: 13.0),
    )),
  ];
  TabController tabController;

  @override
  void initState() {
   // AnalyticsHelper.setCurrentScreen(Analytics.InfoKesehatan);

    super.initState();
    tabController = new TabController(vsync: this, length: myTabs.length);
    if (widget.materi == Dictionary.informasiRemaja) {
      tabController.animateTo(0);
    } else if (widget.materi == Dictionary.informasiUmum) {
      tabController.animateTo(1);
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            Dictionary.information,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: FontsFamily.productSans,
                fontSize: 17.0),
          ),
          bottom: TabBar(
            indicatorColor: ColorBase.orange,
            indicatorWeight: 2.8,
            tabs: myTabs,
            controller: tabController,
            onTap: (index) {
              if (index == 0) {
                //AnalyticsHelper.setLogEvent(Analytics.tappedInfoKesehatanJabar);
              } else if (index == 1) {
                //AnalyticsHelper.setLogEvent(Analytics.tappedInfoKesehatanNational);
              } 
            },
          ),
        ),
        body: Container(
          child: TabBarView(
            controller: tabController,
            children: <Widget>[
              InfoKesehatanScreen(kesehatan: Dictionary.informasiRemaja),
              InfoKesehatanScreen(kesehatan: Dictionary.informasiUmum),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Node_Providers/Notification.dart';
import 'package:posyandu_kuncup_melati/Screens/Pertanyaan/IndexPertanyaan.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:posyandu_kuncup_melati/widgets/LoadingCenter.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Pemberitahuan"),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, prov, _) {
          if (prov.notif == null) {
            prov.getNotif();
            return LoadingCenter();
          }
          return prov.notif.isEmpty
              ? Center(
                  child: Text("Belum ada data"),
                )
              : RefreshIndicator(
                  onRefresh: prov.getNotif,
                  child: ListView.builder(
                      itemCount: prov.notif.length,
                      itemBuilder: (context, i) {
                        final d = prov.notif[i];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal:20,vertical: 5),
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
                              child: Text(
                                tanggal(d.createdAt),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                if(d.periksa.jawabanId == null){
                                  Navigator.push(context,MaterialPageRoute(builder: (_)=>PertanyaanScreen(
                                    periksaID:d.periksaId.toString(),
                                  )));
                                }
                              },
                                                          child: Stack(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(d.judul,style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                        )),
                                        SizedBox(height: 5,),
                                        Text(d.pesan)
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 20,
                                                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: d.periksa.kategoriImt == "normal"?Colors.green:Colors.red,
                                      ),
                                      child: Text(d.periksa.kategoriImt,style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,

                                        fontWeight: FontWeight.bold
                                      ),),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }));
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/FontFamily.dart';
import 'package:posyandu_kuncup_melati/Constants/TextStyle.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';

class ItemPesanTerbaru extends StatelessWidget {
  final String roomId;
  ItemPesanTerbaru(this.roomId);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('messages')
            .document(roomId)
            .collection(roomId)
            .orderBy('timestamp', descending: true)
            .limit(20)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('...');

            default:
              final data = snapshot.data.documents;
              if(data.length == 0){
                return Text("Silahkan mulai konsultasi",style: TextStyle(
                                            color:Colors.black,
                                            fontFamily: FontsFamily.productSans,
                                            
                                          ),);
              }
              return data[0]['type'].toString() == "0" ?Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                    
                children: <Widget>[
                  Text(data[0]['content'],style: TextStyle(
                                                color:Colors.black,
                                                fontFamily: FontsFamily.productSans,
                                                
                                              ),),
                  Text(timeUntil(int.parse(data[0]['timestamp'])),style: ConsTextStyle.timeAgoLastChat,),
                ],
              ):Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.picture_in_picture),
                          Text("Menggirim Gambar",style: TextStyle(
                                            color:Colors.black,
                                            fontFamily: FontsFamily.productSans,
                                            
                                          ),),
                      
                        ],

                      ),
                      Text(timeUntil(int.parse(data[0]['timestamp'])),style: ConsTextStyle.timeAgoLastChat),
                    ],
                  ),
                  
                //Text(unixTimeStampToTimeAgo(data[0]['timestamp'])),
                ],
              );
          }
        });
  }
}

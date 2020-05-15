import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Constants/FontFamily.dart';
import 'package:posyandu_kuncup_melati/Providers/Messages.dart';
import 'package:posyandu_kuncup_melati/Providers/User.dart';
import 'package:posyandu_kuncup_melati/Screens/messages/MessagesScreen.dart';
import 'package:posyandu_kuncup_melati/Screens/messages/components/ItemPesanTerbaru.dart';
import 'package:posyandu_kuncup_melati/Screens/messages/newMessageScreen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ListRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, Messages>(
      builder: (context, user, messages, _) => StreamBuilder<QuerySnapshot>(
          stream: user.user.role == 'konsultan'
              ? Firestore.instance
                  .collection('chatRoom')
                  .where('konsultanId', isEqualTo: user.user.userId)
                  .snapshots()
              : Firestore.instance
                  .collection('chatRoom')
                  .where('userId', isEqualTo: user.user.userId)
                  .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (messages.konsultan == null) {
                  return _buildShimmer();
                }
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return _buildShimmer();
              default:
                
                return ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    final konsultan =
                        messages.findById(document['konsultanId']);
                    String groupId ='${document['userId']}-${document['konsultanId']}';
                    
                    return GestureDetector(
                      onTap: () {
                        if (user.user.role == "konsultan") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MessagesScreen(
                                        groupID: groupId,
                                        // loginId: user.user.userId,
                                        // peerData: peerKonsultan,
                                      )));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MessagesScreen(
                                        groupID: groupId,
                                        // loginId: user.user.userId,
                                        // peerData: peerUser,
                                      )));
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom:20),
                        padding: EdgeInsets.symmetric(horizontal:20),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                (user.user.role == 'konsultan')
                                    ? document['imageUser'] == ' '
                                        ? CircleAvatar(

                                            radius: 35,
                                            backgroundColor: Colors.lightBlue,
                                            child: Text(
                                              document['namaUser'][0],
                                              style:
                                                  TextStyle(color: Colors.white),
                                            ),
                                          )
                                        : CircleAvatar(
                                            radius: 35,
                                            backgroundImage:
                                                NetworkImage(konsultan.imageUrl),
                                          )
                                    : konsultan.imageUrl == ' '
                                        ? CircleAvatar(
                                            radius: 35,
                                            backgroundColor: Colors.lightBlue,
                                            child: Text(
                                              konsultan.nama[0],
                                              style:
                                                  TextStyle(color: Colors.white),
                                            ),
                                          )
                                        : CircleAvatar(
                                            radius: 35,
                                            backgroundImage:
                                                NetworkImage(konsultan.imageUrl),
                                          ),
                                Container(
                                  margin: EdgeInsets.only(left:20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      user.user.role == 'konsultan'
                                          ? Text(document['namaUser'],style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: FontsFamily.productSans,
                                            fontSize: 16,
                                          ),)
                                          : Text(konsultan.nama,style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: FontsFamily.productSans,
                                            fontSize: 16,
                                          ),),
                                      ItemPesanTerbaru(groupId),
                                      
                                    ],
                                    
                                  ),
                                ),
                                Container(
                                      color: Colors.grey,
                                      height: 2,
                                    ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
            }
          }),
    );
  }
  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      //enabled: _enabled,
      child: Column(
        children: <int>[0, 1, 2]
            .map((_) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 30),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(right: 20),
                              height: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(top: 10, right: 40),
                              height: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 10, right: 20),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

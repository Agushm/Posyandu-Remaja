import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Providers/Messages.dart';
import 'package:posyandu_kuncup_melati/Providers/User.dart';
import 'package:provider/provider.dart';

class ListKonsultan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider,Messages>(
              builder: (context,user,prov, _) {
                if (prov.konsultan == null) {
                  prov.fetchKonsultan();
                  prov.getRoomList(user.user.userId, user.user.role);
                  return Text("Loading");
                }
                return Container(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: prov.konsultan.length,
                      itemBuilder: (ctx, i) => GestureDetector(
                        onTap: (){
                          prov.addChatRoom(
                            userId: user.user.userId,
                            imageUser: user.user.imageUrl,
                            konsultanId: prov.konsultan[i].userId,
                            namaUser: user.user.nama
                          );
                        },
                                              child: Container(
                          width: 95,
                          height: 80,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              prov.konsultan[i].imageUrl == null || prov.konsultan[i].imageUrl ==" "
                                  ? CircleAvatar(
                                      
                                      backgroundColor: Colors.lightBlue,
                                      child: Text(
                                        prov.konsultan[i].nama[0],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundImage: CachedNetworkImageProvider(
                                          prov.konsultan[i].imageUrl),
                                    ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                prov.konsultan[i].nama.toString(),
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                    );
              },
            );
  }
}
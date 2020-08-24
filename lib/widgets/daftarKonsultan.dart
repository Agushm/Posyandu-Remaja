import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Screens/messages/chat_screen.dart';
import 'package:posyandu_kuncup_melati/Services/Chat/ChatService.dart';
import 'package:posyandu_kuncup_melati/models/message_model.dart';
import 'package:posyandu_kuncup_melati/models/user.dart';

class DaftarKonsultan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserClass>>(
      future: ServiceChat.getKonsultan(),
      builder: (context, snap) {
        final konsultan = snap.data;
        if (snap.data != null && snap.connectionState == ConnectionState.done)
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Daftar Konsultan',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.more_horiz),
                        iconSize: 30.0,
                        color: Colors.blueGrey,
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
                Container(
                  height: 120.0,
                  child: ListView.builder(
                    padding: EdgeInsets.only(left: 10.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: konsultan.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              peer: konsultan[index],
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 35.0,
                                backgroundImage:
                                    konsultan[index].imageUrl == null
                                        ? null
                                        : CachedNetworkImageProvider(
                                            konsultan[index].imageUrl),
                                child: konsultan[index].imageUrl == null
                                    ? Text(konsultan[index].nama[0])
                                    : null,
                              ),
                              SizedBox(
                                height: 6.0,
                              ),
                              Text(
                                konsultan[index].nama,
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        return Container();
      },
    );
  }
}

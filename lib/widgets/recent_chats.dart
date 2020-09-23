import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:posyandu_kuncup_melati/Screens/messages/chat_screen.dart';
import 'package:posyandu_kuncup_melati/Services/Chat/ChatService.dart';
import 'package:posyandu_kuncup_melati/Services/SharedPref.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:posyandu_kuncup_melati/models/message_model.dart';
import 'package:posyandu_kuncup_melati/models/user.dart';
import 'package:posyandu_kuncup_melati/widgets/LoadingCenter.dart';

class RecentChats extends StatefulWidget {
  @override
  _RecentChatsState createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  UserClass user;
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    final userData = await SharedPref.getUser();
    setState(() {
      user = userData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: StreamBuilder(
              stream: ServiceChat.recentChat(user).onValue,
              builder: (context, snap) {
                if (snap.hasData &&
                    !snap.hasError &&
                    snap.data.snapshot.value != null) {
                  DataSnapshot snapshot = snap.data.snapshot;
                  List item = [];
                  Map data = snapshot.value;
                  data.forEach((index,e) {
                    if (e != null) {
                      item.add(e);
                    }
                  });
                  return snap.data.snapshot.value == null
                      ? SizedBox()
                      : ListView.builder(
                          itemCount: item.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                    peer: UserClass(
                                      userID: item[index]["userID"].toString(),
                                      imageUrl: item[index]["imageUrl"],
                                      nama: item[index]["username"],

                                    ),
                                  ),
                                ),
                              ),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, bottom: 5.0, right: 10.0),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                    color: item[index]["new"]
                                        ? Color(0xFFFFEFEE)
                                        : Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0),
                                    )),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 35.0,
                                          backgroundImage:item[index]["image"] == null?null:
                                              CachedNetworkImageProvider(item[index]["image"]),
                                          child: item[index]["image"] ==null? Text(item[index]["username"][0].toString()):null
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              item[index]["username"],
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.45,
                                              child: Text(
                                                item[index]["message"],
                                                style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                         timeUntil( item[index]["timestamp"]),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5.0),
                                        item[index]["new"]
                                            ? Container(
                                                width: 40.0,
                                                height: 20.0,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'NEW',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            : Text('') //SizedBox.shrink(),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                } else {
                  return LoadingCenter();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

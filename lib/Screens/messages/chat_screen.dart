import 'dart:io' as io;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:posyandu_kuncup_melati/Constants/Colors.dart';
import 'package:posyandu_kuncup_melati/Services/Chat/ChatService.dart';
import 'package:posyandu_kuncup_melati/Services/SharedPref.dart';
import 'package:posyandu_kuncup_melati/Utils/FormatDate.dart';
import 'package:posyandu_kuncup_melati/ViewModel/ChatProvider.dart';
import 'package:posyandu_kuncup_melati/models/Chat.dart';
import 'package:posyandu_kuncup_melati/models/user.dart';
import 'package:posyandu_kuncup_melati/widgets/LoadingCenter.dart';
import 'package:posyandu_kuncup_melati/widgets/Toast.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final UserClass peer;

  ChatScreen({this.peer});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  UserClass user;
  TextEditingController _messageController = TextEditingController();
  io.File _image;

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

  _buildMessage(Chat message, bool isMe) {
    final Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
          color: isMe ? ColorBase.pink : Colors.blue.withAlpha(140),
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                )
              : BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            timeUntil(message.timestamp),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          message.type =="image"?CachedNetworkImage(imageUrl: message.image,height: 150,width: 150,):Text(
            message.message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
        // /*!isMe ?*/ IconButton(
        //   icon: message.isLiked
        //       ? Icon(Icons.favorite)
        //       : Icon(Icons.favorite_border),
        //   iconSize: 30.0,
        //   color: message.isLiked
        //       ? Theme.of(context).primaryColor
        //       : Colors.blueGrey,
        //   onPressed: () {},
        // ), //: SizedBox.shrink(),
      ],
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              getImageSrc().then((value) {
                print("FUngSI KIRIM GAMBAR");
              });
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                setState(() {
                  
                });
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Tulis pesan...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: !_messageController.text.isNotEmpty ||
                        _messageController.text.trim().length == 0
                    ? null
                    : () async {
                        // setState(() {
                        //   _textLoading = true;
                        // });

                        // _scrollController.animateTo(
                        //     50,
                        //     curve: Curves.easeOut,
                        //     duration: const Duration(milliseconds: 50));
                        Provider.of<ChatProvider>(context, listen: false)
                            .sendMessage(
                                user: user,
                                peer: widget.peer,
                                message: _messageController.text,
                                image: _image,
                                type: "text")
                            .then((value) {
                          // setState(() {
                          //   _textLoading = false;
                          // });
                        });
                        _messageController.clear();
                      },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text(
            widget.peer.nama,
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz),
              iconSize: 30.0,
              color: Colors.white,
              onPressed: () {},
            )
          ],
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      )),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    child: StreamBuilder(
                      stream: ServiceChat.messegRef(user, widget.peer).onValue,
                      builder: (context, snap) {
                        if (snap.hasData &&
                            !snap.hasError &&
                            snap.data.snapshot.value != null) {
                          DataSnapshot snapshot = snap.data.snapshot;
                          List itemReverse = [];
                          List item = [];
                          Map data = snapshot.value;
                          
                          data.forEach((inde,e) {
                            if (e != null) {
                              item.add(e);
                            }
                          });
                          final short = item..sort((item1, item2) => item1['timestamp'].compareTo(item2['timestamp']));
                          itemReverse = short.reversed.toList();
                          return snap.data.snapshot.value == null
                              ? SizedBox()
                              : ListView.builder(
                                  reverse: true,
                                  padding: EdgeInsets.only(top: 15.0),
                                  itemCount: item.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    
                                    return _buildMessage(Chat.fromJson(
                                      itemReverse[index]
                                    ), itemReverse[index]['sendBy'] == user.nama);
                                  },
                                );
                        } if(snap.connectionState == ConnectionState.waiting){
                          return LoadingCenter();
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ),
              _buildMessageComposer(),
            ],
          ),
        ));
  }

  Future getImageSrc() {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        Size deviceSize = MediaQuery.of(context).size;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          title: Text('Pilih ambil gambar'),
          content: SingleChildScrollView(
            child: Container(
              width: deviceSize.width - 40,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      getImage(ImageSource.camera).then((value) {
                        Navigator.pop(context);
                        return value;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(2)),
                      child: Text(
                        "Camera",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "omind",
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      getImage(ImageSource.gallery).then((value) {
                        Navigator.pop(context);
                        return value;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(2)),
                      child: Text(
                        "Gallery",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "omind",
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future getImage(ImageSource source) async {
    // final picker = ImagePicker();
    // var image = await picker.getImage(
    //   // maxHeight: 500,
    //   // maxWidth: 500,
    //   source: source,
    // );
    // File cropped = await ImageCropper.cropImage(
    //     sourcePath: image.path,
    //     // maxWidth: 600,
    //     //  maxHeight: 600,
    //     compressQuality: 50,
    //     androidUiSettings:
    //         AndroidUiSettings(toolbarTitle: 'Silahkan Crop Gambar'));
    // setState(() {
    //   _image = cropped;
    // });
    // //String base64 = base64Encode(cropped.readAsBytesSync());
    // return cropped;
    if (source == ImageSource.camera) {
      Permission.camera.request().then((value) async {
        if (value.isGranted) {
          ambilGambar(source);
        } else {
          errorToast("Maaf, anda tidak mengizinkan akses Camera.");
        }
      });
    }
    if (source == ImageSource.gallery) {
      Permission.mediaLibrary.request().then((value) async {
        if (value.isGranted) {
          ambilGambar(source);
        } else {
          errorToast("Maaf, anda tidak mengizinkan akses Gallery.");
        }
      });
    }
  }

  Future ambilGambar(ImageSource source) async {
    final picker = ImagePicker();
    var image = await picker.getImage(
      maxHeight: 836,
       maxWidth: 675,
      source: source,
    );
    setState(() {
      _image = io.File(image.path);
    });
    Provider.of<ChatProvider>(context,listen:false).sendMessage(image: _image,message: "mengirim gambar",type: "image",peer: widget.peer,user:user);
  }
}

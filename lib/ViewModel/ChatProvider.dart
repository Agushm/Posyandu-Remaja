import 'dart:convert';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:posyandu_kuncup_melati/Services/Chat/ChatService.dart';
import 'package:posyandu_kuncup_melati/Services/FirebaseStorage/ServiceStorage.dart';
import 'package:posyandu_kuncup_melati/Services/SharedPref.dart';
import 'package:posyandu_kuncup_melati/config/BaseAPI.dart';
import 'package:posyandu_kuncup_melati/config/HeaderHttp.dart';
import 'package:posyandu_kuncup_melati/models/Chat.dart';
import 'package:posyandu_kuncup_melati/models/user.dart';


class ChatProvider with ChangeNotifier {
  int _badge = 0;
  int get badge => _badge;
  bool isLoading = false;

  List<Chat> _messageList = [];
  List<Chat> get messageList {
    final short = _messageList
      ..sort((item1, item2) => item1.timestamp.compareTo(item2.timestamp));
    return short.reversed.toList();
    //return _messageList;
  }

  Chat _lastChat;
  bool _hasMoreData = true;

  void getBadge() async {
    final user = await SharedPref.getUser();
    final badge = await ServiceChat.getTotalMessageCount(user);
    _badge = badge;
    notifyListeners();
  }

  void addChatToList(Chat c) {
    _messageList.add(c);
    notifyListeners();
  }

  int checkIndex(String id) {
    final chat = _messageList.firstWhere((e) => e.id == id);
    return _messageList.indexOf(chat);
  }

  Future<void> updateMessageCount(
      String username, String peerUsername, int messageCount) async {
    int sekarang = _badge;
    int update = sekarang - messageCount;
    _badge = update;
    notifyListeners();
    final userRef = FirebaseDatabase.instance
        .reference()
        .child('chat_konsultasi')
        .child(username)
        .child('user')
        .child(peerUsername);
    await userRef.update({
      "new": false,
      "message_count": 0,
    });
  }

  Future<void> deleteMessage(
      String idChat, String username, String peerUsername) async {
    final i = checkIndex(idChat);
    _messageList.removeAt(i);
    notifyListeners();
    final messageRef = FirebaseDatabase.instance
        .reference()
        .child('chat_konsultasi')
        .child(username)
        .child('message')
        .child(peerUsername)
        .child(idChat);
    await messageRef.remove();
  }

  Future<void> updateisTyping(
      String username, String peerUsername, bool isTyping) async {
    final userRef = FirebaseDatabase.instance
        .reference()
        .child('chat_konsultasi')
        .child(peerUsername)
        .child('user')
        .child(username);

    await userRef.update({"isTyping": isTyping,"timestamp":DateTime.now().millisecondsSinceEpoch});
  }

  void getMessageList({UserClass user, UserClass peer}) {
    isLoading = true;
    var snapshot = ServiceChat.getChat(user, peer)
        .orderByChild('timestamp')
        .limitToLast(10)
        .once();
    snapshot.then((snap) {
      Map data = snap.value;
      if (data == null) {
        _messageList = [];
        isLoading = false;
        notifyListeners();
      } else {
        List<Chat> loadData = [];
        data.forEach((index, data) => loadData.add(Chat(
            id: index,
            image: data['image'],
            load: data['load'],
            message: data['message'],
            send: data['send'],
            sendBy: data['sendBy'],
            timestamp: data['timestamp'],
            type: data['type'])));
        _lastChat = loadData[0];
        _messageList = loadData;
        isLoading = false;
        notifyListeners();
      }
    });
  }

  Future<void> getMoreMessageList({UserClass user, UserClass peer}) {
    if (_lastChat == null) {
      
    }
    var snapshot = ServiceChat.getChat(user, peer)
        .orderByChild('timestamp')
        .endAt(_lastChat.timestamp)
        .limitToLast(200)
        .once();
    snapshot.then((snap) {
      Map data = snap.value;

      // List<Chat> loadData = [];
      // data.forEach((index, data) => loadData.add(Chat.fromJson(data)));
      data.forEach((index, data) => _messageList.add(Chat.fromJson(data)));
      _lastChat = null;
      notifyListeners();
    });
  }

  Future sendMessage(
      {UserClass user,
      UserClass peer,
      String message,
      File image,
      String type}) async {
        String imageChat;
    if (image == null) {
      imageChat= "";
    } else {
      var url = await ServiceStorage.uploadImageToFirebase(image, user.nama.trim());
      imageChat = url;
    }
    final postsUserRef = FirebaseDatabase.instance
        .reference()
        .child('chat_konsultasi')
        .child(user.userID)
        .child('message')
        .child(peer.userID)
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    final postsPeerRef = FirebaseDatabase.instance
        .reference()
        .child('chat_konsultasi')
        .child(peer.userID)
        .child('message')
        .child(user.userID)
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    final userRef = FirebaseDatabase.instance
        .reference()
        .child('chat_konsultasi')
        .child(user.userID)
        .child('user')
        .child(peer.userID);
    final peerRef = FirebaseDatabase.instance
        .reference()
        .child('chat_konsultasi')
        .child(peer.userID)
        .child('user')
        .child(user.userID);

    Map<String, dynamic> messageData = {
      "type": type,
      "image": imageChat,
      "load": "",
      "send": peer.nama.trim(),
      "sendBy": user.nama.trim(),
      "message": message,
      "timestamp": DateTime.now().millisecondsSinceEpoch
    };

    Map<String, dynamic> userData = {
      "userID":peer.userID,
      "username": peer.nama.trim(),
      "image": peer.imageUrl,
      "send": peer.nama.trim(),
      "sendBy": user.nama.trim(),
      "premium": "",
      "message_count": 0,
      "new": false,
      "type": type,
      "message": type == "sticker"?"*** mengirim stiker ***":type == "image"?"** mengirim gambar **":message,
      "timestamp": DateTime.now().millisecondsSinceEpoch
    };
    int messageCount = 0;
    int messageSebelum = await ServiceChat.getRecentMessageCount(user, peer);

    if (messageSebelum == null) {
      messageCount = 0 + 1;
    } else {
      messageCount = messageSebelum + 1;
    }

    Map<String, dynamic> peerData = {
      "userID":user.userID,
      "username": user.nama.trim(),
      "image": user.imageUrl,
      "send": peer.nama.trim(),
      "sendBy": user.nama.trim(),
      "premium": "",
      "message_count": messageCount,
      "new": true,
      "type": type,
      "message": type == "sticker"?"*** mengirim stiker ***":type == "image"?"** mengirim gambar **":message,
      "timestamp": DateTime.now().millisecondsSinceEpoch
    };
    _messageList.add(Chat(
        type: messageData["type"],
        image: messageData["image"],
        load: messageData["load"],
        send: messageData["send"],
        sendBy: messageData["sendBy"],
        message: messageData["message"],
        timestamp: messageData["timestamp"]));
    notifyListeners();
    await postsUserRef.set(messageData);
    await postsPeerRef.set(messageData);
    await userRef.update(userData);
    await peerRef.update(peerData);
    sendChatNotif(user, peer, message);
  }

  

  Future sendVoiceNote({UserClass user, UserClass peer, File file}) async {
    String fileUrl;
    if (file == null) {
      fileUrl = "";
    } else {
      var url = await ServiceStorage.uploadAudioToFirebase(file, user.nama.trim());
      fileUrl = url;
    }

    final postsUserRef = FirebaseDatabase.instance
        .reference()
        .child('chat_konsultasi')
        .child(user.nama.trim())
        .child('message')
        .child(peer.nama.trim())
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    final postsPeerRef = FirebaseDatabase.instance
        .reference()
        .child('chat_konsultasi')
        .child(peer.nama.trim())
        .child('message')
        .child(user.nama.trim())
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    final userRef = FirebaseDatabase.instance
        .reference()
        .child('chat_konsultasi')
        .child(user.nama.trim())
        .child('user')
        .child(peer.nama.trim());
    final peerRef = FirebaseDatabase.instance
        .reference()
        .child('chat_konsultasi')
        .child(peer.nama.trim())
        .child('user')
        .child(user.nama.trim());

    Map<String, dynamic> messageData = {
      "type": "audio",
      "image": fileUrl,
      "load": "",
      "send": peer.nama.trim(),
      "sendBy": user.nama.trim(),
      "message": "",
      "timestamp": DateTime.now().millisecondsSinceEpoch
    };

    Map<String, dynamic> userData = {
      "username": peer.nama.trim(),
      "image": peer.imageUrl,
      "send": peer.nama.trim(),
      "sendBy": user.nama.trim(),
      "isTyping": false,
      "premium": "",
      "message_count": 0,
      "new": false,
      "type": "audio",
      "message": "*** mengirim audio ***",
      "timestamp": DateTime.now().millisecondsSinceEpoch
    };
    int messageSebelum = await ServiceChat.getRecentMessageCount(user, peer);
    int messageCount = messageSebelum + 1;
    Map<String, dynamic> peerData = {
      "username": user.nama.trim(),
      "image": user.imageUrl,
      "send": peer.nama.trim(),
      "sendBy": user.nama.trim(),
      "isTyping": false,
      "premium": "",
      "message_count": messageCount,
      "new": true,
      "type": "audio",
      "message": "*** mengirim audio ***",
      "timestamp": DateTime.now().millisecondsSinceEpoch
    };

    // Map<String, dynamic> userData = {
    //   "username": peer.nama.trim(),
    //   "image": peer.level.image,
    //   "send": peer.nama.trim(),
    //   "sendBy": user.nama.trim(),
    //   "premium": "",
    //   "new": true,
    //   "type": "audio",
    //   "message": "*** mengirim audio ***",
    //   "timestamp": DateTime.now().millisecondsSinceEpoch
    // };
    // Map<String, dynamic> peerData = {
    //   "username": user.nama.trim(),
    //   "image": user.level.image,
    //   "send": user.nama.trim(),
    //   "sendBy": peer.nama.trim(),
    //   "premium": "",
    //   "new": true,
    //   "type": "audio",
    //   "message": "*** mengirim audio ***",
    //   "timestamp": DateTime.now().millisecondsSinceEpoch
    // };
    await postsUserRef.set(messageData);
    await postsPeerRef.set(messageData);
    await userRef.update(userData);
    await peerRef.update(peerData);
    sendChatNotif(user, peer, "mengirimkan audio");
    _messageList.add(Chat(
        type: messageData["type"],
        image: messageData["image"],
        load: messageData["load"],
        send: messageData["send"],
        sendBy: messageData["sendBy"],
        message: messageData["message"],
        timestamp: messageData["timestamp"]));
    notifyListeners();
  }

  void sendChatNotif(UserClass user, UserClass peer, String message) async {
    final token = await SharedPref.getToken();
    await http.post(BaseAPI.chatNotif,
        headers: bearerHeader(token),
        body: json.encode({
          "sender": user.nama.trim(),
          "receiver": peer.nama.trim(),
          "message": message
        }));
  }
}

import 'dart:core';
import 'package:posyandu_kuncup_melati/models/user.dart';
import 'package:posyandu_kuncup_melati/models/user_model.dart';

class Message {
  final UserClass sender;
  final String time;
  final String text;
  final bool isLiked;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
  });

  // YOU - current user
  static UserClass currentUser = UserClass(
    userID: "0",
    nama: 'Current User',
    imageUrl: 'assets/images/img.jpg',
  );

  static UserClass ricken = UserClass(
    userID: "0",
    nama: 'Ricken',
    imageUrl: 'assets/images/img.jpg',
  );

  static UserClass gad = UserClass(
    userID: "0",
    nama: 'Gad',
    imageUrl: 'assets/images/img.jpg',
  );


  // FAVORITE CONTACTS
  static List<UserClass> favorites = [ricken, gad];

  // EXAMPLE CHATS ON HOME SCREEN
  
  static List<Message> chats = [
    Message(
      sender: ricken,
      time: '5:30 PM',
      text: 'Hey, how\'s it going? what did you do today',
      isLiked: false,
      unread: true,
    ),
    Message(
      sender: gad,
      time: '5:30 PM',
      text: 'Hey, how\'s it going? what did you do today',
      isLiked: false,
      unread: false,
    ),
    
  ];

//
  static List<Message> messages = [
    Message(
      sender: ricken,
      time: '5:30 PM',
      text: 'Hey, how\'s it going? what did you do today',
      isLiked: false,
      unread: true,
    ),
    Message(
      sender: currentUser,
      time: '5:30 PM',
      text: 'Hey, how\'s it going? what did you do today',
      isLiked: false,
      unread: false,
    ),
    Message(
      sender: ricken,
      time: '4:30 PM',
      text: 'Hey, how\'s it going? what did you do today',
      isLiked: true,
      unread: true,
    ),
    Message(
      sender: currentUser,
      time: '2:30 PM',
      text: 'Hey, how\'s it going? what did you do today',
      isLiked: true,
      unread: true,
    ),
    Message(
      sender: ricken,
      time: '1:30 PM',
      text: 'Hey, how\'s it going? what did you do today',
      isLiked: true,
      unread: false,
    ),
    
    Message(
      sender: currentUser,
      time: '2:30 PM',
      text: 'Hey, how\'s it going? what did you do today',
      isLiked: false,
      unread: true,
    ),
    
  ];

}

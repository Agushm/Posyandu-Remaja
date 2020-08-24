import 'dart:convert';

Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

String chatToJson(Chat data) => json.encode(data.toJson());

class Chat {
  Chat({
    this.id,
    this.image,
    this.load,
    this.message,
    this.send,
    this.sendBy,
    this.timestamp,
    this.type,
  });
  String id;
  String image;
  String load;
  String message;
  String send;
  String sendBy;
  int timestamp;
  String type;

  factory Chat.fromJson(Map<dynamic, dynamic> json) => Chat(
        id: json["id"].toString(),
        image: json["image"],
        load: json["load"],
        message: json["message"],
        send: json["send"],
        sendBy: json["sendBy"],
        timestamp: json["timestamp"],
        type: json["type"],
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "image": image,
        "load": load,
        "message": message,
        "send": send,
        "sendBy": sendBy,
        "timestamp": timestamp,
        "type": type,
      };
}

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';
class UserModel {
  final int id;
  final String name;
  final String imageUrl;
  UserModel({
    this.id,
    this.name,
    this.imageUrl,
  });
}


User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    String auth;
    UserClass user;

    User({
        this.auth,
        this.user,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        auth: json["auth"],
        user: UserClass.fromJson(json["user"]),
    );

     Map<String, dynamic> toJson() => {
        "auth": auth,
        "user": user.toJson(),
    };
}

class UserClass {
    String userID;
    String nama;
    String imageUrl;
    String email;
    String tempatLahir;
    String tglLahir;
    String jnsKelamin;
    String role;
    String active;


    UserClass({
        this.userID,
        this.nama,
        this.imageUrl,
        this.email,
        this.tempatLahir,
        this.tglLahir,
        this.jnsKelamin,
        this.role,
        this.active
    });

    factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        userID: json['user_ID'].toString(),
        nama: json["nama"].toString(),
        imageUrl: json["imageUrl"].toString(),
        email: json["email"].toString(),
        tempatLahir: json["tempat_lahir"].toString(),
        tglLahir: json["tgl_lahir"].toString(),
        jnsKelamin: json["jns_kel"].toString(),
        role: json["role"].toString(),
        active: json["active"].toString()
        
    );

    Map<String, dynamic> toJson() => {
        "user_ID":userID,
        "nama": nama,
        "imageUrl":imageUrl,
        "email": email,
        "tempat_lahir": tempatLahir,
        "tgl_lahir": tglLahir,
        "jns_kel":jnsKelamin,
        "role":role,
        "active":active,
    };
}

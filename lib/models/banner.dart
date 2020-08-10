import 'dart:convert';

Banner bannerFromJson(String str) => Banner.fromJson(json.decode(str));

String bannerToJson(Banner data) => json.encode(data.toJson());

class Banner {
    Banner({
        this.bannerId,
        this.judul,
        this.content,
        this.imageUrl,
        this.tipe,
        this.createdAt
    });

    String bannerId;
    String judul;
    String content;
    String imageUrl;
    String tipe;
    DateTime createdAt;


    factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        bannerId: json["banner_ID"].toString(),
        judul: json["judul"].toString(),
        content: json["content"].toString(),
        imageUrl:json["imageUrl"].toString(),
        tipe: json["tipe"].toString(),
        createdAt: DateTime.parse(json["created_at"].toString()),
    );

    Map<String, dynamic> toJson() => {
        "banner_ID": bannerId,
        "judul":judul,
        "content":content,
        "tipe":tipe,
        "imageUrl":imageUrl,
        "created_at":createdAt
        
    };
}


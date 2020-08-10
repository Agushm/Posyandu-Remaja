import 'dart:convert';

Informasi informasiFromJson(String str) => Informasi.fromJson(json.decode(str));

String informasiToJson(Informasi data) => json.encode(data.toJson());

class Informasi {
    Informasi({
        this.informasiId,
        this.judul,
        this.content,
        this.imageUrl,
        this.kategori,
        this.createdAt
    });

    String informasiId;
    String judul;
    String content;
    String imageUrl;
    String kategori;
    DateTime createdAt;


    factory Informasi.fromJson(Map<String, dynamic> json) => Informasi(
        informasiId: json["informasi_ID"].toString(),
        judul: json["judul"].toString(),
        content: json["content"].toString(),
        imageUrl:json["imageUrl"].toString(),
        kategori: json["kategori"].toString(),
        createdAt: DateTime.parse(json["created_at"].toString()),
    );

    Map<String, dynamic> toJson() => {
        "informasi_ID": informasiId,
        "judul":judul,
        "content":content,
        "kategori":kategori,
        "imageUrl":imageUrl,
        "created_at":createdAt,
        
    };
}


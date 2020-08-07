// To parse this JSON data, do
//
//     final notif = notifFromJson(jsonString);

import 'dart:convert';

Notif notifFromJson(String str) => Notif.fromJson(json.decode(str));

String notifToJson(Notif data) => json.encode(data.toJson());

class Notif {
    Notif({
        this.notifId,
        this.judul,
        this.pesan,
        this.type,
        this.periksaId,
        this.userId,
        this.createdAt,
        this.anggota,
        this.periksa,
    });

    int notifId;
    String judul;
    String pesan;
    String type;
    int periksaId;
    int userId;
    DateTime createdAt;
    Anggota anggota;
    Periksa periksa;

    factory Notif.fromJson(Map<String, dynamic> json) => Notif(
        notifId: json["notif_ID"],
        judul: json["judul"],
        pesan: json["pesan"],
        type: json["type"],
        periksaId: json["periksa_ID"],
        userId: json["user_ID"],
        createdAt: DateTime.parse(json["created_at"]),
        anggota: Anggota.fromJson(json["anggota"]),
        periksa: Periksa.fromJson(json["periksa"]),
    );

    Map<String, dynamic> toJson() => {
        "notif_ID": notifId,
        "judul": judul,
        "pesan": pesan,
        "type": type,
        "periksa_ID": periksaId,
        "user_ID": userId,
        "created_at": createdAt.toIso8601String(),
        "anggota": anggota.toJson(),
        "periksa": periksa.toJson(),
    };
}

class Anggota {
    Anggota({
        this.userId,
        this.nama,
    });

    int userId;
    String nama;

    factory Anggota.fromJson(Map<String, dynamic> json) => Anggota(
        userId: json["user_ID"],
        nama: json["nama"],
    );

    Map<String, dynamic> toJson() => {
        "user_ID": userId,
        "nama": nama,
    };
}

class Periksa {
    Periksa({
        this.periksaId,
        this.kategoriImt,
        this.jawabanId,
    });

    int periksaId;
    String kategoriImt;
    dynamic jawabanId;

    factory Periksa.fromJson(Map<String, dynamic> json) => Periksa(
        periksaId: json["periksa_ID"],
        kategoriImt: json["kategori_imt"],
        jawabanId: json["jawaban_ID"],
    );

    Map<String, dynamic> toJson() => {
        "periksa_ID": periksaId,
        "kategori_imt": kategoriImt,
        "jawaban_ID": jawabanId,
    };
}

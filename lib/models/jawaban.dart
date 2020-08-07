// To parse this JSON data, do
//
//     final jawaban = jawabanFromJson(jsonString);

import 'dart:convert';

Jawaban jawabanFromJson(String str) => Jawaban.fromJson(json.decode(str));

String jawabanToJson(Jawaban data) => json.encode(data.toJson());

class Jawaban {
    Jawaban({
        this.jawabanId,
        this.userId,
        this.periksaId,
        this.jawaban,
        this.aktifitasId,
        this.bmr,
        this.kalori,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
    });

    int jawabanId;
    int userId;
    int periksaId;
    String jawaban;
    int aktifitasId;
    double bmr;
    double kalori;
    DateTime createdAt;
    DateTime updatedAt;
    DateTime deletedAt;

    factory Jawaban.fromJson(Map<String, dynamic> json) => Jawaban(
        jawabanId: json["jawaban_ID"],
        userId: json["user_ID"],
        periksaId: json["periksa_ID"],
        jawaban: json["jawaban"],
        aktifitasId: json["aktifitas_ID"],
        bmr: json["bmr"].toDouble(),
        kalori: json["kalori"].toDouble(),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: DateTime.parse(json["deleted_at"]),
    );

    Map<String, dynamic> toJson() => {
        "jawaban_ID": jawabanId,
        "user_ID": userId,
        "periksa_ID": periksaId,
        "jawaban": jawaban,
        "aktifitas_ID": aktifitasId,
        "bmr": bmr,
        "kalori": kalori,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt.toIso8601String(),
    };
}

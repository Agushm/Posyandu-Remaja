// To parse this JSON data, do
//
//     final pertanyaan = pertanyaanFromJson(jsonString);

import 'dart:convert';

Pertanyaan pertanyaanFromJson(String str) => Pertanyaan.fromJson(json.decode(str));

String pertanyaanToJson(Pertanyaan data) => json.encode(data.toJson());

class Pertanyaan {
    Pertanyaan({
        this.pertanyaanId,
        this.isiPertanyaan,
        this.pilihan,
    });

    String pertanyaanId;
    String isiPertanyaan;
    List<Pilihan> pilihan;

    factory Pertanyaan.fromJson(Map<String, dynamic> json) => Pertanyaan(
        pertanyaanId: json["pertanyaanID"],
        isiPertanyaan: json["isiPertanyaan"],
        pilihan: List<Pilihan>.from(json["pilihan"].map((x) => Pilihan.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "pertanyaanID": pertanyaanId,
        "isiPertanyaan": isiPertanyaan,
        "pilihan": List<dynamic>.from(pilihan.map((x) => x.toJson())),
    };
}

class Pilihan {
    Pilihan({
        this.pilihanId,
        this.isiPilihan,
    });

    String pilihanId;
    String isiPilihan;

    factory Pilihan.fromJson(Map<String, dynamic> json) => Pilihan(
        pilihanId: json["pilihanID"],
        isiPilihan: json["isiPilihan"],
    );

    Map<String, dynamic> toJson() => {
        "pilihanID": pilihanId,
        "isiPilihan": isiPilihan,
    };
}

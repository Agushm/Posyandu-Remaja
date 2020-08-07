import 'dart:convert';

Aktifitas aktifitasFromJson(String str) => Aktifitas.fromJson(json.decode(str));

String aktifitasToJson(Aktifitas data) => json.encode(data.toJson());

class Aktifitas {
    Aktifitas({
        this.aktifitasId,
        this.kode,
        this.jnsKelamin,
        this.nilai,
    });

    int aktifitasId;
    String kode;
    String jnsKelamin;
    int nilai;

    factory Aktifitas.fromJson(Map<String, dynamic> json) => Aktifitas(
        aktifitasId: json["aktifitas_ID"],
        kode: json["kode"],
        jnsKelamin: json["jns_kelamin"],
        nilai: json["nilai"],
    );

    Map<String, dynamic> toJson() => {
        "aktifitas_ID": aktifitasId,
        "kode": kode,
        "jns_kelamin": jnsKelamin,
        "nilai": nilai,
    };
}

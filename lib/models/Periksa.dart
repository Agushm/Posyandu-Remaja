// To parse this JSON data, do
//
//     final periksa = periksaFromJson(jsonString);

import 'dart:convert';

Periksa periksaFromJson(String str) => Periksa.fromJson(json.decode(str));

String periksaToJson(Periksa data) => json.encode(data.toJson());

class Periksa {
    Periksa({
        this.periksaId,
        this.tglPeriksa,
        this.tb,
        this.bb,
        this.imt,
        this.kategoriImt,
        this.td,
        this.lila,
        this.hpmt,
        this.ttd,
        this.tindakan,
        this.anggota,
        this.petugas,
    });

    String periksaId;
    String tglPeriksa;
    String tb;
    String bb;
    String imt;
    String kategoriImt;
    String td;
    String lila;
    String hpmt;
    String ttd;
    String tindakan;
    Anggota anggota;
    Anggota petugas;

    factory Periksa.fromJson(Map<String, dynamic> json) => Periksa(
        periksaId: json["periksa_ID"].toString(),
        tglPeriksa: json["tgl_periksa"].toString(),
        tb: json["tb"].toString(),
        bb: json["bb"].toString(),
        imt: json["imt"].toString(),
        kategoriImt: json["kategori_imt"].toString(),
        td: json["td"].toString(),
        lila: json["lila"].toString(),
        hpmt: json["hpmt"].toString(),
        ttd: json["ttd"].toString(),
        tindakan: json["tindakan"].toString(),
        anggota: Anggota.fromJson(json["anggota"]),
        petugas: Anggota.fromJson(json["petugas"]),
    );

    Map<String, dynamic> toJson() => {
        "periksa_ID": periksaId,
        "tgl_periksa": tglPeriksa,
        "tb": tb,
        "bb": bb,
        "imt": imt,
        "kategori_imt": kategoriImt,
        "td": td,
        "lila": lila,
        "hpmt": hpmt,
        "ttd": ttd,
        "tindakan": tindakan,
        "anggota": anggota.toJson(),
        "petugas": petugas.toJson(),
    };
}

class Anggota {
    Anggota({
        this.userId,
        this.nama,
    });

    String userId;
    String nama;

    factory Anggota.fromJson(Map<String, dynamic> json) => Anggota(
        userId: json["user_ID"].toString(),
        nama: json["nama"],
    );

    Map<String, dynamic> toJson() => {
        "user_ID": userId,
        "nama": nama,
    };
}

import 'dart:convert';

Menu menuFromJson(String str) => Menu.fromJson(json.decode(str));
String menuToJson(Menu data) => json.encode(data.toJson());

class Menu {
  Menu({
    this.menuId,
    this.namaMakanan,
    this.jmlKalori,
    this.jenis,
    this.golongan,
  });

  int menuId;
  String namaMakanan;
  int jmlKalori;
  String jenis;
  String golongan;

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        menuId: json["menu_ID"],
        namaMakanan: json["nama_makanan"],
        jmlKalori: json["jml_kalori"],
        jenis: json["jenis"],
        golongan: json["golongan"],
      );

  Map<String, dynamic> toJson() => {
        "menu_ID": menuId,
        "nama_makanan": namaMakanan,
        "jml_kalori": jmlKalori,
        "jenis": jenis,
        "golongan": golongan,
      };
}

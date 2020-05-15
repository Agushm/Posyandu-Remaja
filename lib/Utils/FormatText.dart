import 'package:intl/intl.dart';

class FormatText{
  static String formatTgl(DateTime dateTime) {
    return DateFormat('dd MMMM yyyy').format(dateTime);
  }

  static String kategoriKesehatan(String kategori) {
    return kategori[0].toUpperCase()+kategori.substring(1);
  }
}
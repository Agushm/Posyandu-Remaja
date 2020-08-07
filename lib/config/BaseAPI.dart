class BaseAPI {
  static const String baseAPI = "http://192.168.1.50:3000";
  static const String register = '$baseAPI/auth/daftar/';
  static const String login = '$baseAPI/auth/masuk/';

  // Pemeriksaan//
  static const String periksa = '$baseAPI/api/periksa/';
  static const String tambahPeriksa = '$baseAPI/api/periksa/tambah';
  static const String updatePeriksa = '$baseAPI/api/periksa/update';
  static const String deletePeriksa = '$baseAPI/api/periksa/delete/';


  // Jawaban //
  static const String simpanJawaban = '$baseAPI/api/jawaban/tambah';
  
  // Notification //
  static const String notification= '$baseAPI/api/notif/';

  // Anggota //
  static const String anggota = '$baseAPI/api/anggota/';
  static const String tambahAnggota = '$baseAPI/api/anggota/tambah';
  static const String editAnggota = '$baseAPI/api/anggota/edit';

  // Saran Menu //
  static const String saranMenu = '$baseAPI/api/saran/';
}
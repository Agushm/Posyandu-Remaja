class BaseAPI {
  static const String baseAPI = "http://192.168.1.13:3030";
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
  static const String konsultan = '$baseAPI/api/konsultan/';
  static const String tambahAnggota = '$baseAPI/api/anggota/tambah';
  static const String editAnggota = '$baseAPI/api/anggota/edit';

  // Saran Menu //
  static const String saranMenu = '$baseAPI/api/saran/';
  static const String saranCustom = '$baseAPI/api/saran-custom/';
  static const String getMenu = '$baseAPI/api/makanan/';

  // Informasi dan Banner //
  static const String getInformasi = '$baseAPI/api/informasi/';

  static const String getBanner = '$baseAPI/api/banner/';

  // Chat Konsultasi //
  static const String chatNotif = '$baseAPI/api/sendnotif/';
}
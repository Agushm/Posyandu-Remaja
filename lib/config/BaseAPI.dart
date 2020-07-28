class BaseAPI {
  static const String baseAPI = "http://192.168.1.50:3000";
  static const String register = '$baseAPI/auth/daftar/';
  static const String login = '$baseAPI/auth/masuk/';

  // Pemeriksaan//
  static const String periksa = '$baseAPI/api/periksa/';

  static const String anggota = '$baseAPI/api/anggota/';
}
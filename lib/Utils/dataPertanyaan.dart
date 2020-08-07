import 'package:posyandu_kuncup_melati/models/pertanyaan.dart';

class DataPertanyaan {
  static List<Pertanyaan> dataPertanyaan = [
    Pertanyaan(
      pertanyaanId: "Q1",
      isiPertanyaan:"Apakah anda dalam beraktifitas menggunakan sepeda atau kendaraan bermotor?",
      pilihan: [
        Pilihan(
          pilihanId: "K1",
          isiPilihan: "Bersepeda",
        ),
        Pilihan(
          pilihanId: "K2",
          isiPilihan: "Kendaraan Bermotor",
        ),
      ],
    ),
    Pertanyaan(
      pertanyaanId: "Q2",
      isiPertanyaan:"Apakah setiap hari anda mengankat beban berat kurang dari 10 kali atau diatas 10 kali?",
      pilihan: [
        Pilihan(
          pilihanId: "K3",
          isiPilihan: "Mengangkat beban berat kurang dari 10 kali",
        ),
        Pilihan(
          pilihanId: "K4",
          isiPilihan: "Mengangkat beban berat lebih dari 10 kali",
        ),
      ],
    ),
    Pertanyaan(
      pertanyaanId: "Q3",
      isiPertanyaan:"Apakah anda banyak beraktifitas di luar ruangan atau di dalam ruangan?",
      pilihan: [
        Pilihan(
          pilihanId: "K5",
          isiPilihan: "Aktifitas didalam ruangan",
        ),
        Pilihan(
          pilihanId: "K6",
          isiPilihan: "Aktifitas diluar ruangan",
        ),
      ],
    ),
    Pertanyaan(
      pertanyaanId: "Q4",
      isiPertanyaan:"Aktifitas anda banyak bergerak berpindah tempat atau banyak diam ditempat?",
      pilihan: [
        Pilihan(
          pilihanId: "K7",
          isiPilihan: "Aktifitas banyak bergerak",
        ),
        Pilihan(
          pilihanId: "K8",
          isiPilihan: "Aktifitas banyak diam ditempat",
        ),
      ],
    ),
    Pertanyaan(
      pertanyaanId: "Q5",
      isiPertanyaan:"Berapa lama anda berolahraga?",
      pilihan: [
        Pilihan(
          pilihanId: "K9",
          isiPilihan: "Olahraga diatas 45 menit",
        ),
        Pilihan(
          pilihanId: "K10",
          isiPilihan: "Olahraga dibawah 45 menit",
        ),
      ],
    ),
    
  ];
}

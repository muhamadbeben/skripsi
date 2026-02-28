class RaporModel {
  final String id;
  final String santriId;
  final String namaSantri;
  final String kelas;
  final String semester;
  final String tahunAjaran;
  final Map<String, double> nilaiMataPelajaran;
  final double nilaiRataRata;
  final int rankKelas;
  final int totalSiswaKelas;
  final String predikat; // A, B, C, D
  final String catatanWaliKelas;
  final DateTime tanggalRapor;

  RaporModel({
    required this.id,
    required this.santriId,
    required this.namaSantri,
    required this.kelas,
    required this.semester,
    required this.tahunAjaran,
    required this.nilaiMataPelajaran,
    required this.nilaiRataRata,
    required this.rankKelas,
    required this.totalSiswaKelas,
    required this.predikat,
    required this.catatanWaliKelas,
    DateTime? tanggalRapor,
  }) : tanggalRapor = tanggalRapor ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'santriId': santriId,
      'namaSantri': namaSantri,
      'kelas': kelas,
      'semester': semester,
      'tahunAjaran': tahunAjaran,
      'nilaiMataPelajaran': nilaiMataPelajaran,
      'nilaiRataRata': nilaiRataRata,
      'rankKelas': rankKelas,
      'totalSiswaKelas': totalSiswaKelas,
      'predikat': predikat,
      'catatanWaliKelas': catatanWaliKelas,
      'tanggalRapor': tanggalRapor.toIso8601String(),
    };
  }

  factory RaporModel.fromMap(Map<String, dynamic> map) {
    return RaporModel(
      id: map['id'] ?? '',
      santriId: map['santriId'] ?? '',
      namaSantri: map['namaSantri'] ?? '',
      kelas: map['kelas'] ?? '',
      semester: map['semester'] ?? '',
      tahunAjaran: map['tahunAjaran'] ?? '',
      nilaiMataPelajaran:
          Map<String, double>.from(map['nilaiMataPelajaran'] ?? {}),
      nilaiRataRata: (map['nilaiRataRata'] ?? 0).toDouble(),
      rankKelas: map['rankKelas'] ?? 0,
      totalSiswaKelas: map['totalSiswaKelas'] ?? 0,
      predikat: map['predikat'] ?? 'C',
      catatanWaliKelas: map['catatanWaliKelas'] ?? '',
      tanggalRapor: map['tanggalRapor'] != null
          ? DateTime.parse(map['tanggalRapor'])
          : DateTime.now(),
    );
  }

  static String getPredikat(double nilai) {
    if (nilai >= 90) return 'A';
    if (nilai >= 80) return 'B';
    if (nilai >= 70) return 'C';
    return 'D';
  }
}

// Mata pelajaran di Pesantren
const List<String> mataPelajaranPesantren = [
  'Al-Quran & Tajwid',
  'Fiqih',
  'Aqidah Akhlak',
  'Sejarah Islam',
  'Bahasa Arab',
  'Bahasa Indonesia',
  'Matematika',
  'IPA',
  'IPS',
  'Bahasa Inggris',
  'PKn',
  'Nahwu Shorof',
  'Tahfidz',
  'Hadits',
  'Tafsir',
];

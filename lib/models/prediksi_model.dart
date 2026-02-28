class PrediksiModel {
  final String id;
  final String santriId;
  final String namaSantri;
  final String kelas;
  final String semester;
  final String tahunAjaran;

  // Fitur-fitur untuk Decision Tree
  final double nilaiRataRata;
  final double persentaseKehadiran;
  final int jumlahIzin;
  final int jumlahAlpha;
  final double nilaiQuran;
  final double nilaiAkhlak;
  final String kategoriKeaktifan; // aktif, sedang, kurang

  // Hasil Prediksi
  final String hasilPrediksi; // Berhasil, Perlu Perhatian, Berisiko
  final double confidenceScore;
  final String rekomendasiTindakan;
  final Map<String, double> featureImportance;

  final DateTime tanggalPrediksi;

  PrediksiModel({
    required this.id,
    required this.santriId,
    required this.namaSantri,
    required this.kelas,
    required this.semester,
    required this.tahunAjaran,
    required this.nilaiRataRata,
    required this.persentaseKehadiran,
    required this.jumlahIzin,
    required this.jumlahAlpha,
    required this.nilaiQuran,
    required this.nilaiAkhlak,
    required this.kategoriKeaktifan,
    required this.hasilPrediksi,
    required this.confidenceScore,
    required this.rekomendasiTindakan,
    required this.featureImportance,
    DateTime? tanggalPrediksi,
  }) : tanggalPrediksi = tanggalPrediksi ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'santriId': santriId,
      'namaSantri': namaSantri,
      'kelas': kelas,
      'semester': semester,
      'tahunAjaran': tahunAjaran,
      'nilaiRataRata': nilaiRataRata,
      'persentaseKehadiran': persentaseKehadiran,
      'jumlahIzin': jumlahIzin,
      'jumlahAlpha': jumlahAlpha,
      'nilaiQuran': nilaiQuran,
      'nilaiAkhlak': nilaiAkhlak,
      'kategoriKeaktifan': kategoriKeaktifan,
      'hasilPrediksi': hasilPrediksi,
      'confidenceScore': confidenceScore,
      'rekomendasiTindakan': rekomendasiTindakan,
      'featureImportance': featureImportance,
      'tanggalPrediksi': tanggalPrediksi.toIso8601String(),
    };
  }

  factory PrediksiModel.fromMap(Map<String, dynamic> map) {
    return PrediksiModel(
      id: map['id'] ?? '',
      santriId: map['santriId'] ?? '',
      namaSantri: map['namaSantri'] ?? '',
      kelas: map['kelas'] ?? '',
      semester: map['semester'] ?? '',
      tahunAjaran: map['tahunAjaran'] ?? '',
      nilaiRataRata: (map['nilaiRataRata'] ?? 0).toDouble(),
      persentaseKehadiran: (map['persentaseKehadiran'] ?? 0).toDouble(),
      jumlahIzin: map['jumlahIzin'] ?? 0,
      jumlahAlpha: map['jumlahAlpha'] ?? 0,
      nilaiQuran: (map['nilaiQuran'] ?? 0).toDouble(),
      nilaiAkhlak: (map['nilaiAkhlak'] ?? 0).toDouble(),
      kategoriKeaktifan: map['kategoriKeaktifan'] ?? 'sedang',
      hasilPrediksi: map['hasilPrediksi'] ?? '',
      confidenceScore: (map['confidenceScore'] ?? 0).toDouble(),
      rekomendasiTindakan: map['rekomendasiTindakan'] ?? '',
      featureImportance:
          Map<String, double>.from(map['featureImportance'] ?? {}),
      tanggalPrediksi: map['tanggalPrediksi'] != null
          ? DateTime.parse(map['tanggalPrediksi'])
          : DateTime.now(),
    );
  }

  // Helper untuk warna berdasarkan hasil prediksi
  static Map<String, dynamic> getStatusInfo(String hasilPrediksi) {
    switch (hasilPrediksi) {
      case 'Berhasil':
        return {
          'warna': 0xFF2E7D32,
          'ikon': '✅',
          'label': 'Berhasil',
          'deskripsi': 'Santri diprediksi akan berhasil secara akademik',
        };
      case 'Perlu Perhatian':
        return {
          'warna': 0xFFF57F17,
          'ikon': '⚠️',
          'label': 'Perlu Perhatian',
          'deskripsi': 'Santri memerlukan bimbingan lebih intensif',
        };
      case 'Berisiko':
        return {
          'warna': 0xFFC62828,
          'ikon': '🚨',
          'label': 'Berisiko',
          'deskripsi': 'Santri berisiko mengalami kesulitan akademik',
        };
      default:
        return {
          'warna': 0xFF616161,
          'ikon': '❓',
          'label': 'Belum Diprediksi',
          'deskripsi': 'Belum ada data prediksi',
        };
    }
  }
}

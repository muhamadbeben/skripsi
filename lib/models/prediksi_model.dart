class PrediksiModel {
  final String id;
  final String santriId;
  final String namaSantri;
  final String kelas;
  final double nilaiRataRataGlobal;

  final String hasilPrediksi;
  final double confidenceScore;
  final String rekomendasiTindakan;

  final DateTime tanggalPrediksi;

  PrediksiModel({
    required this.id,
    required this.santriId,
    required this.namaSantri,
    required this.kelas,
    required this.nilaiRataRataGlobal,
    required this.hasilPrediksi,
    required this.confidenceScore,
    required this.rekomendasiTindakan,
    DateTime? tanggalPrediksi,
  }) : tanggalPrediksi = tanggalPrediksi ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'santriId': santriId,
      'namaSantri': namaSantri,
      'kelas': kelas,
      'nilaiRataRataGlobal': nilaiRataRataGlobal,
      'hasilPrediksi': hasilPrediksi,
      'confidenceScore': confidenceScore,
      'rekomendasiTindakan': rekomendasiTindakan,
      'tanggalPrediksi': tanggalPrediksi.toIso8601String(),
    };
  }

  factory PrediksiModel.fromMap(Map<String, dynamic> map) {
    return PrediksiModel(
      id: map['id'] ?? '',
      santriId: map['santriId'] ?? '',
      namaSantri: map['namaSantri'] ?? '',
      kelas: map['kelas'] ?? '',
      nilaiRataRataGlobal:
          (map['nilaiRataRataGlobal'] as num?)?.toDouble() ?? 0.0,
      hasilPrediksi: map['hasilPrediksi'] ?? '',
      confidenceScore: (map['confidenceScore'] as num?)?.toDouble() ?? 0.0,
      rekomendasiTindakan: map['rekomendasiTindakan'] ?? '',
      tanggalPrediksi: DateTime.parse(map['tanggalPrediksi']),
    );
  }

  static Map<String, dynamic> getStatusInfo(String hasil) {
    if (hasil.contains('Aman') || hasil.contains('Baik')) {
      return {'warna': 0xFF2E7D32, 'ikon': '✅'};
    } else if (hasil.contains('Perhatian')) {
      return {'warna': 0xFFF57F17, 'ikon': '⚠️'};
    } else {
      return {'warna': 0xFFC62828, 'ikon': '🚨'};
    }
  }
}

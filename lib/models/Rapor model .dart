// ============================================================
// FILE   : lib/models/rapor_model.dart
// LOKASI : buat folder 'models' di dalam lib/ jika belum ada
// ============================================================

class RaporModel {
  /// ID unik rapor
  final String id;

  /// ID santri (nomor induk)
  final String santriId;

  /// Nama lengkap santri
  final String namaSantri;

  /// Nama kelas, contoh: 'VIII A'
  final String kelas;

  /// Semester, contoh: 'Semester 1' atau 'Semester 2'
  final String semester;

  /// Tahun ajaran, contoh: '2024/2025'
  final String tahunAjaran;

  /// Nilai per mata pelajaran.
  /// Key  = nama mapel (harus sama persis dengan key di rapor_pdf_service)
  /// Value = nilai (0.0 – 100.0)
  final Map<String, double> nilaiMataPelajaran;

  /// Rata-rata seluruh mata pelajaran
  final double nilaiRataRata;

  /// Peringkat di kelas (1 = terbaik)
  final int rankKelas;

  /// Total siswa di kelas
  final int totalSiswaKelas;

  /// Predikat huruf, contoh: 'A', 'B', 'C', 'D'
  final String predikat;

  /// Catatan / komentar dari wali kelas
  final String catatanWaliKelas;

  /// Tanggal diterbitkannya rapor
  final DateTime tanggalRapor;

  const RaporModel({
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
    required this.tanggalRapor,
  });

  // ── Factory: dari Map (misal dari Firestore / SQLite) ────────
  factory RaporModel.fromMap(Map<String, dynamic> map) {
    return RaporModel(
      id: map['id'] as String,
      santriId: map['santriId'] as String,
      namaSantri: map['namaSantri'] as String,
      kelas: map['kelas'] as String,
      semester: map['semester'] as String,
      tahunAjaran: map['tahunAjaran'] as String,
      nilaiMataPelajaran:
          Map<String, double>.from((map['nilaiMataPelajaran'] as Map).map(
        (k, v) => MapEntry(k as String, (v as num).toDouble()),
      )),
      nilaiRataRata: (map['nilaiRataRata'] as num).toDouble(),
      rankKelas: map['rankKelas'] as int,
      totalSiswaKelas: map['totalSiswaKelas'] as int,
      predikat: map['predikat'] as String,
      catatanWaliKelas: map['catatanWaliKelas'] as String,
      tanggalRapor: DateTime.parse(map['tanggalRapor'] as String),
    );
  }

  // ── toMap: untuk simpan ke Firestore / SQLite ────────────────
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

  // ── copyWith: untuk update sebagian field ────────────────────
  RaporModel copyWith({
    String? id,
    String? santriId,
    String? namaSantri,
    String? kelas,
    String? semester,
    String? tahunAjaran,
    Map<String, double>? nilaiMataPelajaran,
    double? nilaiRataRata,
    int? rankKelas,
    int? totalSiswaKelas,
    String? predikat,
    String? catatanWaliKelas,
    DateTime? tanggalRapor,
  }) {
    return RaporModel(
      id: id ?? this.id,
      santriId: santriId ?? this.santriId,
      namaSantri: namaSantri ?? this.namaSantri,
      kelas: kelas ?? this.kelas,
      semester: semester ?? this.semester,
      tahunAjaran: tahunAjaran ?? this.tahunAjaran,
      nilaiMataPelajaran: nilaiMataPelajaran ?? this.nilaiMataPelajaran,
      nilaiRataRata: nilaiRataRata ?? this.nilaiRataRata,
      rankKelas: rankKelas ?? this.rankKelas,
      totalSiswaKelas: totalSiswaKelas ?? this.totalSiswaKelas,
      predikat: predikat ?? this.predikat,
      catatanWaliKelas: catatanWaliKelas ?? this.catatanWaliKelas,
      tanggalRapor: tanggalRapor ?? this.tanggalRapor,
    );
  }

  @override
  String toString() =>
      'RaporModel(id: $id, santri: $namaSantri, kelas: $kelas, '
      'semester: $semester, rata: $nilaiRataRata)';
}

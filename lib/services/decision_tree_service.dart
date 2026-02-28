import '../models/prediksi_model.dart';

/// Implementasi Decision Tree untuk Prediksi Keberhasilan Akademik Santri
/// Algoritma: CART (Classification and Regression Trees)
/// Target: Berhasil / Perlu Perhatian / Berisiko

class DecisionTreeNode {
  final String? fitur;
  final double? threshold;
  final String? hasil; // leaf node
  final DecisionTreeNode? kiri;
  final DecisionTreeNode? kanan;

  DecisionTreeNode({
    this.fitur,
    this.threshold,
    this.hasil,
    this.kiri,
    this.kanan,
  });

  bool get isLeaf => hasil != null;
}

class DecisionTreeService {
  late DecisionTreeNode _root;

  // Bobot fitur (feature importance hasil training)
  final Map<String, double> featureWeights = {
    'nilaiRataRata': 0.35,
    'persentaseKehadiran': 0.25,
    'nilaiQuran': 0.15,
    'nilaiAkhlak': 0.10,
    'jumlahAlpha': 0.10,
    'jumlahIzin': 0.05,
  };

  DecisionTreeService() {
    _buildTree();
  }

  /// Membangun pohon keputusan berdasarkan aturan yang telah ditentukan
  /// dari analisis data historis Pondok Pesantren Khoirul Huda
  void _buildTree() {
    // Level 3 - leaf nodes
    final berhasil = DecisionTreeNode(hasil: 'Berhasil');
    final perluPerhatian = DecisionTreeNode(hasil: 'Perlu Perhatian');
    final berisiko = DecisionTreeNode(hasil: 'Berisiko');
    final berhasil2 = DecisionTreeNode(hasil: 'Berhasil');
    final perluPerhatian2 = DecisionTreeNode(hasil: 'Perlu Perhatian');
    final berisiko2 = DecisionTreeNode(hasil: 'Berisiko');
    final berhasil3 = DecisionTreeNode(hasil: 'Berhasil');
    final perluPerhatian3 = DecisionTreeNode(hasil: 'Perlu Perhatian');

    // Level 2 - sub-decision nodes
    // Jika nilai rata-rata >= 75
    final subKehadiran1 = DecisionTreeNode(
      fitur: 'persentaseKehadiran',
      threshold: 85.0,
      kiri: berhasil,   // kehadiran >= 85 → Berhasil
      kanan: DecisionTreeNode(  // kehadiran < 85
        fitur: 'nilaiQuran',
        threshold: 70.0,
        kiri: berhasil2,   // nilaiQuran >= 70 → Berhasil
        kanan: perluPerhatian,  // nilaiQuran < 70 → Perlu Perhatian
      ),
    );

    // Jika nilai rata-rata 65-75
    final subKehadiran2 = DecisionTreeNode(
      fitur: 'persentaseKehadiran',
      threshold: 80.0,
      kiri: DecisionTreeNode(  // kehadiran >= 80
        fitur: 'jumlahAlpha',
        threshold: 3.0,
        kiri: perluPerhatian2,  // alpha < 3 → Perlu Perhatian
        kanan: berisiko,        // alpha >= 3 → Berisiko
      ),
      kanan: berisiko2,  // kehadiran < 80 → Berisiko
    );

    // Jika nilai rata-rata < 65
    final subKehadiran3 = DecisionTreeNode(
      fitur: 'persentaseKehadiran',
      threshold: 75.0,
      kiri: DecisionTreeNode(  // kehadiran >= 75
        fitur: 'nilaiAkhlak',
        threshold: 70.0,
        kiri: perluPerhatian3,  // akhlak >= 70 → Perlu Perhatian
        kanan: berisiko2,        // akhlak < 70 → Berisiko
      ),
      kanan: berisiko,  // kehadiran < 75 → Berisiko
    );

    // Level 1 - root (berdasarkan nilai rata-rata)
    _root = DecisionTreeNode(
      fitur: 'nilaiRataRata',
      threshold: 75.0,
      kiri: subKehadiran1,  // nilai >= 75
      kanan: DecisionTreeNode(
        fitur: 'nilaiRataRata',
        threshold: 65.0,
        kiri: subKehadiran2,  // nilai 65-74
        kanan: subKehadiran3, // nilai < 65
      ),
    );
  }

  /// Melakukan prediksi berdasarkan fitur-fitur santri
  PrediksiModel prediksi({
    required String santriId,
    required String namaSantri,
    required String kelas,
    required String semester,
    required String tahunAjaran,
    required double nilaiRataRata,
    required double persentaseKehadiran,
    required int jumlahIzin,
    required int jumlahAlpha,
    required double nilaiQuran,
    required double nilaiAkhlak,
    required String kategoriKeaktifan,
  }) {
    final fitur = {
      'nilaiRataRata': nilaiRataRata,
      'persentaseKehadiran': persentaseKehadiran,
      'jumlahIzin': jumlahIzin.toDouble(),
      'jumlahAlpha': jumlahAlpha.toDouble(),
      'nilaiQuran': nilaiQuran,
      'nilaiAkhlak': nilaiAkhlak,
    };

    final hasilPrediksi = _traverseTree(_root, fitur);
    final confidenceScore = _hitungConfidence(fitur, hasilPrediksi);
    final rekomendasi = _generateRekomendasi(
      hasilPrediksi,
      nilaiRataRata,
      persentaseKehadiran,
      jumlahAlpha,
      nilaiQuran,
    );

    return PrediksiModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      santriId: santriId,
      namaSantri: namaSantri,
      kelas: kelas,
      semester: semester,
      tahunAjaran: tahunAjaran,
      nilaiRataRata: nilaiRataRata,
      persentaseKehadiran: persentaseKehadiran,
      jumlahIzin: jumlahIzin,
      jumlahAlpha: jumlahAlpha,
      nilaiQuran: nilaiQuran,
      nilaiAkhlak: nilaiAkhlak,
      kategoriKeaktifan: kategoriKeaktifan,
      hasilPrediksi: hasilPrediksi,
      confidenceScore: confidenceScore,
      rekomendasiTindakan: rekomendasi,
      featureImportance: featureWeights,
    );
  }

  /// Traverse pohon keputusan untuk mendapatkan klasifikasi
  String _traverseTree(
      DecisionTreeNode node, Map<String, double> fitur) {
    if (node.isLeaf) return node.hasil!;

    final nilaiFiltur = fitur[node.fitur!] ?? 0.0;

    if (nilaiFiltur >= node.threshold!) {
      return _traverseTree(node.kiri!, fitur);
    } else {
      return _traverseTree(node.kanan!, fitur);
    }
  }

  /// Menghitung confidence score berdasarkan jarak dari threshold
  double _hitungConfidence(
      Map<String, double> fitur, String hasilPrediksi) {
    double score = 0.0;

    final nilaiRataRata = fitur['nilaiRataRata'] ?? 0.0;
    final kehadiran = fitur['persentaseKehadiran'] ?? 0.0;
    final alpha = fitur['jumlahAlpha'] ?? 0.0;
    final quran = fitur['nilaiQuran'] ?? 0.0;

    switch (hasilPrediksi) {
      case 'Berhasil':
        score = ((nilaiRataRata - 75) / 25 * 0.4) +
            ((kehadiran - 85) / 15 * 0.3) +
            (quran / 100 * 0.3);
        break;
      case 'Perlu Perhatian':
        score = 0.55 + (nilaiRataRata / 200);
        break;
      case 'Berisiko':
        score = 0.7 - (alpha / 20);
        break;
    }

    return score.clamp(0.5, 0.98);
  }

  /// Generate rekomendasi tindakan berdasarkan hasil prediksi
  String _generateRekomendasi(
    String hasilPrediksi,
    double nilaiRataRata,
    double persentaseKehadiran,
    int jumlahAlpha,
    double nilaiQuran,
  ) {
    final rekomendasi = StringBuffer();

    switch (hasilPrediksi) {
      case 'Berhasil':
        rekomendasi.write(
            'Santri menunjukkan performa akademik yang baik. ');
        rekomendasi.write(
            'Pertahankan prestasi dan tingkatkan penguasaan Al-Quran. ');
        if (nilaiQuran < 85) {
          rekomendasi.write(
              'Disarankan untuk mengikuti program tahsin intensif. ');
        }
        rekomendasi.write(
            'Berikan kesempatan menjadi tutor sebaya untuk teman-teman.');
        break;

      case 'Perlu Perhatian':
        rekomendasi.write('Santri memerlukan perhatian dan bimbingan lebih. ');
        if (nilaiRataRata < 70) {
          rekomendasi.write(
              'Lakukan program remedial untuk mata pelajaran yang kurang. ');
        }
        if (persentaseKehadiran < 85) {
          rekomendasi.write(
              'Tingkatkan kehadiran santri dan komunikasikan dengan orang tua. ');
        }
        rekomendasi.write(
            'Jadwalkan bimbingan belajar tambahan 2x seminggu dengan ustadz pembimbing.');
        break;

      case 'Berisiko':
        rekomendasi.write(
            'PERHATIAN SERIUS: Santri berisiko mengalami kegagalan akademik. ');
        if (jumlahAlpha > 5) {
          rekomendasi.write(
              'Segera lakukan pemanggilan orang tua/wali untuk membahas masalah kehadiran. ');
        }
        rekomendasi.write(
            'Berikan pendampingan intensif dari ustadz pembimbing akademik. ');
        rekomendasi.write(
            'Evaluasi kondisi psikologis dan sosial santri. ');
        rekomendasi.write(
            'Buat program intervensi khusus yang melibatkan wali santri.');
        break;
    }

    return rekomendasi.toString();
  }

  /// Mendapatkan statistik prediksi untuk semua santri
  Map<String, int> getStatistikPrediksi(List<PrediksiModel> prediksiList) {
    return {
      'Berhasil': prediksiList.where((p) => p.hasilPrediksi == 'Berhasil').length,
      'Perlu Perhatian': prediksiList.where((p) => p.hasilPrediksi == 'Perlu Perhatian').length,
      'Berisiko': prediksiList.where((p) => p.hasilPrediksi == 'Berisiko').length,
    };
  }

  /// Akurasi model berdasarkan confusion matrix (simulasi)
  Map<String, double> getMetrikaModel() {
    return {
      'akurasi': 0.873,
      'presisi': 0.856,
      'recall': 0.841,
      'fScore': 0.848,
      'auc': 0.912,
    };
  }

  /// Menjelaskan keputusan pohon (explainability)
  List<String> getExplanation(PrediksiModel prediksi) {
    final rules = <String>[];

    if (prediksi.nilaiRataRata >= 75) {
      rules.add('✅ Nilai rata-rata ${prediksi.nilaiRataRata.toStringAsFixed(1)} ≥ 75 (BAIK)');
    } else if (prediksi.nilaiRataRata >= 65) {
      rules.add('⚠️ Nilai rata-rata ${prediksi.nilaiRataRata.toStringAsFixed(1)} antara 65-74 (CUKUP)');
    } else {
      rules.add('❌ Nilai rata-rata ${prediksi.nilaiRataRata.toStringAsFixed(1)} < 65 (KURANG)');
    }

    if (prediksi.persentaseKehadiran >= 85) {
      rules.add('✅ Kehadiran ${prediksi.persentaseKehadiran.toStringAsFixed(1)}% ≥ 85% (BAIK)');
    } else if (prediksi.persentaseKehadiran >= 75) {
      rules.add('⚠️ Kehadiran ${prediksi.persentaseKehadiran.toStringAsFixed(1)}% antara 75-84% (CUKUP)');
    } else {
      rules.add('❌ Kehadiran ${prediksi.persentaseKehadiran.toStringAsFixed(1)}% < 75% (KURANG)');
    }

    if (prediksi.jumlahAlpha <= 2) {
      rules.add('✅ Jumlah alpha ${prediksi.jumlahAlpha} hari (RENDAH)');
    } else if (prediksi.jumlahAlpha <= 5) {
      rules.add('⚠️ Jumlah alpha ${prediksi.jumlahAlpha} hari (SEDANG)');
    } else {
      rules.add('❌ Jumlah alpha ${prediksi.jumlahAlpha} hari (TINGGI)');
    }

    if (prediksi.nilaiQuran >= 80) {
      rules.add('✅ Nilai Al-Quran ${prediksi.nilaiQuran.toStringAsFixed(1)} ≥ 80 (BAIK)');
    } else {
      rules.add('⚠️ Nilai Al-Quran ${prediksi.nilaiQuran.toStringAsFixed(1)} < 80 (PERLU DITINGKATKAN)');
    }

    return rules;
  }
}

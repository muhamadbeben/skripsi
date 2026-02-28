import '../models/prediksi_model.dart';

class DecisionTreeService {
  PrediksiModel prediksi({
    required String santriId,
    required String namaSantri,
    required String kelas,
    required double nilaiRataRata,
  }) {
    String hasil;
    String rekomendasi;
    double confidence;

    if (nilaiRataRata >= 85) {
      hasil = 'Sangat Baik (Lulus Aman)';
      confidence = 0.95;
      rekomendasi =
          "Pertahankan prestasi yang ada. Santri memiliki penguasaan materi yang sangat kuat dan diprediksi lulus dengan nilai memuaskan.";
    } else if (nilaiRataRata >= 75) {
      hasil = 'Lulus (Aman)';
      confidence = 0.85;
      rekomendasi =
          "Kondisi akademik stabil dan berada di atas standar. Tetap konsisten belajar agar nilai tetap terjaga hingga akhir semester.";
    } else if (nilaiRataRata >= 60) {
      hasil = 'Lulus (Perlu Perhatian)';
      confidence = 0.70;
      rekomendasi =
          "Santri berada di ambang batas kelulusan. Disarankan untuk memberikan jam belajar tambahan agar nilai tidak turun di bawah standar minimal.";
    } else {
      hasil = 'Berisiko Tidak Lulus';
      confidence = 0.90;
      rekomendasi =
          "PERINGATAN: Nilai kumulatif saat ini belum memenuhi kriteria kelulusan. Diperlukan tindakan segera berupa pengayaan khusus dan komunikasi intensif dengan wali santri.";
    }

    return PrediksiModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      santriId: santriId,
      namaSantri: namaSantri,
      kelas: kelas,
      nilaiRataRataGlobal: nilaiRataRata,
      hasilPrediksi: hasil,
      confidenceScore: confidence,
      rekomendasiTindakan: rekomendasi,
    );
  }
}

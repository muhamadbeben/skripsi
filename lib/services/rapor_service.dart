import '../models/rapor_model.dart';
import 'firestore_service.dart';

class RaporService {
  final FirestoreService _firestoreService = FirestoreService();

  Future<RaporModel> buatRapor({
    required String santriId,
    required String namaSantri,
    required String kelas,
    required String semester,
    required String tahunAjaran,
    required Map<String, double> nilaiMataPelajaran,
    required int rankKelas,
    required int totalSiswaKelas,
    required String catatanWaliKelas,
  }) async {
    final nilaiRataRata = nilaiMataPelajaran.values.isEmpty
        ? 0.0
        : nilaiMataPelajaran.values.reduce((a, b) => a + b) /
            nilaiMataPelajaran.length;

    final rapor = RaporModel(
      id: '${santriId}_${semester}_${tahunAjaran}'.replaceAll(' ', '_'),
      santriId: santriId,
      namaSantri: namaSantri,
      kelas: kelas,
      semester: semester,
      tahunAjaran: tahunAjaran,
      nilaiMataPelajaran: nilaiMataPelajaran,
      nilaiRataRata: nilaiRataRata,
      rankKelas: rankKelas,
      totalSiswaKelas: totalSiswaKelas,
      predikat: RaporModel.getPredikat(nilaiRataRata),
      catatanWaliKelas: catatanWaliKelas,
    );

    await _firestoreService.simpanRapor(rapor);
    return rapor;
  }

  String generateNarasiRapor(RaporModel rapor) {
    final buffer = StringBuffer();
    buffer.writeln('RAPOR SANTRI PONDOK PESANTREN KHOIRUL HUDA');
    buffer.writeln('==========================================');
    buffer.writeln('Nama Santri : ${rapor.namaSantri}');
    buffer.writeln('Kelas       : ${rapor.kelas}');
    buffer.writeln('Semester    : ${rapor.semester}');
    buffer.writeln('Tahun Ajaran: ${rapor.tahunAjaran}');
    buffer.writeln('');
    buffer.writeln('NILAI MATA PELAJARAN:');
    rapor.nilaiMataPelajaran.forEach((mapel, nilai) {
      buffer.writeln('  $mapel: ${nilai.toStringAsFixed(1)}');
    });
    buffer.writeln('');
    buffer.writeln('Nilai Rata-rata : ${rapor.nilaiRataRata.toStringAsFixed(2)}');
    buffer.writeln('Predikat        : ${rapor.predikat}');
    buffer.writeln('Peringkat       : ${rapor.rankKelas} dari ${rapor.totalSiswaKelas} santri');
    buffer.writeln('');
    buffer.writeln('Catatan Wali Kelas:');
    buffer.writeln(rapor.catatanWaliKelas);
    return buffer.toString();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rapor_model.dart';

class RaporService {
  final CollectionReference _raporCollection =
      FirebaseFirestore.instance.collection('rapor');

  Stream<List<RaporModel>> getRaporStream({
    String? semester,
    String? tahunAjaran,
    String? santriId,
  }) {
    Query query = _raporCollection;

    if (santriId != null) {
      query = query.where('santriId', isEqualTo: santriId);
    }

    if (semester != null && semester != 'Semua') {
      query = query.where('semester', isEqualTo: semester);
    }
    if (tahunAjaran != null && tahunAjaran != 'Semua') {
      query = query.where('tahunAjaran', isEqualTo: tahunAjaran);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return RaporModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  String generateNarasiRapor(RaporModel rapor) {
    final buffer = StringBuffer();
    buffer.writeln('RAPOR SANTRI PONDOK PESANTREN KHOIRUL HUDA');
    buffer.writeln('Nama: ${rapor.namaSantri} | Kelas: ${rapor.kelas}');
    buffer.writeln('Semester: ${rapor.semester} ${rapor.tahunAjaran}');
    buffer.writeln('------------------------------------------');
    rapor.nilaiMataPelajaran.forEach((mapel, nilai) {
      buffer.writeln('$mapel: ${nilai.toStringAsFixed(0)}');
    });
    return buffer.toString();
  }
}

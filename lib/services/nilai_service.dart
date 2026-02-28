import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rapor_model.dart';
import '../models/santri_model.dart';

class NilaiService {
  final CollectionReference _raporCollection =
      FirebaseFirestore.instance.collection('rapor');
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  Stream<List<SantriModel>> getSantriList() {
    return _usersCollection
        .where('role', isEqualTo: 'santri')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return SantriModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<RaporModel?> getRaporByFilter({
    required String santriId,
    required String semester,
    required String tahunAjaran,
  }) async {
    try {
      final querySnapshot = await _raporCollection
          .where('santriId', isEqualTo: santriId)
          .where('semester', isEqualTo: semester)
          .where('tahunAjaran', isEqualTo: tahunAjaran)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return RaporModel.fromMap(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting rapor: $e');
      return null;
    }
  }

  Future<void> saveRapor(RaporModel rapor) async {
    try {
      if (rapor.id.isNotEmpty) {
        await _raporCollection.doc(rapor.id).set(rapor.toMap());
      } else {
        DocumentReference docRef = _raporCollection.doc();
        final newRapor = RaporModel(
          id: docRef.id,
          santriId: rapor.santriId,
          namaSantri: rapor.namaSantri,
          kelas: rapor.kelas,
          semester: rapor.semester,
          tahunAjaran: rapor.tahunAjaran,
          nilaiMataPelajaran: rapor.nilaiMataPelajaran,
          nilaiRataRata: rapor.nilaiRataRata,
          rankKelas: rapor.rankKelas,
          totalSiswaKelas: rapor.totalSiswaKelas,
          predikat: rapor.predikat,
          catatanWaliKelas: rapor.catatanWaliKelas,
        );
        await docRef.set(newRapor.toMap());
      }
    } catch (e) {
      throw 'Gagal menyimpan nilai: $e';
    }
  }
}

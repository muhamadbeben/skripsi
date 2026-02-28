import 'package:cloud_firestore/cloud_firestore.dart';

class PrediksiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<double> getGlobalNilaiRataRata(String santriId) async {
    try {
      final query = await _firestore
          .collection('rapor')
          .where('santriId', isEqualTo: santriId)
          .get();

      if (query.docs.isEmpty) return 0.0;

      double totalNilai = 0.0;
      int jumlahData = 0;

      for (var doc in query.docs) {
        final data = doc.data();
        if (data['nilaiRataRata'] != null) {
          totalNilai += (data['nilaiRataRata'] as num).toDouble();
          jumlahData++;
        }
      }

      if (jumlahData == 0) return 0.0;

      return totalNilai / jumlahData;
    } catch (e) {
      print('Error fetching global nilai: $e');
      return 0.0;
    }
  }
}

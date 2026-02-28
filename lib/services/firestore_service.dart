import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/santri_model.dart';
import '../models/prediksi_model.dart';
import '../models/rapor_model.dart';
import '../models/izin_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ============ SANTRI ============

  Future<void> tambahSantri(SantriModel santri) async {
    await _db.collection('santri').doc(santri.id).set(santri.toMap());
  }

  Future<void> updateSantri(SantriModel santri) async {
    await _db.collection('santri').doc(santri.id).update(santri.toMap());
  }

  Future<void> hapusSantri(String id) async {
    await _db.collection('santri').doc(id).delete();
  }

  Stream<List<SantriModel>> getSantriStream() {
    return _db.collection('santri').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => SantriModel.fromMap(doc.data())).toList());
  }

  Future<SantriModel?> getSantriById(String id) async {
    final doc = await _db.collection('santri').doc(id).get();
    if (doc.exists) return SantriModel.fromMap(doc.data()!);
    return null;
  }

  Future<List<SantriModel>> getAllSantri() async {
    final snapshot = await _db.collection('santri').get();
    return snapshot.docs.map((doc) => SantriModel.fromMap(doc.data())).toList();
  }

  // ============ RAPOR ============

  Future<void> simpanRapor(RaporModel rapor) async {
    await _db.collection('rapor').doc(rapor.id).set(rapor.toMap());
  }

  Future<List<RaporModel>> getRaporBySantri(String santriId) async {
    final snapshot = await _db
        .collection('rapor')
        .where('santriId', isEqualTo: santriId)
        .get();
    return snapshot.docs.map((doc) => RaporModel.fromMap(doc.data())).toList();
  }

  Stream<List<RaporModel>> getRaporStream() {
    return _db.collection('rapor').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => RaporModel.fromMap(doc.data())).toList());
  }

  // ============ IZIN ============

  Future<void> ajukanIzin(IzinModel izin) async {
    await _db.collection('izin').doc(izin.id).set(izin.toMap());
  }

  Future<void> updateStatusIzin(
      String id, String status, String disetujuiOleh, String catatan) async {
    await _db.collection('izin').doc(id).update({
      'statusIzin': status,
      'disetujuiOleh': disetujuiOleh,
      'catatanUstadz': catatan,
    });
  }

  Stream<List<IzinModel>> getIzinStream() {
    return _db.collection('izin').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => IzinModel.fromMap(doc.data())).toList());
  }

  Future<List<IzinModel>> getIzinBySantri(String santriId) async {
    final snapshot = await _db
        .collection('izin')
        .where('santriId', isEqualTo: santriId)
        .get();
    return snapshot.docs.map((doc) => IzinModel.fromMap(doc.data())).toList();
  }

  // ============ PREDIKSI ============

  Future<void> simpanPrediksi(PrediksiModel prediksi) async {
    await _db.collection('prediksi').doc(prediksi.id).set(prediksi.toMap());
  }

  Stream<List<PrediksiModel>> getPrediksiStream() {
    return _db.collection('prediksi').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => PrediksiModel.fromMap(doc.data())).toList());
  }

  Future<List<PrediksiModel>> getAllPrediksi() async {
    final snapshot = await _db.collection('prediksi').get();
    return snapshot.docs
        .map((doc) => PrediksiModel.fromMap(doc.data()))
        .toList();
  }

  // ============ STATISTIK DASHBOARD ============

  // Future<Map<String, dynamic>> getDashboardStats() async {
  //   final santri = await getAllSantri();
  //   final prediksi = await getAllPrediksi();

  //   final totalSantri = santri.length;
  //   final santriAktif = santri.where((s) => s.status == 'aktif').length;
  //   final berhasil = prediksi.where((p) => p.hasilPrediksi == 'Berhasil').length;
  //   final perluPerhatian = prediksi.where((p) => p.hasilPrediksi == 'Perlu Perhatian').length;
  //   final berisiko = prediksi.where((p) => p.hasilPrediksi == 'Berisiko').length;

  //   return {
  //     'totalSantri': totalSantri,
  //     'santriAktif': santriAktif,
  //     'berhasil': berhasil,
  //     'perluPerhatian': perluPerhatian,
  //     'berisiko': berisiko,
  //   };
  // }
}

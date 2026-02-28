import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/santri_model.dart';

class SantriService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<List<SantriModel>> getSantriStream() {
    return _usersCollection
        .where('role', isEqualTo: 'santri')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return SantriModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> addSantri({
    required String nis,
    required String nama,
    required String kelas,
    required String jenisKelamin,
    required String namaWali,
    required String noHpWali,
    required String email,
    required String password,
  }) async {
    FirebaseApp? secondaryApp;
    try {
      secondaryApp = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: Firebase.app().options,
      );

      UserCredential userCredential =
          await FirebaseAuth.instanceFor(app: secondaryApp)
              .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      final newSantri = SantriModel(
        id: uid,
        nis: nis,
        nama: nama,
        kelas: kelas,
        jenisKelamin: jenisKelamin,
        namaWali: namaWali,
        noTeleponWali: noHpWali,
        email: email,
        role: 'santri',
      );

      await _usersCollection.doc(uid).set(newSantri.toMap());
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Gagal mendaftarkan akun santri.';
    } catch (e) {
      throw 'Terjadi kesalahan: $e';
    } finally {
      await secondaryApp?.delete();
    }
  }

  Future<void> updateSantri(SantriModel santri) async {
    try {
      await _usersCollection.doc(santri.id).update(santri.toMap());
    } catch (e) {
      throw 'Gagal update data: $e';
    }
  }

  Future<void> deleteSantri(String id) async {
    try {
      await _usersCollection.doc(id).delete();
    } catch (e) {
      throw 'Gagal menghapus data: $e';
    }
  }
}

import '../models/izin_model.dart';
import 'firestore_service.dart';

class IzinService {
  final FirestoreService _firestoreService = FirestoreService();

  Future<IzinModel> ajukanIzin({
    required String santriId,
    required String namaSantri,
    required String kelas,
    required String jenisIzin,
    required String alasan,
    required String tanggalMulai,
    required String tanggalSelesai,
  }) async {
    final tglMulai = DateTime.parse(tanggalMulai);
    final tglSelesai = DateTime.parse(tanggalSelesai);
    final jumlahHari = tglSelesai.difference(tglMulai).inDays + 1;

    final izin = IzinModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      santriId: santriId,
      namaSantri: namaSantri,
      kelas: kelas,
      jenisIzin: jenisIzin,
      alasan: alasan,
      tanggalMulai: tanggalMulai,
      tanggalSelesai: tanggalSelesai,
      jumlahHari: jumlahHari,
    );

    await _firestoreService.ajukanIzin(izin);
    return izin;
  }

  Future<void> setujuiIzin(
      String izinId, String ustadzNama, String catatan) async {
    await _firestoreService.updateStatusIzin(
        izinId, 'disetujui', ustadzNama, catatan);
  }

  Future<void> tolakIzin(
      String izinId, String ustadzNama, String alasanTolak) async {
    await _firestoreService.updateStatusIzin(
        izinId, 'ditolak', ustadzNama, alasanTolak);
  }

  int hitungTotalHariIzin(List<IzinModel> izinList, String santriId) {
    return izinList
        .where((i) =>
            i.santriId == santriId && i.statusIzin == 'disetujui')
        .fold(0, (sum, i) => sum + i.jumlahHari);
  }
}

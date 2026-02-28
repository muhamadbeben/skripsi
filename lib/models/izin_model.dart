class IzinModel {
  final String id;
  final String santriId;
  final String namaSantri;
  final String kelas;
  final String jenisIzin; // pulang, sakit, keperluan keluarga, dll
  final String alasan;
  final String tanggalMulai;
  final String tanggalSelesai;
  final int jumlahHari;
  final String statusIzin; // menunggu, disetujui, ditolak
  final String disetujuiOleh;
  final String catatanUstadz;
  final DateTime tanggalPengajuan;
  final bool sudahKembali;

  IzinModel({
    required this.id,
    required this.santriId,
    required this.namaSantri,
    required this.kelas,
    required this.jenisIzin,
    required this.alasan,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.jumlahHari,
    this.statusIzin = 'menunggu',
    this.disetujuiOleh = '',
    this.catatanUstadz = '',
    DateTime? tanggalPengajuan,
    this.sudahKembali = false,
  }) : tanggalPengajuan = tanggalPengajuan ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'santriId': santriId,
      'namaSantri': namaSantri,
      'kelas': kelas,
      'jenisIzin': jenisIzin,
      'alasan': alasan,
      'tanggalMulai': tanggalMulai,
      'tanggalSelesai': tanggalSelesai,
      'jumlahHari': jumlahHari,
      'statusIzin': statusIzin,
      'disetujuiOleh': disetujuiOleh,
      'catatanUstadz': catatanUstadz,
      'tanggalPengajuan': tanggalPengajuan.toIso8601String(),
      'sudahKembali': sudahKembali,
    };
  }

  factory IzinModel.fromMap(Map<String, dynamic> map) {
    return IzinModel(
      id: map['id'] ?? '',
      santriId: map['santriId'] ?? '',
      namaSantri: map['namaSantri'] ?? '',
      kelas: map['kelas'] ?? '',
      jenisIzin: map['jenisIzin'] ?? '',
      alasan: map['alasan'] ?? '',
      tanggalMulai: map['tanggalMulai'] ?? '',
      tanggalSelesai: map['tanggalSelesai'] ?? '',
      jumlahHari: map['jumlahHari'] ?? 0,
      statusIzin: map['statusIzin'] ?? 'menunggu',
      disetujuiOleh: map['disetujuiOleh'] ?? '',
      catatanUstadz: map['catatanUstadz'] ?? '',
      tanggalPengajuan: map['tanggalPengajuan'] != null
          ? DateTime.parse(map['tanggalPengajuan'])
          : DateTime.now(),
      sudahKembali: map['sudahKembali'] ?? false,
    );
  }

  IzinModel copyWith({
    String? statusIzin,
    String? disetujuiOleh,
    String? catatanUstadz,
    bool? sudahKembali,
  }) {
    return IzinModel(
      id: id,
      santriId: santriId,
      namaSantri: namaSantri,
      kelas: kelas,
      jenisIzin: jenisIzin,
      alasan: alasan,
      tanggalMulai: tanggalMulai,
      tanggalSelesai: tanggalSelesai,
      jumlahHari: jumlahHari,
      statusIzin: statusIzin ?? this.statusIzin,
      disetujuiOleh: disetujuiOleh ?? this.disetujuiOleh,
      catatanUstadz: catatanUstadz ?? this.catatanUstadz,
      tanggalPengajuan: tanggalPengajuan,
      sudahKembali: sudahKembali ?? this.sudahKembali,
    );
  }

  static Map<String, dynamic> getStatusInfo(String status) {
    switch (status) {
      case 'disetujui':
        return {'warna': 0xFF2E7D32, 'label': 'Disetujui', 'ikon': '✅'};
      case 'ditolak':
        return {'warna': 0xFFC62828, 'label': 'Ditolak', 'ikon': '❌'};
      default:
        return {'warna': 0xFFF57F17, 'label': 'Menunggu', 'ikon': '⏳'};
    }
  }
}

const List<String> jenisIzinList = [
  'Pulang ke Rumah',
  'Sakit',
  'Keperluan Keluarga',
  'Acara Keagamaan',
  'Keperluan Administrasi',
  'Lainnya',
];

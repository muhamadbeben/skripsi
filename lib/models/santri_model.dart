// ============================================================
// FILE: lib/models/santri_model.dart
// ============================================================

class SantriModel {
  final String id;
  final String nis;
  final String nama;
  final String jenisKelamin;
  final String kelas;
  final String status; // 'aktif' | 'alumni' | 'keluar'
  final String alamat;
  final String namaWali;
  final String noTeleponWali;
  final String tanggalLahir; // format: 'yyyy-MM-dd'
  final String kamar;
  final String tahunMasuk;

  // Field opsional sesuai desain halaman profil
  final String? fotoUrl;
  final String? bagian;
  final String? kategori;
  final String? noStanbuk;
  final String? tempatLahir;
  final String? jenjangPendidikan;
  final String? kelurahan;
  final String? kecamatan;
  final String? kabupaten;
  final String? provinsi;
  final String? noDewanHp;

  const SantriModel({
    required this.id,
    required this.nis,
    required this.nama,
    required this.jenisKelamin,
    required this.kelas,
    required this.status,
    required this.alamat,
    required this.namaWali,
    required this.noTeleponWali,
    required this.tanggalLahir,
    required this.kamar,
    required this.tahunMasuk,
    this.fotoUrl,
    this.bagian,
    this.kategori,
    this.noStanbuk,
    this.tempatLahir,
    this.jenjangPendidikan,
    this.kelurahan,
    this.kecamatan,
    this.kabupaten,
    this.provinsi,
    this.noDewanHp,
  });

  // --------------------------------------------------------
  // Konversi ke Map untuk Firestore
  // --------------------------------------------------------
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nis': nis,
      'nama': nama,
      'jenisKelamin': jenisKelamin,
      'kelas': kelas,
      'status': status,
      'alamat': alamat,
      'namaWali': namaWali,
      'noTeleponWali': noTeleponWali,
      'tanggalLahir': tanggalLahir,
      'kamar': kamar,
      'tahunMasuk': tahunMasuk,
      // Field opsional — hanya disimpan jika tidak null
      if (fotoUrl != null) 'fotoUrl': fotoUrl,
      if (bagian != null) 'bagian': bagian,
      if (kategori != null) 'kategori': kategori,
      if (noStanbuk != null) 'noStanbuk': noStanbuk,
      if (tempatLahir != null) 'tempatLahir': tempatLahir,
      if (jenjangPendidikan != null) 'jenjangPendidikan': jenjangPendidikan,
      if (kelurahan != null) 'kelurahan': kelurahan,
      if (kecamatan != null) 'kecamatan': kecamatan,
      if (kabupaten != null) 'kabupaten': kabupaten,
      if (provinsi != null) 'provinsi': provinsi,
      if (noDewanHp != null) 'noDewanHp': noDewanHp,
    };
  }

  // --------------------------------------------------------
  // Buat SantriModel dari Map Firestore
  // --------------------------------------------------------
  factory SantriModel.fromMap(Map<String, dynamic> map) {
    return SantriModel(
      id: map['id'] as String? ?? '',
      nis: map['nis'] as String? ?? '',
      nama: map['nama'] as String? ?? '',
      jenisKelamin: map['jenisKelamin'] as String? ?? 'L',
      kelas: map['kelas'] as String? ?? '',
      status: map['status'] as String? ?? 'aktif',
      alamat: map['alamat'] as String? ?? '',
      namaWali: map['namaWali'] as String? ?? '',
      noTeleponWali: map['noTeleponWali'] as String? ?? '',
      tanggalLahir: map['tanggalLahir'] as String? ?? '',
      kamar: map['kamar'] as String? ?? '',
      tahunMasuk: map['tahunMasuk'] as String? ?? '',
      fotoUrl: map['fotoUrl'] as String?,
      bagian: map['bagian'] as String?,
      kategori: map['kategori'] as String?,
      noStanbuk: map['noStanbuk'] as String?,
      tempatLahir: map['tempatLahir'] as String?,
      jenjangPendidikan: map['jenjangPendidikan'] as String?,
      kelurahan: map['kelurahan'] as String?,
      kecamatan: map['kecamatan'] as String?,
      kabupaten: map['kabupaten'] as String?,
      provinsi: map['provinsi'] as String?,
      noDewanHp: map['noDewanHp'] as String?,
    );
  }

  /// Buat salinan dengan field tertentu diubah
  SantriModel copyWith({
    String? id,
    String? nis,
    String? nama,
    String? jenisKelamin,
    String? kelas,
    String? status,
    String? alamat,
    String? namaWali,
    String? noTeleponWali,
    String? tanggalLahir,
    String? kamar,
    String? tahunMasuk,
    String? fotoUrl,
    String? bagian,
    String? kategori,
    String? noStanbuk,
    String? tempatLahir,
    String? jenjangPendidikan,
    String? kelurahan,
    String? kecamatan,
    String? kabupaten,
    String? provinsi,
    String? noDewanHp,
  }) {
    return SantriModel(
      id: id ?? this.id,
      nis: nis ?? this.nis,
      nama: nama ?? this.nama,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      kelas: kelas ?? this.kelas,
      status: status ?? this.status,
      alamat: alamat ?? this.alamat,
      namaWali: namaWali ?? this.namaWali,
      noTeleponWali: noTeleponWali ?? this.noTeleponWali,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      kamar: kamar ?? this.kamar,
      tahunMasuk: tahunMasuk ?? this.tahunMasuk,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      bagian: bagian ?? this.bagian,
      kategori: kategori ?? this.kategori,
      noStanbuk: noStanbuk ?? this.noStanbuk,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      jenjangPendidikan: jenjangPendidikan ?? this.jenjangPendidikan,
      kelurahan: kelurahan ?? this.kelurahan,
      kecamatan: kecamatan ?? this.kecamatan,
      kabupaten: kabupaten ?? this.kabupaten,
      provinsi: provinsi ?? this.provinsi,
      noDewanHp: noDewanHp ?? this.noDewanHp,
    );
  }
}

// ============================================================
// DATA DUMMY GLOBAL — digunakan di seluruh aplikasi
// Hapus / ganti dengan data Firebase nanti
// ============================================================
final List<SantriModel> dummySantriList = [
  const SantriModel(
    id: '1',
    nis: '12345678',
    nama: 'Tubagus Mochammad Qoewwato Ellah Faoqol Qoewwa Al Jab',
    jenisKelamin: 'L',
    kelas: '3',
    status: 'aktif',
    alamat: 'Krajan 1, RT 02 RW 01, Desa Bener',
    namaWali: 'Ahmad Faoqol',
    noTeleponWali: '089644409994',
    tanggalLahir: '2010-01-01',
    kamar: '13',
    tahunMasuk: '2023',
    bagian: '1.13',
    kategori: 'BIASA',
    noStanbuk: '0923823',
    tempatLahir: 'Salatiga',
    jenjangPendidikan: 'MA',
    kelurahan: 'Bener',
    kecamatan: 'Tengaran',
    kabupaten: 'Kabupaten Semarang',
    provinsi: 'Jawa Tengah',
    noDewanHp: '0812345678',
  ),
  const SantriModel(
    id: '2',
    nis: '23456789',
    nama: 'Fatimah Azzahra Nurul Hidayah',
    jenisKelamin: 'P',
    kelas: '2',
    status: 'aktif',
    alamat: 'Jl. Merdeka No. 5, RT 01 RW 02',
    namaWali: 'Muhammad Hidayah',
    noTeleponWali: '081234567890',
    tanggalLahir: '2011-06-15',
    kamar: '07',
    tahunMasuk: '2024',
    bagian: '2.07',
    kategori: 'BIASA',
    noStanbuk: '0924001',
    tempatLahir: 'Semarang',
    jenjangPendidikan: 'MTs',
    kelurahan: 'Kauman',
    kecamatan: 'Semarang Tengah',
    kabupaten: 'Kota Semarang',
    provinsi: 'Jawa Tengah',
    noDewanHp: '0812345679',
  ),
  const SantriModel(
    id: '3',
    nis: '34567890',
    nama: 'Ahmad Zulfikri Ramadhan',
    jenisKelamin: 'L',
    kelas: '1',
    status: 'aktif',
    alamat: 'Perum Griya Asri Blok B No. 12',
    namaWali: 'Zulkifli Ramadhan',
    noTeleponWali: '082345678901',
    tanggalLahir: '2012-03-22',
    kamar: '05',
    tahunMasuk: '2025',
    bagian: '1.05',
    kategori: 'BIASA',
    noStanbuk: '0925100',
    tempatLahir: 'Yogyakarta',
    jenjangPendidikan: 'MTs',
    kelurahan: 'Condongcatur',
    kecamatan: 'Depok',
    kabupaten: 'Sleman',
    provinsi: 'DI Yogyakarta',
    noDewanHp: '0812345680',
  ),
  const SantriModel(
    id: '4',
    nis: '45678901',
    nama: 'Siti Nur Aisyah',
    jenisKelamin: 'P',
    kelas: '3',
    status: 'alumni',
    alamat: 'Jl. Pahlawan No. 8',
    namaWali: 'Hadi Santoso',
    noTeleponWali: '083456789012',
    tanggalLahir: '2009-09-10',
    kamar: '12',
    tahunMasuk: '2022',
    bagian: '3.12',
    kategori: 'BIASA',
    noStanbuk: '0922500',
    tempatLahir: 'Solo',
    jenjangPendidikan: 'MA',
    kelurahan: 'Laweyan',
    kecamatan: 'Laweyan',
    kabupaten: 'Kota Surakarta',
    provinsi: 'Jawa Tengah',
    noDewanHp: '0812345681',
  ),
  const SantriModel(
    id: '5',
    nis: '56789012',
    nama: 'Muhammad Rizki Pratama',
    jenisKelamin: 'L',
    kelas: '2',
    status: 'keluar',
    alamat: 'Jl. Kenanga No. 3, RT 04',
    namaWali: 'Budi Pratama',
    noTeleponWali: '084567890123',
    tanggalLahir: '2010-12-05',
    kamar: '09',
    tahunMasuk: '2023',
    bagian: '2.09',
    kategori: 'BIASA',
    noStanbuk: '0923600',
    tempatLahir: 'Bandung',
    jenjangPendidikan: 'MTs',
    kelurahan: 'Sukasari',
    kecamatan: 'Sukasari',
    kabupaten: 'Kota Bandung',
    provinsi: 'Jawa Barat',
    noDewanHp: '0812345682',
  ),
];

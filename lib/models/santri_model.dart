class SantriModel {
  final String id;
  final String nis;
  final String nama;
  final String kelas;
  final String jenisKelamin;
  final String namaWali;
  final String noTeleponWali;
  final String email;
  final String role;

  const SantriModel({
    required this.id,
    required this.nis,
    required this.nama,
    this.kelas = 'N/A',
    required this.jenisKelamin,
    required this.namaWali,
    required this.noTeleponWali,
    required this.email,
    this.role = 'santri',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nis': nis,
      'nama': nama,
      'kelas': kelas,
      'jenisKelamin': jenisKelamin,
      'namaWali': namaWali,
      'noTeleponWali': noTeleponWali,
      'email': email,
      'role': role,
    };
  }

  factory SantriModel.fromMap(Map<String, dynamic> map) {
    return SantriModel(
      id: map['id'] ?? '',
      nis: map['nis'] ?? '',
      kelas: map['kelas'] ?? 'N/A',
      nama: map['nama'] ?? '',
      jenisKelamin: map['jenisKelamin'] ?? 'L',
      namaWali: map['namaWali'] ?? '',
      noTeleponWali: map['noTeleponWali'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'santri',
    );
  }
}

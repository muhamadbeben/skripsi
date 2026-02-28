// ============================================================
// FILE: lib/screens/dashboard_screen.dart
// ============================================================

import 'package:flutter/material.dart';
import '../models/santri_model.dart';
import 'santri_screen.dart';
import 'nilai_screen.dart';
import 'rapor_screen.dart';
import 'izin_screen.dart';
import 'prediksi_screen.dart';
import 'laporan_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens = [
    const _HomeTab(),
    const SantriScreen(),
    const PrediksiScreen(),
    const LaporanScreen(),
    const _ProfilSantriTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF1B5E20).withOpacity(0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Color(0xFF1B5E20)),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outlined),
            selectedIcon: Icon(Icons.people, color: Color(0xFF1B5E20)),
            label: 'Santri',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_outlined),
            selectedIcon: Icon(Icons.psychology, color: Color(0xFF1B5E20)),
            label: 'Prediksi',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart, color: Color(0xFF1B5E20)),
            label: 'Laporan',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: Icon(Icons.account_circle, color: Color(0xFF1B5E20)),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DATA BERITA PONDOK
// ============================================================
class _BeritaItem {
  final String judul;
  final String ringkasan;
  final String tanggal;
  final String kategori;
  final IconData icon;
  final Color color;

  const _BeritaItem({
    required this.judul,
    required this.ringkasan,
    required this.tanggal,
    required this.kategori,
    required this.icon,
    required this.color,
  });
}

const List<_BeritaItem> _daftarBerita = [
  _BeritaItem(
    judul: 'Haflah Akhirussanah Tahun Ajaran 2024/2025',
    ringkasan:
        'Pondok Pesantren Khoirul Huda sukses menggelar Haflah Akhirussanah dengan penampilan santri terbaik dan wisuda kelas akhir.',
    tanggal: '20 Feb 2025',
    kategori: 'Acara',
    icon: Icons.celebration,
    color: Color(0xFF6A1B9A),
  ),
  _BeritaItem(
    judul: 'Santri Raih Juara I MTQ Tingkat Kabupaten',
    ringkasan:
        'Santri Khoirul Huda berhasil meraih juara pertama cabang Tilawah Quran pada ajang MTQ tingkat Kabupaten tahun ini.',
    tanggal: '15 Feb 2025',
    kategori: 'Prestasi',
    icon: Icons.emoji_events,
    color: Color(0xFFF57F17),
  ),
  _BeritaItem(
    judul: 'Kegiatan Pesantren Kilat Ramadhan 1446 H',
    ringkasan:
        'Menyambut bulan suci Ramadhan, pondok menyelenggarakan pesantren kilat untuk santri baru dan masyarakat sekitar.',
    tanggal: '10 Feb 2025',
    kategori: 'Kegiatan',
    icon: Icons.mosque,
    color: Color(0xFF1B5E20),
  ),
  _BeritaItem(
    judul: 'Penandatanganan MoU dengan Universitas Islam Negeri',
    ringkasan:
        'Pondok Pesantren Khoirul Huda resmi menjalin kerjasama dengan UIN untuk program beasiswa santri berprestasi.',
    tanggal: '05 Feb 2025',
    kategori: 'Kerjasama',
    icon: Icons.handshake,
    color: Color(0xFF1565C0),
  ),
  _BeritaItem(
    judul: 'Pelatihan Wirausaha Santri Angkatan ke-3',
    ringkasan:
        'Program pemberdayaan ekonomi santri dilanjutkan dengan pelatihan keterampilan wirausaha bersama narasumber berpengalaman.',
    tanggal: '28 Jan 2025',
    kategori: 'Program',
    icon: Icons.store,
    color: Color(0xFF00838F),
  ),
];

// ============================================================
// HOME TAB
// ============================================================
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Assalamu'alaikum,";
    if (hour < 15) return 'Selamat Siang,';
    if (hour < 18) return 'Selamat Sore,';
    return 'Selamat Malam,';
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E20),
                foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ---- HEADER GRADIENT ----
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getGreeting(),
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 14),
                            ),
                            const Text(
                              'Ustadz Admin',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // Icon pengaturan (menggantikan icon lonceng & icon person)
                        GestureDetector(
                          onTap: () => _logout(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.settings,
                                color: Colors.white, size: 22),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.mosque, color: Colors.white),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Pondok Pesantren Khoirul Huda',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Sistem Prediksi Akademik Santri — Decision Tree',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Menu Utama'),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.9,
                      children: [
                        _MenuCard(
                          icon: Icons.people,
                          label: 'Data Santri',
                          color: const Color(0xFF1B5E20),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SantriScreen())),
                        ),
                        _MenuCard(
                          icon: Icons.grade,
                          label: 'Input Nilai',
                          color: const Color(0xFF1565C0),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const NilaiScreen())),
                        ),
                        _MenuCard(
                          icon: Icons.description,
                          label: 'Rapor',
                          color: const Color(0xFF6A1B9A),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RaporScreen())),
                        ),
                        _MenuCard(
                          icon: Icons.assignment_late,
                          label: 'Izin Santri',
                          color: const Color(0xFFE65100),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const IzinScreen())),
                        ),
                        _MenuCard(
                          icon: Icons.psychology,
                          label: 'Prediksi ML',
                          color: const Color(0xFF00838F),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const PrediksiScreen())),
                        ),
                        _MenuCard(
                          icon: Icons.bar_chart,
                          label: 'Laporan',
                          color: const Color(0xFF558B2F),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LaporanScreen())),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00838F), Color(0xFF00695C)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.psychology, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Model Decision Tree',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _metricRow('Akurasi Model', '87.3%'),
                          _metricRow('Presisi', '85.6%'),
                          _metricRow('Recall', '84.1%'),
                          _metricRow('F1-Score', '84.8%'),
                          _metricRow('AUC-ROC', '91.2%'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ---- BERITA PONDOK ----
                    const SectionHeader(
                        title: 'Berita Seputar Pondok Pesantren Khoirul Huda'),
                    const SizedBox(height: 12),
                    ..._daftarBerita
                        .map((berita) => _BeritaCard(berita: berita)),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ============================================================
// BERITA CARD WIDGET
// ============================================================
class _BeritaCard extends StatelessWidget {
  final _BeritaItem berita;
  const _BeritaCard({required this.berita});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header berwarna
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: berita.color.withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: berita.color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(berita.icon, color: berita.color, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    berita.judul,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Isi berita
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  berita.ringkasan,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: berita.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        berita.kategori,
                        style: TextStyle(
                          color: berita.color,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 12, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          berita.tanggal,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PROFIL SANTRI TAB
// ============================================================
class _ProfilSantriTab extends StatefulWidget {
  const _ProfilSantriTab();

  @override
  State<_ProfilSantriTab> createState() => _ProfilSantriTabState();
}

class _ProfilSantriTabState extends State<_ProfilSantriTab> {
  String _searchQuery = '';
  String _filterStatus = 'semua';

  List<SantriModel> get _filteredList {
    return dummySantriList.where((s) {
      final matchSearch =
          s.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.nis.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchStatus = _filterStatus == 'semua' || s.status == _filterStatus;
      return matchSearch && matchStatus;
    }).toList();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'aktif':
        return const Color(0xFF1B5E20);
      case 'alumni':
        return const Color(0xFF1565C0);
      default:
        return Colors.red.shade700;
    }
  }

  void _showProfilDetail(SantriModel santri) {
    final statusColor = _statusColor(santri.status);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: statusColor.withOpacity(0.15),
                      child: Text(
                        santri.nama[0],
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      santri.nama,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            santri.status.toUpperCase(),
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: (santri.jenisKelamin == 'L'
                                    ? Colors.blue
                                    : Colors.pink)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            santri.jenisKelamin == 'L'
                                ? '♂ Laki-laki'
                                : '♀ Perempuan',
                            style: TextStyle(
                              color: santri.jenisKelamin == 'L'
                                  ? Colors.blue.shade700
                                  : Colors.pink.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _sectionLabel('Data Akademik'),
              _infoRow(Icons.badge_outlined, 'NIS', santri.nis),
              if (santri.noStanbuk != null && santri.noStanbuk!.isNotEmpty)
                _infoRow(Icons.numbers, 'No. Stanbuk', santri.noStanbuk!),
              _infoRow(Icons.class_outlined, 'Kelas', santri.kelas),
              if (santri.jenjangPendidikan != null &&
                  santri.jenjangPendidikan!.isNotEmpty)
                _infoRow(Icons.school_outlined, 'Jenjang Pendidikan',
                    santri.jenjangPendidikan!),
              if (santri.bagian != null && santri.bagian!.isNotEmpty)
                _infoRow(Icons.group_work_outlined, 'Bagian', santri.bagian!),
              if (santri.kategori != null && santri.kategori!.isNotEmpty)
                _infoRow(Icons.label_outlined, 'Kategori', santri.kategori!),
              _infoRow(Icons.calendar_month_outlined, 'Tahun Masuk',
                  santri.tahunMasuk),
              _infoRow(Icons.door_front_door_outlined, 'Kamar', santri.kamar),
              const SizedBox(height: 12),
              _sectionLabel('Data Pribadi'),
              _infoRow(Icons.cake_outlined, 'Tanggal Lahir',
                  _formatTanggal(santri.tanggalLahir)),
              if (santri.tempatLahir != null && santri.tempatLahir!.isNotEmpty)
                _infoRow(Icons.location_city_outlined, 'Tempat Lahir',
                    santri.tempatLahir!),
              _infoRow(Icons.home_outlined, 'Alamat', santri.alamat),
              if (santri.kelurahan != null && santri.kelurahan!.isNotEmpty)
                _infoRow(Icons.place_outlined, 'Kelurahan', santri.kelurahan!),
              if (santri.kecamatan != null && santri.kecamatan!.isNotEmpty)
                _infoRow(Icons.map_outlined, 'Kecamatan', santri.kecamatan!),
              if (santri.kabupaten != null && santri.kabupaten!.isNotEmpty)
                _infoRow(
                    Icons.location_on_outlined, 'Kabupaten', santri.kabupaten!),
              if (santri.provinsi != null && santri.provinsi!.isNotEmpty)
                _infoRow(Icons.flag_outlined, 'Provinsi', santri.provinsi!),
              const SizedBox(height: 12),
              _sectionLabel('Data Wali'),
              _infoRow(Icons.person_outline, 'Nama Wali', santri.namaWali),
              _infoRow(Icons.phone_outlined, 'No. Telepon Wali',
                  santri.noTeleponWali),
              if (santri.noDewanHp != null && santri.noDewanHp!.isNotEmpty)
                _infoRow(Icons.contact_phone_outlined, 'No. Dewan HP',
                    santri.noDewanHp!),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTanggal(String raw) {
    if (raw.isEmpty) return '-';
    try {
      final parts = raw.split('-');
      if (parts.length != 3) return raw;
      const bulan = [
        '',
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember'
      ];
      final b = int.tryParse(parts[1]) ?? 0;
      return '${parts[2]} ${bulan[b]} ${parts[0]}';
    } catch (_) {
      return raw;
    }
  }

  Widget _sectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1B5E20),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF1B5E20), size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? '-' : value,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredList;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.account_circle, color: Colors.white, size: 28),
                      SizedBox(width: 10),
                      Text(
                        'Profil Santri',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${dummySantriList.length} santri terdaftar',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Cari nama atau NIS santri...',
                      hintStyle:
                          TextStyle(color: Colors.grey.shade400, fontSize: 13),
                      prefixIcon:
                          const Icon(Icons.search, color: Color(0xFF1B5E20)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['semua', 'aktif', 'alumni', 'keluar'].map((f) {
                    final isSelected = _filterStatus == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(
                          f[0].toUpperCase() + f.substring(1),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF1B5E20),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _filterStatus = f),
                        selectedColor: const Color(0xFF1B5E20),
                        backgroundColor: Colors.white,
                        checkmarkColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF1B5E20)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off,
                              size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          Text('Santri tidak ditemukan',
                              style: TextStyle(color: Colors.grey.shade500)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final santri = filtered[i];
                        final statusColor = _statusColor(santri.status);
                        return GestureDetector(
                          onTap: () => _showProfilDetail(santri),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor:
                                      statusColor.withOpacity(0.15),
                                  child: Text(
                                    santri.nama[0],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: statusColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        santri.nama,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Kelas ${santri.kelas} • NIS: ${santri.nis}',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'Kamar ${santri.kamar} • ${santri.jenisKelamin == 'L' ? 'Laki-laki' : 'Perempuan'}',
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        santri.status.toUpperCase(),
                                        style: TextStyle(
                                          color: statusColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Icon(Icons.chevron_right,
                                        color: Colors.grey.shade400, size: 18),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// REUSABLE WIDGETS
// ============================================================

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1B5E20),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

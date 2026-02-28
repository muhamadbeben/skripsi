// ============================================================
// FILE   : lib/screens/rapor_screen.dart
// IMPORT : pastikan rapor_pdf_service.dart ada di lib/services/
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/rapor_model.dart';
import '../services/rapor_pdf_service.dart';

// ============================================================
// HELPER PREDIKAT
// ============================================================
class _Predikat {
  static String getLabel(double nilai) {
    if (nilai >= 90) return 'Mumtaz';
    if (nilai >= 80) return 'Jayyid Jiddan';
    if (nilai >= 70) return 'Jayyid';
    if (nilai >= 60) return 'Maqbul';
    return 'Rasib';
  }

  static String getArabic(double nilai) {
    if (nilai >= 90) return 'ممتاز';
    if (nilai >= 80) return 'جيد جداً';
    if (nilai >= 70) return 'جيد';
    if (nilai >= 60) return 'مقبول';
    return 'راسب';
  }

  static Color getColor(double nilai) {
    if (nilai >= 90) return const Color(0xFF00695C);
    if (nilai >= 80) return const Color(0xFF1565C0);
    if (nilai >= 70) return const Color(0xFF2E7D32);
    if (nilai >= 60) return const Color(0xFFF57F17);
    return const Color(0xFFC62828);
  }
}

String _formatTanggal(DateTime dt) {
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
    'Desember',
  ];
  return '${dt.day} ${bulan[dt.month]} ${dt.year}';
}

// ============================================================
// DATA DUMMY
// ============================================================
final List<RaporModel> _dummyRaporList = [
  RaporModel(
    id: 'rapor_1',
    santriId: '2024001',
    namaSantri: 'Ahmad Fauzi',
    kelas: 'VIII A',
    semester: 'Semester 1',
    tahunAjaran: '2024/2025',
    nilaiMataPelajaran: {
      "Qur'an Hadits": 84.0,
      "Aqidah Akhlak": 88.0,
      "Fiqih": 80.0,
      "Bahasa Arab": 81.0,
      "Sejarah Kebudayaan Islam": 86.0,
      "Mulok/Tahfidz Al-Qur'an": 88.0,
      "Pend. Kewarganegaraan": 78.0,
      "Bahasa Indonesia": 80.0,
      "Bahasa Inggris": 75.0,
      "Matematika": 72.0,
      "IPA - Fisika": 70.0,
      "IPA - Biologi": 74.0,
      "IPS Terpadu": 77.0,
      "Teknologi Informasi": 82.0,
      "Seni Budaya & Keterampilan": 79.0,
      "Penjas & Kesehatan": 76.0,
      "Nahwu": 79.0,
      "Sharaf": 77.0,
      "Tajwid": 85.0,
      "Praktek Ibadah": 80.0,
      "Mahfuzot": 83.0,
    },
    nilaiRataRata: 79.8,
    rankKelas: 3,
    totalSiswaKelas: 30,
    predikat: 'B',
    catatanWaliKelas: 'Ahmad Fauzi menunjukkan perkembangan yang sangat baik '
        'dalam hafalan Al-Qur\'an. Perlu ditingkatkan pemahaman Matematika dan IPA.',
    tanggalRapor: DateTime(2024, 12, 15),
  ),
  RaporModel(
    id: 'rapor_2',
    santriId: '2024002',
    namaSantri: 'Siti Aminah',
    kelas: 'VII B',
    semester: 'Semester 1',
    tahunAjaran: '2024/2025',
    nilaiMataPelajaran: {
      "Qur'an Hadits": 95.0,
      "Aqidah Akhlak": 93.0,
      "Fiqih": 88.0,
      "Bahasa Arab": 90.0,
      "Sejarah Kebudayaan Islam": 91.0,
      "Mulok/Tahfidz Al-Qur'an": 94.0,
      "Pend. Kewarganegaraan": 85.0,
      "Bahasa Indonesia": 88.0,
      "Bahasa Inggris": 82.0,
      "Matematika": 80.0,
      "IPA - Fisika": 78.0,
      "IPA - Biologi": 81.0,
      "IPS Terpadu": 84.0,
      "Teknologi Informasi": 87.0,
      "Seni Budaya & Keterampilan": 86.0,
      "Penjas & Kesehatan": 83.0,
      "Nahwu": 86.0,
      "Sharaf": 84.0,
      "Tajwid": 93.0,
      "Praktek Ibadah": 90.0,
      "Mahfuzot": 89.0,
    },
    nilaiRataRata: 87.6,
    rankKelas: 1,
    totalSiswaKelas: 28,
    predikat: 'A',
    catatanWaliKelas: 'Siti Aminah adalah santri berprestasi dan teladan. '
        'Pertahankan semangat belajar dan terus tingkatkan hafalan.',
    tanggalRapor: DateTime(2024, 12, 15),
  ),
  RaporModel(
    id: 'rapor_3',
    santriId: '2024003',
    namaSantri: 'Muhammad Ridwan',
    kelas: 'IX A',
    semester: 'Semester 1',
    tahunAjaran: '2024/2025',
    nilaiMataPelajaran: {
      "Qur'an Hadits": 65.0,
      "Aqidah Akhlak": 68.0,
      "Fiqih": 60.0,
      "Bahasa Arab": 63.0,
      "Sejarah Kebudayaan Islam": 67.0,
      "Mulok/Tahfidz Al-Qur'an": 65.0,
      "Pend. Kewarganegaraan": 62.0,
      "Bahasa Indonesia": 64.0,
      "Bahasa Inggris": 58.0,
      "Matematika": 55.0,
      "IPA - Fisika": 57.0,
      "IPA - Biologi": 60.0,
      "IPS Terpadu": 63.0,
      "Teknologi Informasi": 65.0,
      "Seni Budaya & Keterampilan": 62.0,
      "Penjas & Kesehatan": 66.0,
      "Nahwu": 57.0,
      "Sharaf": 60.0,
      "Tajwid": 62.0,
      "Praktek Ibadah": 64.0,
      "Mahfuzot": 58.0,
    },
    nilaiRataRata: 62.0,
    rankKelas: 25,
    totalSiswaKelas: 30,
    predikat: 'D',
    catatanWaliKelas:
        'Muhammad Ridwan perlu mendapat perhatian dan bimbingan lebih. '
        'Kehadiran dan semangat belajar perlu ditingkatkan secara konsisten.',
    tanggalRapor: DateTime(2024, 12, 15),
  ),
];

const Map<String, List<String>> _kelompokMapel = {
  "Al-Qur'an & Ilmu Agama": [
    "Qur'an Hadits",
    "Aqidah Akhlak",
    "Fiqih",
    "Bahasa Arab",
    "Sejarah Kebudayaan Islam",
    "Mulok/Tahfidz Al-Qur'an",
  ],
  'Pendidikan Umum': [
    "Pend. Kewarganegaraan",
    "Bahasa Indonesia",
    "Bahasa Inggris",
    "Matematika",
    "IPA - Fisika",
    "IPA - Biologi",
    "IPS Terpadu",
    "Teknologi Informasi",
    "Seni Budaya & Keterampilan",
    "Penjas & Kesehatan",
  ],
  'Pendidikan Kepesantrenan': [
    "Nahwu",
    "Sharaf",
    "Tajwid",
    "Praktek Ibadah",
    "Mahfuzot",
  ],
};

// ============================================================
// RAPOR SCREEN (list rapor)
// ============================================================
class RaporScreen extends StatefulWidget {
  const RaporScreen({super.key});

  @override
  State<RaporScreen> createState() => _RaporScreenState();
}

class _RaporScreenState extends State<RaporScreen> {
  String _filterSemester = 'Semua';
  String _filterTahun = 'Semua';

  List<RaporModel> get _filtered => _dummyRaporList.where((r) {
        final okSmt =
            _filterSemester == 'Semua' || r.semester == _filterSemester;
        final okThn = _filterTahun == 'Semua' || r.tahunAjaran == _filterTahun;
        return okSmt && okThn;
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterBar(),
          Expanded(
            child: _filtered.isEmpty
                ? _buildEmpty()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _RaporCard(
                      rapor: _filtered[i],
                      onTap: () => _openDetail(context, _filtered[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D3B1E), Color(0xFF1B5E20), Color(0xFF2E7D32)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  IconButton(
                    icon:
                        const Icon(Icons.search, color: Colors.white, size: 22),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'ﷺ  Pondok Pesantren Khoirul Huda',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Rapor Digital',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_dummyRaporList.length} rapor tersedia',
                      style:
                          const TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Filter Bar ──────────────────────────────────────────────
  Widget _buildFilterBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: _FilterDropdown(
              icon: Icons.layers_outlined,
              value: _filterSemester,
              items: ['Semua', ...List.generate(6, (i) => 'Semester ${i + 1}')],
              onChanged: (v) => setState(() => _filterSemester = v!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _FilterDropdown(
              icon: Icons.calendar_month_outlined,
              value: _filterTahun,
              items: const ['Semua', '2025/2026', '2024/2025', '2023/2024'],
              onChanged: (v) => setState(() => _filterTahun = v!),
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty State ──────────────────────────────────────────────
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_outlined, size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('Tidak ada rapor ditemukan',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // ── Navigasi ke Detail ───────────────────────────────────────
  void _openDetail(BuildContext context, RaporModel rapor) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => _DetailRaporPage(rapor: rapor),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
      ),
    );
  }
}

// ============================================================
// FILTER DROPDOWN
// ============================================================
class _FilterDropdown extends StatelessWidget {
  final IconData icon;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF1B5E20)),
          const SizedBox(width: 6),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
                items: items
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// RAPOR CARD (item list)
// ============================================================
class _RaporCard extends StatelessWidget {
  final RaporModel rapor;
  final VoidCallback onTap;

  const _RaporCard({required this.rapor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final rata = rapor.nilaiRataRata;
    final predikat = _Predikat.getLabel(rata);
    final arabic = _Predikat.getArabic(rata);
    final color = _Predikat.getColor(rata);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Garis warna atas
            Container(
              height: 5,
              decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [color, color.withOpacity(0.4)]),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris nama + predikat
                  Row(
                    children: [
                      // Avatar inisial
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            rapor.namaSantri[0],
                            style: TextStyle(
                                color: color,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(rapor.namaSantri,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 2),
                            Text(
                              '${rapor.kelas}  ·  ${rapor.semester}  ·  ${rapor.tahunAjaran}',
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      // Badge predikat
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: color.withOpacity(0.25)),
                        ),
                        child: Column(
                          children: [
                            Text(arabic,
                                style: TextStyle(
                                    color: color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                            Text(predikat,
                                style: TextStyle(
                                    color: color.withOpacity(0.8),
                                    fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Statistik + tombol detail
                  Row(
                    children: [
                      _StatPill(
                        icon: Icons.assessment_outlined,
                        label: 'Rata-rata',
                        value: rata.toStringAsFixed(1),
                        color: color,
                      ),
                      const SizedBox(width: 8),
                      _StatPill(
                        icon: Icons.emoji_events_outlined,
                        label: 'Peringkat',
                        value: '${rapor.rankKelas}/${rapor.totalSiswaKelas}',
                        color: const Color(0xFF1565C0),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B5E20),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Text('Lihat Detail',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_ios,
                                size: 10, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: rata / 100,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade100,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stat Pill ────────────────────────────────────────────────
class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatPill({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 13)),
              Text(label,
                  style:
                      TextStyle(color: color.withOpacity(0.7), fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DETAIL RAPOR PAGE
// ============================================================
class _DetailRaporPage extends StatefulWidget {
  final RaporModel rapor;
  const _DetailRaporPage({required this.rapor});

  @override
  State<_DetailRaporPage> createState() => _DetailRaporPageState();
}

class _DetailRaporPageState extends State<_DetailRaporPage> {
  bool _isCetak = false;
  bool _isShare = false;

  // ── Handler Cetak ───────────────────────────────────────────
  Future<void> _handleCetak() async {
    setState(() => _isCetak = true);
    try {
      await RaporPdfService.cetakRapor(widget.rapor);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal cetak: $e'),
          backgroundColor: Colors.red,
        ));
      }
    } finally {
      if (mounted) setState(() => _isCetak = false);
    }
  }

  // ── Handler Share ───────────────────────────────────────────
  Future<void> _handleShare() async {
    setState(() => _isShare = true);
    try {
      await RaporPdfService.shareRapor(widget.rapor);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal bagikan: $e'),
          backgroundColor: Colors.red,
        ));
      }
    } finally {
      if (mounted) setState(() => _isShare = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rapor = widget.rapor;
    final rata = rapor.nilaiRataRata;
    final color = _Predikat.getColor(rata);
    final predikat = _Predikat.getLabel(rata);
    final arabic = _Predikat.getArabic(rata);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar ──
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: const Color(0xFF1B5E20),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              // Tombol share
              IconButton(
                tooltip: 'Bagikan Rapor',
                onPressed: _isShare ? null : _handleShare,
                icon: _isShare
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.share_outlined, color: Colors.white),
              ),
              // Tombol cetak
              IconButton(
                tooltip: 'Cetak Rapor',
                onPressed: _isCetak ? null : _handleCetak,
                icon: _isCetak
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.print_outlined, color: Colors.white),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0D3B1E),
                      Color(0xFF1B5E20),
                      Color(0xFF388E3C),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo + nama pesantren
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.mosque,
                                  color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pondok Pesantren Khoirul Huda',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                                Text('Laporan Hasil Belajar Santri',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Nama + predikat
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(rapor.namaSantri,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    spacing: 6,
                                    children: [
                                      _HeaderChip(rapor.kelas),
                                      _HeaderChip(rapor.semester),
                                      _HeaderChip(rapor.tahunAjaran),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.3)),
                              ),
                              child: Column(
                                children: [
                                  Text(arabic,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold)),
                                  Text(predikat,
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 11)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Body ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kartu ringkasan (rata-rata, peringkat, predikat)
                  Row(
                    children: [
                      Expanded(
                          child: _SummaryCard(
                              icon: Icons.assessment_rounded,
                              label: 'Rata-rata',
                              value: rata.toStringAsFixed(1),
                              color: color)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _SummaryCard(
                              icon: Icons.emoji_events_rounded,
                              label: 'Peringkat',
                              value:
                                  '${rapor.rankKelas} / ${rapor.totalSiswaKelas}',
                              color: const Color(0xFF1565C0))),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _SummaryCard(
                              icon: Icons.military_tech_rounded,
                              label: 'Predikat',
                              value: arabic,
                              subtitle: predikat,
                              color: color)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Nilai per kelompok mapel
                  ..._kelompokMapel.entries.map((entry) {
                    final mapelList = entry.value
                        .where((m) => rapor.nilaiMataPelajaran.containsKey(m))
                        .toList();
                    if (mapelList.isEmpty) return const SizedBox.shrink();
                    return _KelompokNilaiCard(
                      judul: entry.key,
                      mapelList: mapelList,
                      nilaiMap: rapor.nilaiMataPelajaran,
                    );
                  }),

                  const SizedBox(height: 8),

                  // Catatan wali kelas
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.07),
                            blurRadius: 10,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1B5E20).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                  Icons.record_voice_over_outlined,
                                  color: Color(0xFF1B5E20),
                                  size: 18),
                            ),
                            const SizedBox(width: 10),
                            const Text('Catatan Wali Kelas',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF1B5E20))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FFF8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color:
                                    const Color(0xFF1B5E20).withOpacity(0.15)),
                          ),
                          child: Text(
                            '"${rapor.catatanWaliKelas}"',
                            style: const TextStyle(
                                fontSize: 13,
                                height: 1.6,
                                fontStyle: FontStyle.italic,
                                color: Color(0xFF333333)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Tanggal: ${_formatTanggal(rapor.tanggalRapor)}',
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tombol Cetak / Unduh
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      onPressed: _isCetak ? null : _handleCetak,
                      icon: _isCetak
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.print_outlined),
                      label: Text(
                        _isCetak
                            ? 'Mempersiapkan PDF...'
                            : 'Cetak / Unduh Rapor',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Tombol Share
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1B5E20),
                        side: const BorderSide(
                            color: Color(0xFF1B5E20), width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: _isShare ? null : _handleShare,
                      icon: _isShare
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  color: Color(0xFF1B5E20), strokeWidth: 2))
                          : const Icon(Icons.share_outlined),
                      label: Text(
                        _isShare
                            ? 'Mempersiapkan...'
                            : 'Bagikan ke Wali Santri',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// WIDGET KECIL
// ============================================================

// Header chip (kelas / semester / tahun)
class _HeaderChip extends StatelessWidget {
  final String label;
  const _HeaderChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 11)),
    );
  }
}

// Summary Card (rata-rata / peringkat / predikat)
class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String? subtitle;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 18)),
          if (subtitle != null)
            Text(subtitle!,
                style: TextStyle(color: color.withOpacity(0.7), fontSize: 10)),
          Text(label,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
        ],
      ),
    );
  }
}

// Kelompok Nilai Card
class _KelompokNilaiCard extends StatelessWidget {
  final String judul;
  final List<String> mapelList;
  final Map<String, double> nilaiMap;

  const _KelompokNilaiCard({
    required this.judul,
    required this.mapelList,
    required this.nilaiMap,
  });

  @override
  Widget build(BuildContext context) {
    final vals = mapelList.map((m) => nilaiMap[m] ?? 0.0).toList();
    final rataKelompok = vals.reduce((a, b) => a + b) / vals.length;
    final colorK = _Predikat.getColor(rataKelompok);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header kelompok
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              color: colorK.withOpacity(0.07),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                Container(
                  width: 5,
                  height: 18,
                  decoration: BoxDecoration(
                    color: colorK,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(judul,
                      style: TextStyle(
                          color: colorK,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorK.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Rata: ${rataKelompok.toStringAsFixed(1)}',
                    style: TextStyle(
                        color: colorK,
                        fontWeight: FontWeight.bold,
                        fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          // Baris per mapel
          ...mapelList.asMap().entries.map((entry) {
            final index = entry.key;
            final mapel = entry.value;
            final nilai = nilaiMap[mapel] ?? 0.0;
            final color = _Predikat.getColor(nilai);
            final isLast = index == mapelList.length - 1;

            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(mapel,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500)),
                      ),
                      Expanded(
                        flex: 5,
                        child: Row(
                          children: [
                            // Progress bar
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(4)),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: nilai / 100,
                                    child: Container(
                                      height: 8,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          color.withOpacity(0.7),
                                          color,
                                        ]),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 36,
                              child: Text(
                                nilai.toStringAsFixed(0),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                _Predikat.getArabic(nilai),
                                style: TextStyle(
                                    color: color,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Divider(
                      height: 1,
                      color: Colors.grey.shade100,
                      indent: 16,
                      endIndent: 16),
              ],
            );
          }),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

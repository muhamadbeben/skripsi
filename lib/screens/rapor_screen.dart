import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/rapor_model.dart';
import '../services/rapor_pdf_service.dart';
import '../services/rapor_service.dart';

const Map<String, List<String>> mapelPerKategori = {
  "Al-Qur'an & Tahfidz": [
    'Tahfidz Al-Qur\'an',
  ],
  'Fiqih & Ushul': [
    'Fiqih',
  ],
  'Bahasa Arab & Nahwu Sharaf': [
    'Nahwu',
  ],
  'Ilmu Agama Lainnya': [
    'Aqidah / Tauhid',
  ],
};

class _Predikat {
  static String getLabel(double nilai) {
    if (nilai >= 90) return 'Istimewa';
    if (nilai >= 80) return 'Sangat Baik';
    if (nilai >= 70) return 'Baik';
    if (nilai >= 60) return 'Cukup';
    return 'Gagal';
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

class RaporScreen extends StatefulWidget {
  final String? userRole;
  final String? currentUserUid;

  const RaporScreen({super.key, this.userRole, this.currentUserUid});

  @override
  State<RaporScreen> createState() => _RaporScreenState();
}

class _RaporScreenState extends State<RaporScreen> {
  final RaporService _raporService = RaporService();
  String _filterSemester = 'Semua';
  String _filterTahun = 'Semua';

  @override
  Widget build(BuildContext context) {
    // Gunakan UID dari widget atau langsung dari Auth jika widget kosong
    String? effectiveUid =
        widget.currentUserUid ?? FirebaseAuth.instance.currentUser?.uid;

    // Tentukan filter ID. Jika admin, ini akan null (melihat semua).
    // Jika santri, ini berisi UID miliknya.
    String? santriIdFilter =
        (widget.userRole == 'santri') ? effectiveUid : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterBar(),
          Expanded(
            child: StreamBuilder<List<RaporModel>>(
              stream: _raporService.getRaporStream(
                semester: _filterSemester,
                tahunAjaran: _filterTahun,
                santriId: santriIdFilter,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Terjadi kesalahan data'));
                }

                // Ambil data asli dari database
                List<RaporModel> raporList = snapshot.data ?? [];

                // DOUBLE CHECK: Filter di sisi klien jika role-nya santri
                // Ini memastikan meskipun query Firebase bocor, UI tetap menyaring
                if (widget.userRole == 'santri') {
                  raporList = raporList
                      .where((r) => r.santriId == effectiveUid)
                      .toList();
                }

                if (raporList.isEmpty) {
                  return _buildEmpty();
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: raporList.length,
                  itemBuilder: (_, i) => _RaporCard(
                    rapor: raporList[i],
                    onTap: () => _openDetail(context, raporList[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

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
                    StreamBuilder<List<RaporModel>>(
                      stream: _raporService.getRaporStream(),
                      builder: (context, snapshot) {
                        final count = snapshot.data?.length ?? 0;
                        return Text(
                          '$count rapor tersedia',
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 13),
                        );
                      },
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

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_outlined, size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('Tidak ada data rapor ditemukan',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

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

class _FilterDropdown extends StatelessWidget {
  final IconData icon;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown(
      {required this.icon,
      required this.value,
      required this.items,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200)),
      child: Row(children: [
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
                    onChanged: onChanged)))
      ]),
    );
  }
}

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
                  offset: const Offset(0, 4))
            ]),
        child: Column(children: [
          Container(
              height: 5,
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [color, color.withOpacity(0.4)]),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)))),
          Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              shape: BoxShape.circle),
                          child: Center(
                              child: Text(
                                  rapor.namaSantri.isNotEmpty
                                      ? rapor.namaSantri[0]
                                      : '?',
                                  style: TextStyle(
                                      color: color,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)))),
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
                                    color: Colors.grey.shade500, fontSize: 12))
                          ])),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(14),
                              border:
                                  Border.all(color: color.withOpacity(0.25))),
                          child: Column(children: [
                            Text(arabic,
                                style: TextStyle(
                                    color: color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                            Text(predikat,
                                style: TextStyle(
                                    color: color.withOpacity(0.8),
                                    fontSize: 10))
                          ]))
                    ]),
                    const SizedBox(height: 14),
                    Row(children: [
                      _StatPill(
                          icon: Icons.assessment_outlined,
                          label: 'Rata-rata',
                          value: rata.toStringAsFixed(1),
                          color: color),
                      const Spacer(),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                              color: const Color(0xFF1B5E20),
                              borderRadius: BorderRadius.circular(20)),
                          child: const Row(children: [
                            Text('Lihat Detail',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_ios,
                                size: 10, color: Colors.white)
                          ]))
                    ]),
                    const SizedBox(height: 12),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                            value: rata / 100,
                            minHeight: 6,
                            backgroundColor: Colors.grey.shade100,
                            valueColor: AlwaysStoppedAnimation<Color>(color)))
                  ]))
        ]),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatPill(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 13)),
            Text(label,
                style: TextStyle(color: color.withOpacity(0.7), fontSize: 10))
          ])
        ]));
  }
}

class _DetailRaporPage extends StatefulWidget {
  final RaporModel rapor;
  const _DetailRaporPage({required this.rapor});
  @override
  State<_DetailRaporPage> createState() => _DetailRaporPageState();
}

class _DetailRaporPageState extends State<_DetailRaporPage> {
  bool _isCetak = false;
  bool _isShare = false;

  Future<void> _handleCetak() async {
    setState(() => _isCetak = true);
    try {
      await RaporPdfService.cetakRapor(widget.rapor);
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal cetak: $e')));
    } finally {
      if (mounted) setState(() => _isCetak = false);
    }
  }

  Future<void> _handleShare() async {
    setState(() => _isShare = true);
    try {
      await RaporPdfService.shareRapor(widget.rapor);
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal share: $e')));
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
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: const Color(0xFF1B5E20),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context)),
            actions: [
              IconButton(
                  tooltip: 'Bagikan',
                  onPressed: _isShare ? null : _handleShare,
                  icon: const Icon(Icons.share_outlined, color: Colors.white)),
              IconButton(
                  tooltip: 'Cetak',
                  onPressed: _isCetak ? null : _handleCetak,
                  icon: const Icon(Icons.print_outlined, color: Colors.white))
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
                      Color(0xFF388E3C)
                    ])),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.mosque,
                                  color: Colors.white, size: 24)),
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
                                        color: Colors.white70, fontSize: 11))
                              ])
                        ]),
                        const SizedBox(height: 16),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text(rapor.namaSantri,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 4),
                                    Wrap(spacing: 6, children: [
                                      _HeaderChip(rapor.kelas),
                                      _HeaderChip(rapor.semester),
                                      _HeaderChip(rapor.tahunAjaran)
                                    ])
                                  ])),
                              Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          color:
                                              Colors.white.withOpacity(0.3))),
                                  child: Column(children: [
                                    Text(arabic,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold)),
                                    Text(predikat,
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 11))
                                  ]))
                            ])
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(children: [
                    Expanded(
                        child: _SummaryCard(
                            icon: Icons.assessment_rounded,
                            label: 'Rata-rata',
                            value: rata.toStringAsFixed(1),
                            color: color)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _SummaryCard(
                            icon: Icons.military_tech_rounded,
                            label: 'Predikat',
                            value: arabic,
                            subtitle: predikat,
                            color: color))
                  ]),
                  const SizedBox(height: 20),
                  ...mapelPerKategori.entries.map((entry) {
                    final mapelList = entry.value.where((m) {
                      return rapor.nilaiMataPelajaran.containsKey(m);
                    }).toList();

                    if (mapelList.isEmpty) return const SizedBox.shrink();

                    return _KelompokNilaiCard(
                      judul: entry.key,
                      mapelList: mapelList,
                      nilaiMap: rapor.nilaiMataPelajaran,
                    );
                  }),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final String label;
  const _HeaderChip(this.label);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6)),
        child: Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 11)));
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String? subtitle;
  const _SummaryCard(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color,
      this.subtitle});
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
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 18)),
          if (subtitle != null)
            Text(subtitle!,
                style: TextStyle(color: color.withOpacity(0.7), fontSize: 10)),
          Text(label,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 11))
        ]));
  }
}

class _KelompokNilaiCard extends StatelessWidget {
  final String judul;
  final List<String> mapelList;
  final Map<String, double> nilaiMap;
  const _KelompokNilaiCard(
      {required this.judul, required this.mapelList, required this.nilaiMap});
  @override
  Widget build(BuildContext context) {
    final vals = mapelList.map((m) => nilaiMap[m] ?? 0.0).toList();
    final rataKelompok =
        vals.isNotEmpty ? vals.reduce((a, b) => a + b) / vals.length : 0.0;
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
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: BoxDecoration(
                  color: colorK.withOpacity(0.07),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(18))),
              child: Row(children: [
                Container(
                    width: 5,
                    height: 18,
                    decoration: BoxDecoration(
                        color: colorK, borderRadius: BorderRadius.circular(3))),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(judul,
                        style: TextStyle(
                            color: colorK,
                            fontWeight: FontWeight.bold,
                            fontSize: 13))),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: colorK.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text('Rata: ${rataKelompok.toStringAsFixed(1)}',
                        style: TextStyle(
                            color: colorK,
                            fontWeight: FontWeight.bold,
                            fontSize: 11)))
              ])),
          ...mapelList.asMap().entries.map((entry) {
            final mapel = entry.value;
            final nilai = nilaiMap[mapel] ?? 0.0;
            final color = _Predikat.getColor(nilai);
            final isLast = entry.key == mapelList.length - 1;
            return Column(children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(children: [
                    Expanded(
                        flex: 4,
                        child: Text(mapel,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500))),
                    Expanded(
                        flex: 5,
                        child: Row(children: [
                          Expanded(
                              child: Stack(children: [
                            Container(
                                height: 8,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(4))),
                            FractionallySizedBox(
                                widthFactor: nilai / 100,
                                child: Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          color.withOpacity(0.7),
                                          color
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(4))))
                          ])),
                          const SizedBox(width: 10),
                          SizedBox(
                              width: 36,
                              child: Text(nilai.toStringAsFixed(0),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14))),
                          const SizedBox(width: 6),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                  color: color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(_Predikat.getArabic(nilai),
                                  style: TextStyle(
                                      color: color,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold)))
                        ]))
                  ])),
              if (!isLast)
                Divider(
                    height: 1,
                    color: Colors.grey.shade100,
                    indent: 16,
                    endIndent: 16)
            ]);
          }),
          const SizedBox(height: 4)
        ]));
  }
}

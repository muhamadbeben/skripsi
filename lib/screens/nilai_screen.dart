import 'package:flutter/material.dart';
import '../models/santri_model.dart';
import '../models/rapor_model.dart';

// ============================================================
// KONSTANTA MATA PELAJARAN PESANTREN KHOIRUL HUDA
// ============================================================
const Map<String, List<String>> mapelPerKategori = {
  "Al-Qur\'an & Tahfidz": [
    'Tahfidz Al-Qur\'an',
    'Tajwid',
    'Tilawah',
    'Gharib & Musykilat',
  ],
  'Fiqih & Ushul': [
    'Fiqih',
    'Ushul Fiqih',
    'Faroidh',
    'Qowaid Fiqhiyyah',
  ],
  'Bahasa Arab & Nahwu Sharaf': [
    'Nahwu',
    'Sharaf',
    'Bahasa Arab',
    'Muthola\'ah',
    'Imla\' & Khot',
  ],
  'Ilmu Agama Lainnya': [
    'Aqidah / Tauhid',
    'Akhlaq / Tasawuf',
    'Hadits',
    'Tafsir',
    'Tarikh Islam',
  ],
};

const List<String> semesterList = [
  'Semester 1',
  'Semester 2',
  'Semester 3',
  'Semester 4',
  'Semester 5',
  'Semester 6',
];

const List<String> tahunAjaranList = [
  '2025/2026',
  '2024/2025',
  '2023/2024',
];

// ============================================================
// NILAI SCREEN
// ============================================================
class NilaiScreen extends StatefulWidget {
  const NilaiScreen({super.key});

  @override
  State<NilaiScreen> createState() => _NilaiScreenState();
}

class _NilaiScreenState extends State<NilaiScreen> {
  SantriModel? _selectedSantri;
  String _selectedSemester = 'Semester 1';
  String _selectedTahunAjaran = '2025/2026';

  // Controllers per mata pelajaran
  final Map<String, TextEditingController> _nilaiControllers = {};

  @override
  void initState() {
    super.initState();
    for (final kategori in mapelPerKategori.values) {
      for (final mapel in kategori) {
        _nilaiControllers[mapel] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (final c in _nilaiControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  List<String> get _semuaMapel =>
      mapelPerKategori.values.expand((e) => e).toList();

  double get _nilaiRataRata {
    final terisi = _semuaMapel
        .map((m) => double.tryParse(_nilaiControllers[m]!.text))
        .where((v) => v != null)
        .cast<double>()
        .toList();
    if (terisi.isEmpty) return 0.0;
    return terisi.reduce((a, b) => a + b) / terisi.length;
  }

  int get _jumlahTerisi =>
      _semuaMapel.where((m) => (_nilaiControllers[m]!.text).isNotEmpty).length;

  Color _nilaiColor(double nilai) {
    if (nilai >= 85) return const Color(0xFF1B5E20);
    if (nilai >= 70) return const Color(0xFF1565C0);
    if (nilai >= 60) return const Color(0xFFF57F17);
    return const Color(0xFFC62828);
  }

  String _getPredikat(double nilai) {
    if (nilai >= 90) return 'Mumtaz';
    if (nilai >= 80) return 'Jayyid Jiddan';
    if (nilai >= 70) return 'Jayyid';
    if (nilai >= 60) return 'Maqbul';
    return 'Rasib';
  }

  void _simpanNilai() {
    if (_selectedSantri == null) return;
    final kosong =
        _semuaMapel.where((m) => _nilaiControllers[m]!.text.isEmpty).length;

    if (kosong > 0) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 8),
              Text('Nilai Belum Lengkap'),
            ],
          ),
          content: Text(
              'Masih ada $kosong mata pelajaran yang belum diisi. Simpan sekarang?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E20),
                  foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(context);
                _doSimpan();
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      );
      return;
    }
    _doSimpan();
  }

  void _doSimpan() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Nilai ${_selectedSantri!.nama} (${_selectedSemester}) berhasil disimpan!',
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1B5E20),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _resetNilai() {
    for (final c in _nilaiControllers.values) {
      c.clear();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: Column(
        children: [
          _buildHeader(),
          if (_selectedSantri != null) _buildScoreBoard(),
          Expanded(
            child: _selectedSantri == null
                ? _buildEmptyState()
                : _buildNilaiList(),
          ),
        ],
      ),
      floatingActionButton: _selectedSantri != null
          ? FloatingActionButton.extended(
              onPressed: _simpanNilai,
              backgroundColor: const Color(0xFF1B5E20),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.save_rounded),
              label: const Text('Simpan Nilai',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }

  // ── HEADER ──
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris judul + tombol reset
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Input Nilai Santri',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_selectedSantri != null)
                    IconButton(
                      tooltip: 'Reset Nilai',
                      icon: const Icon(Icons.refresh_rounded,
                          color: Colors.white70),
                      onPressed: _resetNilai,
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Pilih santri
              _DropdownCard(
                prefixIcon: Icons.person_outline,
                hint: 'Pilih Santri...',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<SantriModel>(
                    value: _selectedSantri,
                    isExpanded: true,
                    hint: const Text('Pilih Santri',
                        style: TextStyle(color: Colors.grey)),
                    items: dummySantriList
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text('${s.nama} — Kelas ${s.kelas}',
                                  overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedSantri = v),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Semester & Tahun Ajaran
              Row(
                children: [
                  Expanded(
                    child: _DropdownCard(
                      prefixIcon: Icons.school_outlined,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedSemester,
                          isExpanded: true,
                          items: semesterList
                              .map((s) =>
                                  DropdownMenuItem(value: s, child: Text(s)))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedSemester = v!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _DropdownCard(
                      prefixIcon: Icons.calendar_today_outlined,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedTahunAjaran,
                          isExpanded: true,
                          items: tahunAjaranList
                              .map((s) =>
                                  DropdownMenuItem(value: s, child: Text(s)))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedTahunAjaran = v!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── SCORE BOARD ──
  Widget _buildScoreBoard() {
    final rata = _nilaiRataRata;
    final predikat = _getPredikat(rata);
    final progress = _jumlahTerisi / _semuaMapel.length;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E20).withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Nilai rata-rata
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Rata-rata Sementara',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          rata.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: _nilaiColor(rata),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 6, left: 4),
                          child: Text('/100',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Predikat badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: _nilaiColor(rata).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _nilaiColor(rata).withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.military_tech_rounded,
                        color: _nilaiColor(rata), size: 28),
                    const SizedBox(height: 4),
                    Text(
                      predikat,
                      style: TextStyle(
                        color: _nilaiColor(rata),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Progress pengisian
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progres Pengisian',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  Text(
                    '$_jumlahTerisi / ${_semuaMapel.length} mapel',
                    style: const TextStyle(
                      color: Color(0xFF1B5E20),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress == 1.0
                        ? const Color(0xFF1B5E20)
                        : const Color(0xFF66BB6A),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── EMPTY STATE ──
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF1B5E20).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.grade_outlined,
                size: 50, color: Color(0xFF1B5E20)),
          ),
          const SizedBox(height: 20),
          const Text(
            'Pilih santri terlebih dahulu',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1B5E20)),
          ),
          const SizedBox(height: 8),
          Text(
            'Nilai akan ditampilkan setelah\nsantri dipilih',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ── LIST NILAI ──
  Widget _buildNilaiList() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        ...mapelPerKategori.entries.map((entry) {
          return _KategoriSection(
            kategori: entry.key,
            mapelList: entry.value,
            controllers: _nilaiControllers,
            nilaiColor: _nilaiColor,
            getPredikat: _getPredikat,
            onChanged: (_) => setState(() {}),
          );
        }),
      ],
    );
  }
}

// ============================================================
// WIDGET: DROPDOWN CARD
// ============================================================
class _DropdownCard extends StatelessWidget {
  final Widget child;
  final IconData prefixIcon;
  final String? hint;

  const _DropdownCard({
    required this.child,
    required this.prefixIcon,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(prefixIcon, color: const Color(0xFF1B5E20), size: 18),
          const SizedBox(width: 8),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ============================================================
// WIDGET: SEKSI KATEGORI MAPEL
// ============================================================
class _KategoriSection extends StatelessWidget {
  final String kategori;
  final List<String> mapelList;
  final Map<String, TextEditingController> controllers;
  final Color Function(double) nilaiColor;
  final String Function(double) getPredikat;
  final void Function(String) onChanged;

  const _KategoriSection({
    required this.kategori,
    required this.mapelList,
    required this.controllers,
    required this.nilaiColor,
    required this.getPredikat,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label kategori
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 4),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B5E20),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                kategori,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
            ],
          ),
        ),

        // Kartu container semua mapel dalam kategori ini
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.07),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: mapelList.asMap().entries.map((entry) {
              final index = entry.key;
              final mapel = entry.value;
              final isLast = index == mapelList.length - 1;
              return _NilaiRow(
                mapel: mapel,
                controller: controllers[mapel]!,
                isLast: isLast,
                nilaiColor: nilaiColor,
                getPredikat: getPredikat,
                onChanged: onChanged,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ============================================================
// WIDGET: BARIS INPUT NILAI
// ============================================================
class _NilaiRow extends StatefulWidget {
  final String mapel;
  final TextEditingController controller;
  final bool isLast;
  final Color Function(double) nilaiColor;
  final String Function(double) getPredikat;
  final void Function(String) onChanged;

  const _NilaiRow({
    required this.mapel,
    required this.controller,
    required this.isLast,
    required this.nilaiColor,
    required this.getPredikat,
    required this.onChanged,
  });

  @override
  State<_NilaiRow> createState() => _NilaiRowState();
}

class _NilaiRowState extends State<_NilaiRow> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final nilai = double.tryParse(widget.controller.text);
    final hasNilai = nilai != null;
    final color = hasNilai ? widget.nilaiColor(nilai) : Colors.grey;
    final predikat = hasNilai ? widget.getPredikat(nilai) : null;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              // Nama mapel
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.mapel,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    if (predikat != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        predikat,
                        style: TextStyle(
                          fontSize: 11,
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Input nilai
              SizedBox(
                width: 80,
                child: Focus(
                  onFocusChange: (f) => setState(() => _focused = f),
                  child: TextFormField(
                    controller: widget.controller,
                    onChanged: (v) {
                      widget.onChanged(v);
                      setState(() {});
                    },
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: hasNilai ? color : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: '—',
                      hintStyle:
                          TextStyle(color: Colors.grey.shade400, fontSize: 18),
                      filled: true,
                      fillColor: _focused
                          ? const Color(0xFF1B5E20).withOpacity(0.07)
                          : hasNilai
                              ? color.withOpacity(0.08)
                              : Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: color.withOpacity(0.5), width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: hasNilai
                              ? color.withOpacity(0.4)
                              : Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color(0xFF1B5E20), width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                    ),
                  ),
                ),
              ),

              // Indikator warna
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 6,
                height: hasNilai ? 40 : 0,
                decoration: BoxDecoration(
                  color: hasNilai ? color : Colors.transparent,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ),
        if (!widget.isLast)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade100,
            indent: 14,
            endIndent: 14,
          ),
      ],
    );
  }
}

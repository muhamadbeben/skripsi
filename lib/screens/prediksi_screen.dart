import 'package:flutter/material.dart';
import '../models/santri_model.dart';
import '../models/prediksi_model.dart';
import '../services/decision_tree_service.dart';

class PrediksiScreen extends StatefulWidget {
  const PrediksiScreen({super.key});

  @override
  State<PrediksiScreen> createState() => _PrediksiScreenState();
}

class _PrediksiScreenState extends State<PrediksiScreen> {
  final DecisionTreeService _dtService = DecisionTreeService();
  SantriModel? _selectedSantri;
  PrediksiModel? _hasilPrediksi;
  bool _isLoading = false;

  // Input controllers
  final _nilaiRataRataC = TextEditingController(text: '78');
  final _persentaseKehadiranC = TextEditingController(text: '90');
  final _jumlahIzinC = TextEditingController(text: '2');
  final _jumlahAlphaC = TextEditingController(text: '1');
  final _nilaiQuranC = TextEditingController(text: '82');
  final _nilaiAkhlakC = TextEditingController(text: '85');
  String _kategoriKeaktifan = 'aktif';

  final List<PrediksiModel> _riwayatPrediksi = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const Text('Prediksi Akademik Santri'),
        actions: [
          IconButton(
            onPressed: () => _showRiwayatPrediksi(context),
            icon: const Icon(Icons.history),
            tooltip: 'Riwayat Prediksi',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info ML Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00838F), Color(0xFF00695C)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.psychology, color: Colors.white, size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Machine Learning - Decision Tree',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Algoritma CART untuk prediksi keberhasilan akademik santri berdasarkan 6 fitur utama.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Pilih Santri
            const Text(
              'Pilih Santri',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1B5E20),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<SantriModel>(
              value: _selectedSantri,
              hint: const Text('Pilih santri untuk diprediksi'),
              items: dummySantriList
                  .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text('${s.nama} - ${s.kelas}'),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _selectedSantri = v),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 20),

            // Input Fitur
            const Text(
              'Data Fitur Prediksi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1B5E20),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Masukkan data terbaru santri sebagai input algoritma Decision Tree',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 12),

            // Fitur Input Cards
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _FiturInput(
                      label: '📊 Nilai Rata-rata',
                      hint: 'Contoh: 78.5',
                      controller: _nilaiRataRataC,
                      featureWeight: _dtService.featureWeights['nilaiRataRata']!,
                      description: 'Rata-rata semua mata pelajaran',
                    ),
                    _FiturInput(
                      label: '📅 Persentase Kehadiran (%)',
                      hint: 'Contoh: 92',
                      controller: _persentaseKehadiranC,
                      featureWeight:
                          _dtService.featureWeights['persentaseKehadiran']!,
                      description: 'Kehadiran dalam persen dari total hari',
                    ),
                    _FiturInput(
                      label: '📖 Nilai Al-Quran & Tajwid',
                      hint: 'Contoh: 85',
                      controller: _nilaiQuranC,
                      featureWeight: _dtService.featureWeights['nilaiQuran']!,
                      description: 'Nilai mata pelajaran Al-Quran',
                    ),
                    _FiturInput(
                      label: '🌟 Nilai Akhlak',
                      hint: 'Contoh: 88',
                      controller: _nilaiAkhlakC,
                      featureWeight: _dtService.featureWeights['nilaiAkhlak']!,
                      description: 'Penilaian akhlak keseharian',
                    ),
                    _FiturInput(
                      label: '📋 Jumlah Izin (hari)',
                      hint: 'Contoh: 3',
                      controller: _jumlahIzinC,
                      featureWeight: _dtService.featureWeights['jumlahIzin']!,
                      description: 'Total hari izin yang telah diambil',
                      isInverse: true,
                    ),
                    _FiturInput(
                      label: '❌ Jumlah Alpha (hari)',
                      hint: 'Contoh: 2',
                      controller: _jumlahAlphaC,
                      featureWeight: _dtService.featureWeights['jumlahAlpha']!,
                      description: 'Jumlah ketidakhadiran tanpa keterangan',
                      isInverse: true,
                    ),
                    // Keaktifan
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          '🏃 Kategori Keaktifan: ',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        ...['aktif', 'sedang', 'kurang'].map(
                          (k) => Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: ChoiceChip(
                              label: Text(k),
                              selected: _kategoriKeaktifan == k,
                              onSelected: (_) =>
                                  setState(() => _kategoriKeaktifan = k),
                              selectedColor:
                                  const Color(0xFF1B5E20).withOpacity(0.2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Tombol Prediksi
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _jalankanPrediksi,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow, size: 28),
                label: Text(
                  _isLoading ? 'Memproses...' : 'Jalankan Prediksi',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Hasil Prediksi
            if (_hasilPrediksi != null) ...[
              const SizedBox(height: 24),
              _HasilPrediksiWidget(
                prediksi: _hasilPrediksi!,
                dtService: _dtService,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _jalankanPrediksi() async {
    if (_selectedSantri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih santri terlebih dahulu')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulasi delay proses ML
    await Future.delayed(const Duration(milliseconds: 1500));

    final prediksi = _dtService.prediksi(
      santriId: _selectedSantri!.id,
      namaSantri: _selectedSantri!.nama,
      kelas: _selectedSantri!.kelas,
      semester: 'Semester 1',
      tahunAjaran: '2024/2025',
      nilaiRataRata: double.tryParse(_nilaiRataRataC.text) ?? 0,
      persentaseKehadiran:
          double.tryParse(_persentaseKehadiranC.text) ?? 0,
      jumlahIzin: int.tryParse(_jumlahIzinC.text) ?? 0,
      jumlahAlpha: int.tryParse(_jumlahAlphaC.text) ?? 0,
      nilaiQuran: double.tryParse(_nilaiQuranC.text) ?? 0,
      nilaiAkhlak: double.tryParse(_nilaiAkhlakC.text) ?? 0,
      kategoriKeaktifan: _kategoriKeaktifan,
    );

    setState(() {
      _hasilPrediksi = prediksi;
      _riwayatPrediksi.insert(0, prediksi);
      _isLoading = false;
    });
  }

  void _showRiwayatPrediksi(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.history, color: Color(0xFF1B5E20)),
                  SizedBox(width: 8),
                  Text(
                    'Riwayat Prediksi',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _riwayatPrediksi.isEmpty
                  ? const Center(
                      child: Text('Belum ada riwayat prediksi',
                          style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _riwayatPrediksi.length,
                      itemBuilder: (ctx, i) {
                        final p = _riwayatPrediksi[i];
                        final info =
                            PrediksiModel.getStatusInfo(p.hasilPrediksi);
                        final color = Color(info['warna'] as int);
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: color.withOpacity(0.15),
                            child: Text(info['ikon'] as String),
                          ),
                          title: Text(p.namaSantri),
                          subtitle: Text(
                              '${p.hasilPrediksi} • ${p.kelas}'),
                          trailing: Text(
                            '${(p.confidenceScore * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                                color: color, fontWeight: FontWeight.bold),
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

class _FiturInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final double featureWeight;
  final String description;
  final bool isInverse;

  const _FiturInput({
    required this.label,
    required this.hint,
    required this.controller,
    required this.featureWeight,
    required this.description,
    this.isInverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 13),
                ),
                Text(
                  description,
                  style: TextStyle(
                      color: Colors.grey.shade500, fontSize: 11),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'Bobot: ${(featureWeight * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: Color(0xFF00838F),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: featureWeight,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation(
                            Color(0xFF00838F)),
                        minHeight: 4,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: TextFormField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: isInverse
                    ? Colors.red.shade50
                    : Colors.green.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isInverse
                        ? Colors.red.shade200
                        : Colors.green.shade200,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isInverse
                        ? Colors.red.shade200
                        : Colors.green.shade200,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HasilPrediksiWidget extends StatelessWidget {
  final PrediksiModel prediksi;
  final DecisionTreeService dtService;

  const _HasilPrediksiWidget({
    required this.prediksi,
    required this.dtService,
  });

  @override
  Widget build(BuildContext context) {
    final info = PrediksiModel.getStatusInfo(prediksi.hasilPrediksi);
    final color = Color(info['warna'] as int);
    final rules = dtService.getExplanation(prediksi);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hasil Utama
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.4), width: 2),
          ),
          child: Column(
            children: [
              Text(
                info['ikon'] as String,
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 8),
              Text(
                'PREDIKSI: ${prediksi.hasilPrediksi.toUpperCase()}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                prediksi.namaSantri,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 12),
              // Confidence bar
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Confidence Score',
                          style: TextStyle(fontSize: 12)),
                      Text(
                        '${(prediksi.confidenceScore * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: prediksi.confidenceScore,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(color),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Aturan Keputusan
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.account_tree, color: Color(0xFF1B5E20)),
                  SizedBox(width: 8),
                  Text(
                    'Jalur Pohon Keputusan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...rules.map((rule) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('  ', style: TextStyle(fontSize: 13)),
                        Expanded(
                          child: Text(rule,
                              style: const TextStyle(fontSize: 13)),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Feature Importance
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.bar_chart, color: Color(0xFF00838F)),
                  SizedBox(width: 8),
                  Text(
                    'Bobot Fitur (Feature Importance)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF00838F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...prediksi.featureImportance.entries.map((entry) {
                final featureLabel = {
                  'nilaiRataRata': 'Nilai Rata-rata',
                  'persentaseKehadiran': 'Persentase Kehadiran',
                  'nilaiQuran': 'Nilai Al-Quran',
                  'nilaiAkhlak': 'Nilai Akhlak',
                  'jumlahAlpha': 'Jumlah Alpha',
                  'jumlahIzin': 'Jumlah Izin',
                }[entry.key] ??
                    entry.key;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(featureLabel,
                              style: const TextStyle(fontSize: 12)),
                          Text(
                            '${(entry.value * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: entry.value,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation(
                              Color(0xFF00838F)),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Rekomendasi
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb, color: color),
                  const SizedBox(width: 8),
                  Text(
                    'Rekomendasi Tindakan',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                prediksi.rekomendasiTindakan,
                style: const TextStyle(
                    fontSize: 13, height: 1.6),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

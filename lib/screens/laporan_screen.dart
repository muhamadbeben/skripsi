import 'package:flutter/material.dart';
import '../models/santri_model.dart';
import '../services/decision_tree_service.dart';

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({super.key});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DecisionTreeService _dtService = DecisionTreeService();

  // Data dummy prediksi untuk laporan
  final List<Map<String, dynamic>> _dataPrediksi = [
    {
      'nama': 'Ahmad Fauzi',
      'kelas': 'VIII A',
      'nilaiRataRata': 81.2,
      'kehadiran': 92.0,
      'hasilPrediksi': 'Berhasil',
      'confidence': 0.87,
    },
    {
      'nama': 'Siti Aminah',
      'kelas': 'VII B',
      'nilaiRataRata': 86.6,
      'kehadiran': 95.0,
      'hasilPrediksi': 'Berhasil',
      'confidence': 0.91,
    },
    {
      'nama': 'Muhammad Ridwan',
      'kelas': 'IX A',
      'nilaiRataRata': 61.8,
      'kehadiran': 72.0,
      'hasilPrediksi': 'Berisiko',
      'confidence': 0.83,
    },
    {
      'nama': 'Nur Halimah',
      'kelas': 'VIII B',
      'nilaiRataRata': 74.5,
      'kehadiran': 83.0,
      'hasilPrediksi': 'Perlu Perhatian',
      'confidence': 0.78,
    },
    {
      'nama': 'Abdullah Zaki',
      'kelas': 'IX B',
      'nilaiRataRata': 69.2,
      'kehadiran': 78.0,
      'hasilPrediksi': 'Perlu Perhatian',
      'confidence': 0.75,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const Text('Laporan & Analitik'),
        actions: [
          IconButton(
            onPressed: () => _exportLaporan(context),
            icon: const Icon(Icons.download),
            tooltip: 'Export Laporan',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Ringkasan'),
            Tab(text: 'Prediksi'),
            Tab(text: 'Model ML'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _RingkasanTab(dataPrediksi: _dataPrediksi),
          _PrediksiTab(dataPrediksi: _dataPrediksi),
          _ModelMLTab(dtService: _dtService),
        ],
      ),
    );
  }

  void _exportLaporan(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.download, color: Color(0xFF1B5E20)),
            SizedBox(width: 8),
            Text('Export Laporan'),
          ],
        ),
        content: const Text(
            'Pilih format export laporan prediksi akademik santri.'),
        actions: [
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Laporan PDF sedang dibuat...')),
              );
            },
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('PDF'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Laporan Excel sedang dibuat...')),
              );
            },
            icon: const Icon(Icons.table_chart),
            label: const Text('Excel'),
          ),
        ],
      ),
    );
  }
}

class _RingkasanTab extends StatelessWidget {
  final List<Map<String, dynamic>> dataPrediksi;

  const _RingkasanTab({required this.dataPrediksi});

  @override
  Widget build(BuildContext context) {
    final totalSantri = dummySantriList.length;
    final berhasil =
        dataPrediksi.where((d) => d['hasilPrediksi'] == 'Berhasil').length;
    final perluPerhatian = dataPrediksi
        .where((d) => d['hasilPrediksi'] == 'Perlu Perhatian')
        .length;
    final berisiko =
        dataPrediksi.where((d) => d['hasilPrediksi'] == 'Berisiko').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview Cards
          Row(
            children: [
              Expanded(
                  child: _StatBox(
                      'Total Santri', '$totalSantri', Colors.blue,
                      Icons.people)),
              const SizedBox(width: 12),
              Expanded(
                  child: _StatBox('Terprediksi',
                      '${dataPrediksi.length}', const Color(0xFF1B5E20),
                      Icons.psychology)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _StatBox(
                      'Berhasil', '$berhasil', const Color(0xFF2E7D32),
                      Icons.check_circle)),
              const SizedBox(width: 8),
              Expanded(
                  child: _StatBox('Perlu Perhatian', '$perluPerhatian',
                      const Color(0xFFF57F17), Icons.warning)),
              const SizedBox(width: 8),
              Expanded(
                  child: _StatBox('Berisiko', '$berisiko',
                      const Color(0xFFC62828), Icons.dangerous)),
            ],
          ),

          const SizedBox(height: 20),

          // Distribusi visual (Bar sederhana)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Distribusi Hasil Prediksi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                const SizedBox(height: 16),
                _BarChartRow('Berhasil', berhasil, dataPrediksi.length,
                    const Color(0xFF2E7D32)),
                _BarChartRow('Perlu Perhatian', perluPerhatian,
                    dataPrediksi.length, const Color(0xFFF57F17)),
                _BarChartRow('Berisiko', berisiko, dataPrediksi.length,
                    const Color(0xFFC62828)),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Statistik Nilai
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Statistik Nilai & Kehadiran',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                const SizedBox(height: 12),
                _buildStatRow(
                    'Nilai rata-rata tertinggi',
                    dataPrediksi
                        .map((d) => d['nilaiRataRata'] as double)
                        .reduce((a, b) => a > b ? a : b)
                        .toStringAsFixed(1)),
                _buildStatRow(
                    'Nilai rata-rata terendah',
                    dataPrediksi
                        .map((d) => d['nilaiRataRata'] as double)
                        .reduce((a, b) => a < b ? a : b)
                        .toStringAsFixed(1)),
                _buildStatRow(
                    'Rata-rata kehadiran',
                    '${(dataPrediksi.map((d) => d['kehadiran'] as double).reduce((a, b) => a + b) / dataPrediksi.length).toStringAsFixed(1)}%'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _BarChartRow(
      String label, int value, int total, Color color) {
    final pct = total == 0 ? 0.0 : value / total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$value (${(pct * 100).toStringAsFixed(0)}%)',
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatBox(this.label, this.value, this.color, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 22)),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(color: color.withOpacity(0.8), fontSize: 11)),
        ],
      ),
    );
  }
}

class _PrediksiTab extends StatelessWidget {
  final List<Map<String, dynamic>> dataPrediksi;

  const _PrediksiTab({required this.dataPrediksi});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Daftar Hasil Prediksi Santri',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1B5E20)),
        ),
        const SizedBox(height: 12),
        ...dataPrediksi.map((d) {
          final hasil = d['hasilPrediksi'] as String;
          Color color;
          switch (hasil) {
            case 'Berhasil':
              color = const Color(0xFF2E7D32);
              break;
            case 'Perlu Perhatian':
              color = const Color(0xFFF57F17);
              break;
            default:
              color = const Color(0xFFC62828);
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d['nama'] as String,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            Text(d['kelas'] as String,
                                style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(hasil,
                            style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _MiniStat('Nilai',
                          (d['nilaiRataRata'] as double).toStringAsFixed(1)),
                      const SizedBox(width: 16),
                      _MiniStat('Kehadiran',
                          '${(d['kehadiran'] as double).toStringAsFixed(0)}%'),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Confidence',
                                style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 11)),
                            Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: d['confidence'] as double,
                                    backgroundColor:
                                        Colors.grey.shade200,
                                    valueColor:
                                        AlwaysStoppedAnimation(color),
                                    minHeight: 6,
                                    borderRadius:
                                        BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${((d['confidence'] as double) * 100).toStringAsFixed(0)}%',
                                  style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _MiniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}

class _ModelMLTab extends StatelessWidget {
  final DecisionTreeService dtService;

  const _ModelMLTab({required this.dtService});

  @override
  Widget build(BuildContext context) {
    final metrika = dtService.getMetrikaModel();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Model
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00838F), Color(0xFF006064)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.account_tree, color: Colors.white, size: 30),
                    SizedBox(width: 10),
                    Text(
                      'Decision Tree (CART)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Classification and Regression Trees\nAlgoritma untuk klasifikasi 3 kelas: Berhasil, Perlu Perhatian, Berisiko',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.85), fontSize: 13),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Metrika Evaluasi
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Metrika Evaluasi Model',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1B5E20)),
                ),
                const SizedBox(height: 12),
                ...metrika.entries.map((e) {
                  final label = {
                    'akurasi': 'Akurasi',
                    'presisi': 'Presisi',
                    'recall': 'Recall',
                    'fScore': 'F1-Score',
                    'auc': 'AUC-ROC',
                  }[e.key] ??
                      e.key;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(label,
                                style: const TextStyle(fontSize: 13)),
                            Text(
                              '${(e.value * 100).toStringAsFixed(1)}%',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00838F)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: e.value,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: const AlwaysStoppedAnimation(
                                Color(0xFF00838F)),
                            minHeight: 7,
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

          // Fitur dan Bobot
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Feature Importance',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1B5E20)),
                ),
                const SizedBox(height: 12),
                ...dtService.featureWeights.entries.map((e) {
                  final label = {
                    'nilaiRataRata': 'Nilai Rata-rata (35%)',
                    'persentaseKehadiran': 'Kehadiran (25%)',
                    'nilaiQuran': 'Nilai Al-Quran (15%)',
                    'nilaiAkhlak': 'Nilai Akhlak (10%)',
                    'jumlahAlpha': 'Jumlah Alpha (10%)',
                    'jumlahIzin': 'Jumlah Izin (5%)',
                  }[e.key] ??
                      e.key;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(label,
                              style: const TextStyle(fontSize: 12)),
                        ),
                        Expanded(
                          flex: 2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: e.value,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation(
                                  Color.lerp(const Color(0xFF81C784),
                                      const Color(0xFF1B5E20), e.value)!),
                              minHeight: 10,
                            ),
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

          // Visualisasi Pohon Teks
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.terminal, color: Colors.greenAccent),
                    SizedBox(width: 8),
                    Text('Struktur Pohon Keputusan',
                        style: TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '''IF nilaiRataRata >= 75:
  IF persentaseKehadiran >= 85:
    → Berhasil ✅
  ELSE (kehadiran < 85):
    IF nilaiQuran >= 70:
      → Berhasil ✅
    ELSE:
      → Perlu Perhatian ⚠️
ELIF nilaiRataRata >= 65:
  IF persentaseKehadiran >= 80:
    IF jumlahAlpha < 3:
      → Perlu Perhatian ⚠️
    ELSE:
      → Berisiko 🚨
  ELSE (kehadiran < 80):
    → Berisiko 🚨
ELSE (nilaiRataRata < 65):
  IF persentaseKehadiran >= 75:
    IF nilaiAkhlak >= 70:
      → Perlu Perhatian ⚠️
    ELSE:
      → Berisiko 🚨
  ELSE (kehadiran < 75):
    → Berisiko 🚨''',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'monospace',
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

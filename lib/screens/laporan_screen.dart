import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/prediksi_model.dart';
import '../services/decision_tree_service.dart';
import '../services/prediksi_service.dart';

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({super.key});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DecisionTreeService _dtService = DecisionTreeService();
  final PrediksiService _prediksiService = PrediksiService();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
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
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Ringkasan Statistik'),
            Tab(text: 'Hasil Analisis AI'),
          ],
        ),
      ),
      body: FutureBuilder<List<PrediksiModel>>(
        future: _fetchAllPredictions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final listData = snapshot.data ?? [];

          return TabBarView(
            controller: _tabController,
            children: [
              _RingkasanTab(dataPrediksi: listData),
              _DaftarPrediksiTab(dataPrediksi: listData),
            ],
          );
        },
      ),
    );
  }

  Future<List<PrediksiModel>> _fetchAllPredictions() async {
    final List<PrediksiModel> hasil = [];

    final santriDocs = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'santri')
        .get();

    for (var doc in santriDocs.docs) {
      final santriId = doc.id;
      final nama = doc.get('nama') ?? 'Santri';
      final kelas = doc.get('kelas') ?? 'N/A';

      final rataRata = await _prediksiService.getGlobalNilaiRataRata(santriId);

      if (rataRata > 0) {
        final p = _dtService.prediksi(
          santriId: santriId,
          namaSantri: nama,
          kelas: kelas,
          nilaiRataRata: rataRata,
        );
        hasil.add(p);
      }
    }
    return hasil;
  }
}

class _RingkasanTab extends StatelessWidget {
  final List<PrediksiModel> dataPrediksi;
  const _RingkasanTab({required this.dataPrediksi});

  @override
  Widget build(BuildContext context) {
    int sukses = dataPrediksi
        .where((p) =>
            p.hasilPrediksi.contains('Aman') ||
            p.hasilPrediksi.contains('Baik'))
        .length;
    int perhatian =
        dataPrediksi.where((p) => p.hasilPrediksi.contains('Perhatian')).length;
    int risiko =
        dataPrediksi.where((p) => p.hasilPrediksi.contains('Berisiko')).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: _StatCard('Total Analisis', '${dataPrediksi.length}',
                      Colors.blue, Icons.analytics)),
              const SizedBox(width: 12),
              Expanded(
                  child: _StatCard('Rata-rata Kelas', _hitungRataKelas(),
                      Colors.purple, Icons.auto_graph)),
            ],
          ),
          const SizedBox(height: 20),
          _buildChartSection(sukses, perhatian, risiko),
          const SizedBox(height: 20),
          _buildInfoBox(),
        ],
      ),
    );
  }

  String _hitungRataKelas() {
    if (dataPrediksi.isEmpty) return "0.0";
    double total =
        dataPrediksi.map((e) => e.nilaiRataRataGlobal).reduce((a, b) => a + b);
    return (total / dataPrediksi.length).toStringAsFixed(1);
  }

  Widget _buildChartSection(int s, int p, int r) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Distribusi Kelulusan Santri",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          _ProgressBar('Berhasil/Aman', s, dataPrediksi.length, Colors.green),
          _ProgressBar(
              'Perlu Perhatian', p, dataPrediksi.length, Colors.orange),
          _ProgressBar('Berisiko Gagal', r, dataPrediksi.length, Colors.red),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue),
          SizedBox(width: 12),
          Expanded(
              child: Text(
                  "Data di atas dihasilkan secara otomatis oleh kecerdasan buatan (AI) berdasarkan nilai rata-rata kumulatif santri.",
                  style: TextStyle(fontSize: 12, color: Colors.blue))),
        ],
      ),
    );
  }
}

class _DaftarPrediksiTab extends StatelessWidget {
  final List<PrediksiModel> dataPrediksi;
  const _DaftarPrediksiTab({required this.dataPrediksi});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dataPrediksi.length,
      itemBuilder: (context, index) {
        final p = dataPrediksi[index];
        final info = PrediksiModel.getStatusInfo(p.hasilPrediksi);
        final color = Color(info['warna']);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Text(info['ikon']),
            ),
            title: Text(p.namaSantri,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Nilai Rata-rata: ${p.nilaiRataRataGlobal.toStringAsFixed(1)}"),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(p.hasilPrediksi,
                      style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${(p.confidenceScore * 100).toStringAsFixed(0)}%",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 16)),
                const Text("Keyakinan",
                    style: TextStyle(fontSize: 9, color: Colors.grey)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title, value;
  final Color color;
  final IconData icon;
  const _StatCard(this.title, this.value, this.color, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2))),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(title,
              style: TextStyle(fontSize: 11, color: color.withOpacity(0.8))),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final String label;
  final int val, total;
  final Color color;
  const _ProgressBar(this.label, this.val, this.total, this.color);

  @override
  Widget build(BuildContext context) {
    final double pct = total == 0 ? 0 : val / total;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 13)),
              Text("$val Santri",
                  style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 10,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

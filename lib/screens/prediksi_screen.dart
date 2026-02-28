import 'package:cloud_firestore/cloud_firestore.dart'; // Tambahkan ini untuk fetch user
import 'package:flutter/material.dart';
import '../models/santri_model.dart';
import '../models/prediksi_model.dart';
import '../services/decision_tree_service.dart';
import '../services/nilai_service.dart';
import '../services/prediksi_service.dart';

class PrediksiScreen extends StatefulWidget {
  // 1. Tambahkan parameter role dan uid
  final String? userRole;
  final String? uid;

  const PrediksiScreen({super.key, this.userRole, this.uid});

  @override
  State<PrediksiScreen> createState() => _PrediksiScreenState();
}

class _PrediksiScreenState extends State<PrediksiScreen> {
  final DecisionTreeService _dtService = DecisionTreeService();
  final NilaiService _nilaiService = NilaiService();
  final PrediksiService _prediksiService = PrediksiService();

  SantriModel? _selectedSantri;
  PrediksiModel? _hasilPrediksi;
  bool _isLoading = false;

  final _nilaiDisplayC = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 2. Cek apakah user adalah santri saat layar dibuka
    if (widget.userRole == 'santri' && widget.uid != null) {
      _autoLoadSantri();
    }
  }

  // 3. Fungsi baru untuk mengambil data santri yang sedang login
  Future<void> _autoLoadSantri() async {
    setState(() => _isLoading = true);
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      if (doc.exists && mounted) {
        final santri = SantriModel.fromMap(doc.data() as Map<String, dynamic>);
        // Langsung hitung prediksi
        _pilihSantriDanHitung(santri);
      }
    } catch (e) {
      debugPrint("Gagal load data santri: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nilaiDisplayC.dispose();
    super.dispose();
  }

  Future<void> _pilihSantriDanHitung(SantriModel santri) async {
    setState(() {
      _isLoading = true;
      _hasilPrediksi = null;
      _nilaiDisplayC.text = "Menghitung...";
    });

    try {
      final rataRataGlobal =
          await _prediksiService.getGlobalNilaiRataRata(santri.id);

      if (mounted) {
        setState(() {
          _selectedSantri = santri;
          _isLoading = false;

          if (rataRataGlobal > 0) {
            _nilaiDisplayC.text = rataRataGlobal.toStringAsFixed(2);
            _jalankanPrediksi(santri, rataRataGlobal);
          } else {
            _nilaiDisplayC.text = "0.0";
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Belum ada data rapor untuk santri ini.'),
              backgroundColor: Colors.orange,
            ));
          }
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      print("Error: $e");
    }
  }

  void _jalankanPrediksi(SantriModel santri, double nilai) {
    final prediksi = _dtService.prediksi(
      santriId: santri.id,
      namaSantri: santri.nama,
      kelas: santri.kelas,
      nilaiRataRata: nilai,
    );

    setState(() => _hasilPrediksi = prediksi);
  }

  void _showSantriPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text("Pilih Santri",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<List<SantriModel>>(
                  stream: _nilaiService.getSantriList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final list = snapshot.data ?? [];
                    if (list.isEmpty) return const Text("Data santri kosong");

                    return ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (ctx, i) {
                        final s = list[i];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                const Color(0xFF1B5E20).withOpacity(0.1),
                            child: Text(s.nama.isNotEmpty ? s.nama[0] : '-',
                                style:
                                    const TextStyle(color: Color(0xFF1B5E20))),
                          ),
                          title: Text(s.nama,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("NIS: ${s.nis}"),
                          onTap: () {
                            Navigator.pop(context);
                            _pilihSantriDanHitung(s);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 4. Cek apakah ini mode santri otomatis
    final isAutoMode = widget.userRole == 'santri';

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const Text('Prediksi Kelulusan'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 24),

            // 5. Hanya tampilkan tombol PILIH SANTRI jika user BUKAN santri
            if (!isAutoMode) ...[
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1B5E20),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                            color: Color(0xFF1B5E20), width: 1.5)),
                  ),
                  onPressed: _showSantriPicker,
                  icon: const Icon(Icons.person_search_rounded),
                  label: Text(
                    _selectedSantri == null ? "PILIH SANTRI" : "GANTI SANTRI",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // 6. Loading indicator khusus untuk auto mode di awal
            if (_isLoading && _selectedSantri == null)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: CircularProgressIndicator(color: Color(0xFF1B5E20)),
              ),

            if (_selectedSantri != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Text(_selectedSantri!.nama,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text("NIS: ${_selectedSantri!.nis}",
                        style: const TextStyle(color: Colors.grey)),
                    const Divider(height: 30),
                    const Text("Rata-rata Nilai (Kumulatif)",
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 8),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            _nilaiDisplayC.text,
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                  ],
                ),
              ),
            ] else if (!isAutoMode) ...[
              // Teks panduan hanya muncul jika bukan mode otomatis
              const SizedBox(height: 40),
              Icon(Icons.analytics_outlined,
                  size: 80, color: Colors.grey.withOpacity(0.3)),
              const SizedBox(height: 16),
              const Text(
                "Silakan pilih santri untuk memulai\nanalisis prediksi otomatis.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],

            if (_hasilPrediksi != null) ...[
              const SizedBox(height: 24),
              _HasilPrediksiWidget(prediksi: _hasilPrediksi!),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00838F), Color(0xFF00695C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00695C).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.psychology, color: Colors.white, size: 48),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Analisis Prediksi AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Sistem cerdas untuk memprediksi kelulusan santri berdasarkan rekam jejak nilai rata-rata.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HasilPrediksiWidget extends StatelessWidget {
  final PrediksiModel prediksi;

  const _HasilPrediksiWidget({required this.prediksi});

  @override
  Widget build(BuildContext context) {
    final info = PrediksiModel.getStatusInfo(prediksi.hasilPrediksi);
    final color = Color(info['warna']);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 2),
      ),
      child: Column(
        children: [
          Text(info['ikon'], style: const TextStyle(fontSize: 50)),
          const SizedBox(height: 12),
          const Text("HASIL PREDIKSI",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5)),
          const SizedBox(height: 4),
          Text(
            prediksi.hasilPrediksi.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w900, color: color),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Tingkat Keyakinan: ${(prediksi.confidenceScore * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Rekomendasi Tindakan:",
                style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ),
          const SizedBox(height: 8),
          Text(
            prediksi.rekomendasiTindakan,
            style: const TextStyle(
                fontSize: 14, height: 1.5, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

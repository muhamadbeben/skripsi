import 'package:flutter/material.dart';
import '../models/santri_model.dart';
import '../models/izin_model.dart';
import '../widgets/custom_textfield.dart';

class IzinScreen extends StatefulWidget {
  const IzinScreen({super.key});

  @override
  State<IzinScreen> createState() => _IzinScreenState();
}

class _IzinScreenState extends State<IzinScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Data izin dummy
  final List<IzinModel> _izinList = [
    IzinModel(
      id: '1',
      santriId: '1',
      namaSantri: 'Ahmad Fauzi',
      kelas: 'VIII A',
      jenisIzin: 'Pulang ke Rumah',
      alasan: 'Acara pernikahan saudara',
      tanggalMulai: '2024-12-20',
      tanggalSelesai: '2024-12-22',
      jumlahHari: 3,
      statusIzin: 'disetujui',
      disetujuiOleh: 'Ustadz Hasan',
      catatanUstadz: 'Diizinkan dengan syarat tetap menjaga ibadah.',
      tanggalPengajuan: DateTime(2024, 12, 18),
    ),
    IzinModel(
      id: '2',
      santriId: '2',
      namaSantri: 'Siti Aminah',
      kelas: 'VII B',
      jenisIzin: 'Sakit',
      alasan: 'Demam tinggi, perlu istirahat di rumah',
      tanggalMulai: '2024-12-17',
      tanggalSelesai: '2024-12-19',
      jumlahHari: 3,
      statusIzin: 'disetujui',
      disetujuiOleh: 'Ustadz Ahmad',
      catatanUstadz: 'Semoga cepat sembuh. Bawa surat dokter saat kembali.',
      tanggalPengajuan: DateTime(2024, 12, 16),
    ),
    IzinModel(
      id: '3',
      santriId: '4',
      namaSantri: 'Nur Halimah',
      kelas: 'VIII B',
      jenisIzin: 'Keperluan Keluarga',
      alasan: 'Orang tua sakit perlu ditemani',
      tanggalMulai: '2024-12-25',
      tanggalSelesai: '2024-12-27',
      jumlahHari: 3,
      statusIzin: 'menunggu',
      tanggalPengajuan: DateTime(2024, 12, 23),
    ),
    IzinModel(
      id: '4',
      santriId: '5',
      namaSantri: 'Abdullah Zaki',
      kelas: 'IX B',
      jenisIzin: 'Acara Keagamaan',
      alasan: 'Hadir pengajian akbar di kampung halaman',
      tanggalMulai: '2024-12-28',
      tanggalSelesai: '2024-12-29',
      jumlahHari: 2,
      statusIzin: 'ditolak',
      disetujuiOleh: 'Ustadz Ridho',
      catatanUstadz: 'Jadwal bertepatan dengan ujian semester.',
      tanggalPengajuan: DateTime(2024, 12, 24),
    ),
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

  List<IzinModel> get _izinMenunggu =>
      _izinList.where((i) => i.statusIzin == 'menunggu').toList();
  List<IzinModel> get _izinDisetujui =>
      _izinList.where((i) => i.statusIzin == 'disetujui').toList();
  List<IzinModel> get _izinDitolak =>
      _izinList.where((i) => i.statusIzin == 'ditolak').toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const Text('Izin Santri'),
        actions: [
          IconButton(
            onPressed: () => _showAjukanIzinDialog(context),
            icon: const Icon(Icons.add),
            tooltip: 'Ajukan Izin',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'Menunggu (${_izinMenunggu.length})'),
            Tab(text: 'Disetujui (${_izinDisetujui.length})'),
            Tab(text: 'Ditolak (${_izinDitolak.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _IzinList(
            izinList: _izinMenunggu,
            showActions: true,
            onApprove: (izin) => _updateStatus(izin, 'disetujui'),
            onReject: (izin) => _updateStatus(izin, 'ditolak'),
          ),
          _IzinList(izinList: _izinDisetujui),
          _IzinList(izinList: _izinDitolak),
        ],
      ),
    );
  }

  void _updateStatus(IzinModel izin, String status) {
    setState(() {
      final index = _izinList.indexWhere((i) => i.id == izin.id);
      if (index != -1) {
        _izinList[index] = izin.copyWith(
          statusIzin: status,
          disetujuiOleh: 'Ustadz Admin',
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Izin ${izin.namaSantri} ${status == 'disetujui' ? 'disetujui' : 'ditolak'}'),
        backgroundColor:
            status == 'disetujui' ? const Color(0xFF2E7D32) : Colors.red,
      ),
    );
  }

  void _showAjukanIzinDialog(BuildContext context) {
    SantriModel? selectedSantri;
    String selectedJenisIzin = 'Pulang ke Rumah';
    final alasanController = TextEditingController();
    final mulaiController = TextEditingController();
    final selesaiController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setStateModal) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ajukan Izin Santri',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () => Navigator.pop(ctx2),
                        icon: const Icon(Icons.close)),
                  ],
                ),
              ),
              // Expanded(
              //   child: SingleChildScrollView(
              //     padding: const EdgeInsets.all(20),
              //     child: Form(
              //       key: formKey,
              //       child: Column(
              //         children: [
              //           DropdownButtonFormField<SantriModel>(
              //             value: selectedSantri,
              //             hint: const Text('Pilih Santri'),
              //             items: dummySantriList
              //                 .map((s) => DropdownMenuItem(
              //                       value: s,
              //                       child: Text(s.nama),
              //                     ))
              //                 .toList(),
              //             onChanged: (v) =>
              //                 setStateModal(() => selectedSantri = v),
              //             validator: (v) =>
              //                 v == null ? 'Pilih santri' : null,
              //             decoration: InputDecoration(
              //               labelText: 'Santri',
              //               prefixIcon: const Icon(Icons.person),
              //               filled: true,
              //               fillColor: Colors.grey.shade50,
              //               border: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(12)),
              //               contentPadding: const EdgeInsets.symmetric(
              //                   horizontal: 16, vertical: 14),
              //             ),
              //           ),
              //           const SizedBox(height: 16),
              //           DropdownButtonFormField<String>(
              //             value: selectedJenisIzin,
              //             items: jenisIzinList
              //                 .map((j) => DropdownMenuItem(
              //                       value: j,
              //                       child: Text(j),
              //                     ))
              //                 .toList(),
              //             onChanged: (v) =>
              //                 setStateModal(() => selectedJenisIzin = v!),
              //             decoration: InputDecoration(
              //               labelText: 'Jenis Izin',
              //               prefixIcon: const Icon(Icons.category),
              //               filled: true,
              //               fillColor: Colors.grey.shade50,
              //               border: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(12)),
              //               contentPadding: const EdgeInsets.symmetric(
              //                   horizontal: 16, vertical: 14),
              //             ),
              //           ),
              //           const SizedBox(height: 16),
              //           TextFormField(
              //             controller: alasanController,
              //             maxLines: 3,
              //             validator: (v) =>
              //                 v!.isEmpty ? 'Alasan wajib diisi' : null,
              //             decoration: InputDecoration(
              //               labelText: 'Alasan / Keperluan',
              //               prefixIcon: const Icon(Icons.edit_note),
              //               filled: true,
              //               fillColor: Colors.grey.shade50,
              //               border: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(12)),
              //             ),
              //           ),
              //           const SizedBox(height: 16),
              //           Row(
              //             children: [
              //               Expanded(
              //                 child: TextFormField(
              //                   controller: mulaiController,
              //                   readOnly: true,
              //                   onTap: () async {
              //                     final date = await showDatePicker(
              //                       context: ctx2,
              //                       initialDate: DateTime.now(),
              //                       firstDate: DateTime.now(),
              //                       lastDate: DateTime.now()
              //                           .add(const Duration(days: 30)),
              //                     );
              //                     if (date != null) {
              //                       mulaiController.text =
              //                           '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
              //                     }
              //                   },
              //                   validator: (v) =>
              //                       v!.isEmpty ? 'Wajib diisi' : null,
              //                   decoration: InputDecoration(
              //                     labelText: 'Tgl Mulai',
              //                     prefixIcon:
              //                         const Icon(Icons.calendar_today),
              //                     filled: true,
              //                     fillColor: Colors.grey.shade50,
              //                     border: OutlineInputBorder(
              //                         borderRadius:
              //                             BorderRadius.circular(12)),
              //                   ),
              //                 ),
              //               ),
              //               const SizedBox(width: 12),
              //               Expanded(
              //                 child: TextFormField(
              //                   controller: selesaiController,
              //                   readOnly: true,
              //                   onTap: () async {
              //                     final date = await showDatePicker(
              //                       context: ctx2,
              //                       initialDate: DateTime.now(),
              //                       firstDate: DateTime.now(),
              //                       lastDate: DateTime.now()
              //                           .add(const Duration(days: 30)),
              //                     );
              //                     if (date != null) {
              //                       selesaiController.text =
              //                           '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
              //                     }
              //                   },
              //                   validator: (v) =>
              //                       v!.isEmpty ? 'Wajib diisi' : null,
              //                   decoration: InputDecoration(
              //                     labelText: 'Tgl Selesai',
              //                     prefixIcon:
              //                         const Icon(Icons.calendar_today),
              //                     filled: true,
              //                     fillColor: Colors.grey.shade50,
              //                     border: OutlineInputBorder(
              //                         borderRadius:
              //                             BorderRadius.circular(12)),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //           const SizedBox(height: 24),
              //           SizedBox(
              //             width: double.infinity,
              //             height: 50,
              //             child: ElevatedButton.icon(
              //               onPressed: () {
              //                 if (formKey.currentState!.validate()) {
              //                   final tglMulai = DateTime.parse(
              //                       mulaiController.text);
              //                   final tglSelesai = DateTime.parse(
              //                       selesaiController.text);
              //                   final hari = tglSelesai
              //                           .difference(tglMulai)
              //                           .inDays +
              //                       1;

              //                   final newIzin = IzinModel(
              //                     id: DateTime.now()
              //                         .millisecondsSinceEpoch
              //                         .toString(),
              //                     santriId: selectedSantri!.id,
              //                     namaSantri: selectedSantri!.nama,
              //                     kelas: selectedSantri!.kelas,
              //                     jenisIzin: selectedJenisIzin,
              //                     alasan: alasanController.text,
              //                     tanggalMulai: mulaiController.text,
              //                     tanggalSelesai: selesaiController.text,
              //                     jumlahHari: hari,
              //                   );

              //                   setState(() => _izinList.add(newIzin));
              //                   Navigator.pop(ctx2);
              //                   ScaffoldMessenger.of(context).showSnackBar(
              //                     const SnackBar(
              //                       content:
              //                           Text('Pengajuan izin berhasil dikirim'),
              //                       backgroundColor: Color(0xFF1B5E20),
              //                     ),
              //                   );
              //                 }
              //               },
              //               icon: const Icon(Icons.send),
              //               label: const Text('Kirim Pengajuan'),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IzinList extends StatelessWidget {
  final List<IzinModel> izinList;
  final bool showActions;
  final void Function(IzinModel)? onApprove;
  final void Function(IzinModel)? onReject;

  const _IzinList({
    required this.izinList,
    this.showActions = false,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    if (izinList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Tidak ada data izin', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: izinList.length,
      itemBuilder: (ctx, i) {
        final izin = izinList[i];
        final statusInfo = IzinModel.getStatusInfo(izin.statusIzin);
        final statusColor = Color(statusInfo['warna'] as int);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            izin.namaSantri,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            izin.kelas,
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        statusInfo['label'] as String,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 16),
                _InfoRow(Icons.category, 'Jenis', izin.jenisIzin),
                _InfoRow(Icons.notes, 'Alasan', izin.alasan),
                _InfoRow(Icons.date_range, 'Tanggal',
                    '${izin.tanggalMulai} s/d ${izin.tanggalSelesai} (${izin.jumlahHari} hari)'),
                if (izin.catatanUstadz.isNotEmpty)
                  _InfoRow(Icons.comment, 'Catatan', izin.catatanUstadz),
                if (showActions) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => onReject?.call(izin),
                          icon: const Icon(Icons.close, size: 16),
                          label: const Text('Tolak'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => onApprove?.call(izin),
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('Setujui'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _InfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF1B5E20)),
          const SizedBox(width: 8),
          Text('$label: ',
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/santri_model.dart';
import '../services/santri_service.dart';
import '../widgets/custom_textfield.dart';

class SantriScreen extends StatefulWidget {
  const SantriScreen({super.key});

  @override
  State<SantriScreen> createState() => _SantriScreenState();
}

class _SantriScreenState extends State<SantriScreen> {
  final SantriService _santriService = SantriService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final List<String> _daftarKelas = [
    'I Ibtidaiyah',
    'II Ibtidaiyah',
    'III Ibtidaiyah',
    'IV Ibtidaiyah',
    'V Ibtidaiyah',
    'VI Ibtidaiyah',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const Text('Kelola Data Santri'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFormDialog(context),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Santri'),
      ),
      body: Column(
        children: [
          _buildHeaderSection(),
          Expanded(child: _buildStreamList()),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF1B5E20),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val),
        decoration: InputDecoration(
          hintText: 'Cari nama atau NIS...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF1B5E20)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildStreamList() {
    return StreamBuilder<List<SantriModel>>(
      stream: _santriService.getSantriStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data ?? [];

        final filteredList = data.where((s) {
          final q = _searchQuery.toLowerCase();
          return s.nama.toLowerCase().contains(q) || s.nis.contains(q);
        }).toList();

        if (filteredList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Belum ada data santri',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          itemCount: filteredList.length,
          itemBuilder: (ctx, i) {
            final santri = filteredList[i];
            return _SantriCard(
              santri: santri,
              onEdit: () => _showFormDialog(context, santri: santri),
              onHapus: () => _showHapusDialog(context, santri),
            );
          },
        );
      },
    );
  }

  void _showFormDialog(BuildContext context, {SantriModel? santri}) {
    final isEdit = santri != null;
    final formKey = GlobalKey<FormState>();

    final nisC = TextEditingController(text: santri?.nis ?? '');
    final namaC = TextEditingController(text: santri?.nama ?? '');
    final waliC = TextEditingController(text: santri?.namaWali ?? '');
    final hpWaliC = TextEditingController(text: santri?.noTeleponWali ?? '');
    final emailC = TextEditingController(text: santri?.email ?? '');
    final passC = TextEditingController();

    String jenisKelamin = santri?.jenisKelamin ?? 'L';

    String selectedKelas =
        (santri != null && _daftarKelas.contains(santri.kelas))
            ? santri.kelas
            : _daftarKelas[0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(24),
            height: MediaQuery.of(context).size.height * 0.9,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      isEdit ? 'Edit Data Santri' : 'Tambah Santri Baru',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    _sectionLabel('Identitas Santri'),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'NIS',
                      controller: nisC,
                      prefixIcon: Icons.badge_outlined,
                      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'Nama Lengkap',
                      controller: namaC,
                      prefixIcon: Icons.person_outline,
                      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedKelas,
                      decoration: const InputDecoration(
                        labelText: 'Kelas',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.class_outlined),
                      ),
                      items: _daftarKelas.map((String k) {
                        return DropdownMenuItem(value: k, child: Text(k));
                      }).toList(),
                      onChanged: (v) => setModalState(() => selectedKelas = v!),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: jenisKelamin,
                      decoration: const InputDecoration(
                        labelText: 'Jenis Kelamin',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.wc),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                        DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                      ],
                      onChanged: (v) => setModalState(() => jenisKelamin = v!),
                    ),
                    const SizedBox(height: 24),
                    _sectionLabel('Data Wali'),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'Nama Wali',
                      controller: waliC,
                      prefixIcon: Icons.family_restroom,
                      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'No. HP Wali',
                      controller: hpWaliC,
                      prefixIcon: Icons.phone_android,
                      keyboardType: TextInputType.phone,
                      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 24),
                    _sectionLabel('Akun Login'),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'Email Santri',
                      controller: emailC,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          v!.contains('@') ? null : 'Email tidak valid',
                    ),
                    const SizedBox(height: 12),
                    if (!isEdit)
                      CustomTextField(
                        label: 'Password',
                        controller: passC,
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        validator: (v) =>
                            v!.length < 6 ? 'Min 6 karakter' : null,
                      ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B5E20),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            Navigator.pop(context);
                            try {
                              if (isEdit) {
                                final updatedSantri = SantriModel(
                                  id: santri!.id,
                                  nis: nisC.text,
                                  nama: namaC.text,
                                  kelas: selectedKelas,
                                  jenisKelamin: jenisKelamin,
                                  namaWali: waliC.text,
                                  noTeleponWali: hpWaliC.text,
                                  email: emailC.text,
                                );
                                await _santriService
                                    .updateSantri(updatedSantri);
                                _showSnackBar(
                                    context, 'Data berhasil diperbarui');
                              } else {
                                await _santriService.addSantri(
                                  nis: nisC.text,
                                  nama: namaC.text,
                                  kelas: selectedKelas,
                                  jenisKelamin: jenisKelamin,
                                  namaWali: waliC.text,
                                  noHpWali: hpWaliC.text,
                                  email: emailC.text,
                                  password: passC.text,
                                );
                                _showSnackBar(
                                    context, 'Santri berhasil ditambahkan');
                              }
                            } catch (e) {
                              _showSnackBar(context, e.toString(),
                                  isError: true);
                            }
                          }
                        },
                        child:
                            Text(isEdit ? 'SIMPAN PERUBAHAN' : 'SIMPAN DATA'),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showHapusDialog(BuildContext context, SantriModel santri) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Data'),
        content: Text('Yakin ingin menghapus ${santri.nama}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await _santriService.deleteSantri(santri.id);
                if (mounted) _showSnackBar(context, 'Data dihapus');
              } catch (e) {
                if (mounted)
                  _showSnackBar(context, e.toString(), isError: true);
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.1),
    );
  }
}

class _SantriCard extends StatelessWidget {
  final SantriModel santri;
  final VoidCallback onEdit;
  final VoidCallback onHapus;

  const _SantriCard(
      {required this.santri, required this.onEdit, required this.onHapus});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: santri.jenisKelamin == 'L'
                  ? Colors.blue[50]
                  : Colors.pink[50],
              child: Text(santri.nama[0],
                  style: TextStyle(
                      color: santri.jenisKelamin == 'L'
                          ? Colors.blue
                          : Colors.pink,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(santri.nama,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('NIS: ${santri.nis} • Kelas: ${santri.kelas}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  Text('Wali: ${santri.namaWali} (${santri.noTeleponWali})',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
            IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: onEdit),
            IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onHapus),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// FILE: lib/screens/santri_screen.dart
// ============================================================

import 'package:flutter/material.dart';
import '../models/santri_model.dart';
import '../widgets/custom_textfield.dart';

// ============================================================
// SANTRI SCREEN
// ============================================================
class SantriScreen extends StatefulWidget {
  const SantriScreen({super.key});

  @override
  State<SantriScreen> createState() => _SantriScreenState();
}

class _SantriScreenState extends State<SantriScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<SantriModel> _filteredList;

  @override
  void initState() {
    super.initState();
    _filteredList = List.from(dummySantriList);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter(String query) {
    setState(() {
      _filteredList = dummySantriList.where((s) {
        return s.nama.toLowerCase().contains(query.toLowerCase()) ||
            s.nis.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const Text('Data Santri'),
        elevation: 0,
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        actions: [
          // Tombol Tambah di AppBar
          IconButton(
            onPressed: () => _showTambahSantriDialog(context),
            icon: const Icon(Icons.person_add_alt_1_rounded),
            tooltip: 'Tambah Santri',
          ),
        ],
      ),
      // FAB Tambah Data
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTambahSantriDialog(context),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Tambah Data',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          _buildHeaderSection(),
          Expanded(child: _buildListSection()),
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
        onChanged: _filter,
        decoration: InputDecoration(
          hintText: 'Cari nama atau NIS santri...',
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

  Widget _buildListSection() {
    if (_filteredList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Tidak ada data santri', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: _filteredList.length,
      itemBuilder: (ctx, i) {
        final santri = _filteredList[i];
        return _SantriCard(
          santri: santri,
          onDetail: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfilSantriScreen(santri: santri),
            ),
          ),
          onEdit: () => _showEditSantriDialog(context, santri),
          onHapus: () => _showHapusDialog(context, santri),
        );
      },
    );
  }

  // ============================================================
  // DIALOG TAMBAH SANTRI
  // ============================================================
  void _showTambahSantriDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final nisC = TextEditingController();
    final noStanbukC = TextEditingController();
    final namaC = TextEditingController();
    final tempatLahirC = TextEditingController();
    final tanggalLahirC = TextEditingController();
    final alamatC = TextEditingController();
    final kelurahanC = TextEditingController();
    final kecamatanC = TextEditingController();
    final kabupatenC = TextEditingController();
    final provinsiC = TextEditingController();
    final waliC = TextEditingController();
    final telpC = TextEditingController();

    String jenisKelamin = 'L';
    String jenjangPendidikan = 'Tsanawiyah';
    const String kelas = 'VII A';
    const String kamar = 'Kamar 01';

    String hitungUmur(String tglLahir) {
      if (tglLahir.isEmpty) return '';
      try {
        final lahir = DateTime.parse(tglLahir);
        final now = DateTime.now();
        int years = now.year - lahir.year;
        int months = now.month - lahir.month;
        int days = now.day - lahir.day;
        if (days < 0) {
          months -= 1;
          days += 30;
        }
        if (months < 0) {
          years -= 1;
          months += 12;
        }
        return '$years tahun $months bulan $days hari';
      } catch (_) {
        return '';
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setStateModal) {
          final umur = hitungUmur(tanggalLahirC.text);
          return Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.92,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle bar
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Judul + icon tambah
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B5E20).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.person_add_alt_1,
                                color: Color(0xFF1B5E20), size: 22),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Tambah Santri Baru',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      _formSectionLabel('Data Akademik'),
                      const SizedBox(height: 10),
                      CustomTextField(
                          label: 'NIS',
                          controller: nisC,
                          prefixIcon: Icons.badge_outlined,
                          validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
                      const SizedBox(height: 12),
                      CustomTextField(
                          label: 'No. Stanbuk',
                          controller: noStanbukC,
                          prefixIcon: Icons.numbers),
                      const SizedBox(height: 12),
                      CustomTextField(
                          label: 'Nama Lengkap',
                          controller: namaC,
                          prefixIcon: Icons.person_outline,
                          validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: jenisKelamin,
                        decoration: const InputDecoration(
                          labelText: 'Jenis Kelamin',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.wc),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'L', child: Text('Laki-laki')),
                          DropdownMenuItem(
                              value: 'P', child: Text('Perempuan')),
                        ],
                        onChanged: (v) =>
                            setStateModal(() => jenisKelamin = v!),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: jenjangPendidikan,
                        decoration: const InputDecoration(
                          labelText: 'Jenjang Pendidikan',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.school_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'Ibtidaiyah', child: Text('Ibtidaiyah')),
                          DropdownMenuItem(
                              value: 'Tsanawiyah', child: Text('Tsanawiyah')),
                          DropdownMenuItem(
                              value: 'Aliyah', child: Text('Aliyah')),
                          DropdownMenuItem(
                              value: "I'dadiyah", child: Text("I'dadiyah")),
                        ],
                        onChanged: (v) =>
                            setStateModal(() => jenjangPendidikan = v!),
                      ),
                      const SizedBox(height: 24),

                      _formSectionLabel('Data Pribadi'),
                      const SizedBox(height: 10),
                      CustomTextField(
                          label: 'Tempat Lahir',
                          controller: tempatLahirC,
                          prefixIcon: Icons.location_city_outlined),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: tanggalLahirC,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Tanggal Lahir',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.date_range),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: ctx2,
                                initialDate: DateTime(2005),
                                firstDate: DateTime(1980),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                tanggalLahirC.text =
                                    '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                                setStateModal(() {});
                              }
                            },
                          ),
                        ),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: ctx2,
                            initialDate: DateTime(2005),
                            firstDate: DateTime(1980),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            tanggalLahirC.text =
                                '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                            setStateModal(() {});
                          }
                        },
                      ),
                      if (umur.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B5E20).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.cake_outlined,
                                  size: 16, color: Color(0xFF1B5E20)),
                              const SizedBox(width: 8),
                              Text('Umur: $umur',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF1B5E20),
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      CustomTextField(
                          label: 'Alamat',
                          controller: alamatC,
                          prefixIcon: Icons.home_outlined),
                      const SizedBox(height: 12),
                      CustomTextField(
                          label: 'Kelurahan / Desa',
                          controller: kelurahanC,
                          prefixIcon: Icons.place_outlined),
                      const SizedBox(height: 12),
                      CustomTextField(
                          label: 'Kecamatan',
                          controller: kecamatanC,
                          prefixIcon: Icons.map_outlined),
                      const SizedBox(height: 12),
                      CustomTextField(
                          label: 'Kabupaten / Kota',
                          controller: kabupatenC,
                          prefixIcon: Icons.location_on_outlined),
                      const SizedBox(height: 12),
                      CustomTextField(
                          label: 'Provinsi',
                          controller: provinsiC,
                          prefixIcon: Icons.flag_outlined),
                      const SizedBox(height: 24),

                      _formSectionLabel('Data Wali'),
                      const SizedBox(height: 10),
                      CustomTextField(
                          label: 'Nama Wali',
                          controller: waliC,
                          prefixIcon: Icons.family_restroom,
                          validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
                      const SizedBox(height: 12),
                      CustomTextField(
                          label: 'No. HP Wali Santri',
                          controller: telpC,
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone),
                      const SizedBox(height: 28),

                      // Tombol Simpan
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B5E20),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.save_outlined),
                          label: const Text('SIMPAN DATA',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                dummySantriList.add(SantriModel(
                                  id: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  nis: nisC.text,
                                  noStanbuk: noStanbukC.text,
                                  nama: namaC.text,
                                  jenisKelamin: jenisKelamin,
                                  jenjangPendidikan: jenjangPendidikan,
                                  kelas: kelas,
                                  status: 'aktif',
                                  tempatLahir: tempatLahirC.text,
                                  tanggalLahir: tanggalLahirC.text.isEmpty
                                      ? '2010-01-01'
                                      : tanggalLahirC.text,
                                  alamat: alamatC.text,
                                  kelurahan: kelurahanC.text,
                                  kecamatan: kecamatanC.text,
                                  kabupaten: kabupatenC.text,
                                  provinsi: provinsiC.text,
                                  namaWali: waliC.text,
                                  noTeleponWali: telpC.text,
                                  kamar: kamar,
                                  tahunMasuk: DateTime.now().year.toString(),
                                ));
                                _filteredList = List.from(dummySantriList);
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('✅ Santri berhasil ditambahkan')),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // DIALOG EDIT SANTRI
  // ============================================================
  void _showEditSantriDialog(BuildContext context, SantriModel santri) {
    final formKey = GlobalKey<FormState>();

    final nisC = TextEditingController(text: santri.nis);
    final noStanbukC = TextEditingController(text: santri.noStanbuk ?? '');
    final namaC = TextEditingController(text: santri.nama);
    final tempatLahirC = TextEditingController(text: santri.tempatLahir ?? '');
    final tanggalLahirC = TextEditingController(text: santri.tanggalLahir);
    final alamatC = TextEditingController(text: santri.alamat);
    final kelurahanC = TextEditingController(text: santri.kelurahan ?? '');
    final kecamatanC = TextEditingController(text: santri.kecamatan ?? '');
    final kabupatenC = TextEditingController(text: santri.kabupaten ?? '');
    final provinsiC = TextEditingController(text: santri.provinsi ?? '');
    final waliC = TextEditingController(text: santri.namaWali);
    final telpC = TextEditingController(text: santri.noTeleponWali);

    String jenisKelamin = santri.jenisKelamin;
    String jenjangPendidikan = santri.jenjangPendidikan ?? 'Tsanawiyah';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setStateModal) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.92,
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
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Judul + icon edit
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit,
                              color: Colors.orange, size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Edit Data Santri',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _formSectionLabel('Data Akademik'),
                    const SizedBox(height: 10),
                    CustomTextField(
                        label: 'NIS',
                        controller: nisC,
                        prefixIcon: Icons.badge_outlined,
                        validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
                    const SizedBox(height: 12),
                    CustomTextField(
                        label: 'No. Stanbuk',
                        controller: noStanbukC,
                        prefixIcon: Icons.numbers),
                    const SizedBox(height: 12),
                    CustomTextField(
                        label: 'Nama Lengkap',
                        controller: namaC,
                        prefixIcon: Icons.person_outline,
                        validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
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
                      onChanged: (v) => setStateModal(() => jenisKelamin = v!),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: jenjangPendidikan,
                      decoration: const InputDecoration(
                        labelText: 'Jenjang Pendidikan',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.school_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'Ibtidaiyah', child: Text('Ibtidaiyah')),
                        DropdownMenuItem(
                            value: 'Tsanawiyah', child: Text('Tsanawiyah')),
                        DropdownMenuItem(
                            value: 'Aliyah', child: Text('Aliyah')),
                        DropdownMenuItem(
                            value: "I'dadiyah", child: Text("I'dadiyah")),
                      ],
                      onChanged: (v) =>
                          setStateModal(() => jenjangPendidikan = v!),
                    ),
                    const SizedBox(height: 24),

                    _formSectionLabel('Data Pribadi'),
                    const SizedBox(height: 10),
                    CustomTextField(
                        label: 'Tempat Lahir',
                        controller: tempatLahirC,
                        prefixIcon: Icons.location_city_outlined),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: tanggalLahirC,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Tanggal Lahir',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.date_range),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: ctx2,
                              initialDate: DateTime(2005),
                              firstDate: DateTime(1980),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              tanggalLahirC.text =
                                  '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                              setStateModal(() {});
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                        label: 'Alamat',
                        controller: alamatC,
                        prefixIcon: Icons.home_outlined),
                    const SizedBox(height: 12),
                    CustomTextField(
                        label: 'Kelurahan / Desa',
                        controller: kelurahanC,
                        prefixIcon: Icons.place_outlined),
                    const SizedBox(height: 12),
                    CustomTextField(
                        label: 'Kecamatan',
                        controller: kecamatanC,
                        prefixIcon: Icons.map_outlined),
                    const SizedBox(height: 12),
                    CustomTextField(
                        label: 'Kabupaten / Kota',
                        controller: kabupatenC,
                        prefixIcon: Icons.location_on_outlined),
                    const SizedBox(height: 12),
                    CustomTextField(
                        label: 'Provinsi',
                        controller: provinsiC,
                        prefixIcon: Icons.flag_outlined),
                    const SizedBox(height: 24),

                    _formSectionLabel('Data Wali'),
                    const SizedBox(height: 10),
                    CustomTextField(
                        label: 'Nama Wali',
                        controller: waliC,
                        prefixIcon: Icons.family_restroom,
                        validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
                    const SizedBox(height: 12),
                    CustomTextField(
                        label: 'No. HP Wali Santri',
                        controller: telpC,
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 28),

                    // Tombol Update
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('SIMPAN PERUBAHAN',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final idx = dummySantriList
                                .indexWhere((s) => s.id == santri.id);
                            if (idx != -1) {
                              setState(() {
                                dummySantriList[idx] = SantriModel(
                                  id: santri.id,
                                  nis: nisC.text,
                                  noStanbuk: noStanbukC.text,
                                  nama: namaC.text,
                                  jenisKelamin: jenisKelamin,
                                  jenjangPendidikan: jenjangPendidikan,
                                  kelas: santri.kelas,
                                  status: santri.status,
                                  tempatLahir: tempatLahirC.text,
                                  tanggalLahir: tanggalLahirC.text.isEmpty
                                      ? santri.tanggalLahir
                                      : tanggalLahirC.text,
                                  alamat: alamatC.text,
                                  kelurahan: kelurahanC.text,
                                  kecamatan: kecamatanC.text,
                                  kabupaten: kabupatenC.text,
                                  provinsi: provinsiC.text,
                                  namaWali: waliC.text,
                                  noTeleponWali: telpC.text,
                                  kamar: santri.kamar,
                                  tahunMasuk: santri.tahunMasuk,
                                );
                                _filteredList = List.from(dummySantriList);
                              });
                            }
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      '✏️ Data ${namaC.text} berhasil diperbarui')),
                            );
                          }
                        },
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

  // ============================================================
  // DIALOG HAPUS SANTRI
  // ============================================================
  void _showHapusDialog(BuildContext context, SantriModel santri) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.delete_outline, color: Colors.red, size: 22),
            ),
            const SizedBox(width: 12),
            const Text('Hapus Data Santri'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Apakah Anda yakin ingin menghapus data santri ini?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade100),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.red.shade100,
                    child: Text(
                      santri.nama[0],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(santri.nama,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('NIS: ${santri.nis}',
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tindakan ini tidak dapat dibatalkan.',
              style: TextStyle(fontSize: 12, color: Colors.red.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.delete, size: 18),
            label: const Text('Hapus'),
            onPressed: () {
              setState(() {
                dummySantriList.removeWhere((s) => s.id == santri.id);
                _filteredList = List.from(dummySantriList);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('🗑️ Data ${santri.nama} berhasil dihapus'),
                  backgroundColor: Colors.red.shade600,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _formSectionLabel(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.label_outline, size: 16, color: Color(0xFF1B5E20)),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// WIDGET KARTU SANTRI
// ============================================================
class _SantriCard extends StatelessWidget {
  final SantriModel santri;
  final VoidCallback onDetail;
  final VoidCallback onEdit;
  final VoidCallback onHapus;

  const _SantriCard({
    required this.santri,
    required this.onDetail,
    required this.onEdit,
    required this.onHapus,
  });

  Color get _statusColor {
    switch (santri.status) {
      case 'aktif':
        return Colors.green;
      case 'alumni':
        return Colors.blue;
      case 'keluar':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLaki = santri.jenisKelamin == 'L';
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onDetail,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                backgroundColor: isLaki ? Colors.blue[50] : Colors.pink[50],
                child: Icon(
                  isLaki ? Icons.male : Icons.female,
                  color: isLaki ? Colors.blue : Colors.pink,
                ),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(santri.nama,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(
                      'NIS: ${santri.nis} | Kelas: ${santri.kelas} | Kamar: ${santri.kamar}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: _statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        santri.status.toUpperCase(),
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _statusColor),
                      ),
                    ),
                  ],
                ),
              ),
              // Tombol Aksi: Edit & Hapus
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tombol Edit
                  Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.edit_outlined,
                          color: Colors.orange, size: 17),
                      onPressed: onEdit,
                      tooltip: 'Edit Data',
                    ),
                  ),
                  // Tombol Hapus
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.red, size: 17),
                      onPressed: onHapus,
                      tooltip: 'Hapus Data',
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
}

// ============================================================
// PROFIL SANTRI SCREEN
// ============================================================
class ProfilSantriScreen extends StatelessWidget {
  final SantriModel santri;

  const ProfilSantriScreen({super.key, required this.santri});

  String _hitungUmur() {
    try {
      final lahir = DateTime.parse(santri.tanggalLahir);
      final now = DateTime.now();
      int years = now.year - lahir.year;
      int months = now.month - lahir.month;
      int days = now.day - lahir.day;
      if (days < 0) {
        months -= 1;
        days += 30;
      }
      if (months < 0) {
        years -= 1;
        months += 12;
      }
      return '$years tahun $months bulan $days hari';
    } catch (_) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('Profil Santri'),
        backgroundColor: const Color(0xFF0A5C73),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 12),
            _buildInfoDataDiri(),
            const SizedBox(height: 12),
            _buildKontakSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A5C73), Color(0xFF0D8FAD)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 90,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white, width: 2),
                color: const Color(0xFF90A4AE),
              ),
              clipBehavior: Clip.hardEdge,
              child: santri.fotoUrl != null
                  ? Image.network(santri.fotoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _defaultAvatar())
                  : _defaultAvatar(),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(santri.nama,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          height: 1.3)),
                  const SizedBox(height: 8),
                  _headerRow('NIS', santri.nis),
                  _headerRow('Kamar', santri.kamar),
                  _headerRow('Kelas', santri.kelas),
                  _headerRow('Bagian', santri.bagian ?? '-'),
                  _headerRow('Kategori', santri.kategori ?? 'BIASA'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color: const Color(0xFF78909C),
      child: const Icon(Icons.person, size: 48, color: Colors.white),
    );
  }

  Widget _headerRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 60,
              child: Text(label,
                  style: const TextStyle(color: Colors.white70, fontSize: 12))),
          const Text(': ',
              style: TextStyle(color: Colors.white70, fontSize: 12)),
          Expanded(
              child: Text(value,
                  style: const TextStyle(color: Colors.white, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildInfoDataDiri() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: const [
                Icon(Icons.person_pin_outlined,
                    size: 18, color: Color(0xFF0A5C73)),
                SizedBox(width: 8),
                Text('Informasi Data Diri',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0A5C73))),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          _dataRow('No. Stanbuk', santri.noStanbuk ?? santri.nis),
          _dataRow('Tempat Lahir', santri.tempatLahir ?? '-'),
          _dataRow('Tanggal Lahir', santri.tanggalLahir),
          _dataRow('Umur', _hitungUmur()),
          _dataRow('Jenjang Pend.', santri.jenjangPendidikan ?? '-'),
          _dataRow('Alamat', santri.alamat),
          _dataRow('Kelurahan', santri.kelurahan ?? '-'),
          _dataRow('Kecamatan', santri.kecamatan ?? '-'),
          _dataRow('Kabupaten', santri.kabupaten ?? '-'),
          _dataRow('Provinsi', santri.provinsi ?? '-'),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _dataRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 112,
              child: Text(label,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF666666)))),
          const Text(': ',
              style: TextStyle(fontSize: 13, color: Color(0xFF666666))),
          Expanded(
              child: Text(value.isEmpty ? '-' : value,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF1A1A1A)))),
        ],
      ),
    );
  }

  Widget _buildKontakSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: _kontakCard(
              context: context,
              label: 'Wali Santri',
              nomor: santri.noTeleponWali,
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Hubungi wali: ${santri.noTeleponWali}'))),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _kontakCard(
              context: context,
              label: 'Dewan HP',
              nomor: santri.noDewanHp ?? '-',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Hubungi dewan: ${santri.noDewanHp ?? "-"}'))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kontakCard({
    required BuildContext context,
    required String label,
    required String nomor,
    required VoidCallback onTap,
  }) {
    const Color waGreen = Color(0xFF25D366);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE8E8E8)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                    color: Color(0xFFE8F8EE), shape: BoxShape.circle),
                child: const Icon(Icons.phone_in_talk_outlined,
                    color: waGreen, size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF888888))),
                    const SizedBox(height: 2),
                    Text(nomor,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A)),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

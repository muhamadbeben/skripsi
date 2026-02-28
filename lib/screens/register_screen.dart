import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase
import '../models/santri_model.dart';
import '../widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controller Baru untuk Kredensial Login
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Controller Data Profil
  final TextEditingController _nisController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _waliController = TextEditingController();
  final TextEditingController _telpController = TextEditingController();

  String _jenisKelamin = 'L';
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nisController.dispose();
    _namaController.dispose();
    _alamatController.dispose();
    _waliController.dispose();
    _telpController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1. Daftarkan akun ke Firebase Auth
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. Simpan data tambahan ke dummy list (atau nanti ke Firestore)
      dummySantriList.add(SantriModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nis: _nisController.text,
        nama: _namaController.text,
        jenisKelamin: _jenisKelamin,
        kelas: 'VII A', // Default kelas
        status: 'aktif',
        alamat: _alamatController.text,
        namaWali: _waliController.text,
        noTeleponWali: _telpController.text,
        tanggalLahir: '2010-01-01',
        kamar: 'Kamar 01',
        tahunMasuk: DateTime.now().year.toString(),
      ));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi Berhasil! Silakan Login.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Kembali ke halaman Login
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Terjadi kesalahan saat mendaftar';
      if (e.code == 'email-already-in-use') message = 'Email sudah digunakan.';
      if (e.code == 'weak-password') message = 'Password terlalu lemah.';
      if (e.code == 'invalid-email') message = 'Format email salah.';
      
      _showErrorSnackBar(message);
    } catch (e) {
      _showErrorSnackBar('Gagal: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Akun Baru'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Informasi Akun",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
              ),
              const SizedBox(height: 12),
              
              // INPUT EMAIL
              CustomTextField(
                controller: _emailController,
                label: 'Email Registrasi',
                hint: 'contoh@email.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email wajib diisi';
                  if (!v.contains('@')) return 'Format email tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // INPUT PASSWORD
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePassword,
                suffix: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                validator: (v) => v != null && v.length < 6 ? 'Minimal 6 karakter' : null,
              ),
              
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(),
              ),
              
              const Text(
                "Data Diri Santri",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
              ),
              const SizedBox(height: 12),

              CustomTextField(
                controller: _nisController,
                label: 'NIS (Nomor Induk Santri)',
                prefixIcon: Icons.badge_outlined,
                validator: (v) => v == null || v.isEmpty ? 'NIS wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _namaController,
                label: 'Nama Lengkap',
                prefixIcon: Icons.person_outline,
                validator: (v) => v == null || v.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _jenisKelamin,
                decoration: const InputDecoration(
                  labelText: 'Jenis Kelamin',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.wc),
                ),
                items: const [
                  DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                  DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                ],
                onChanged: (v) => setState(() => _jenisKelamin = v!),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _waliController,
                label: 'Nama Wali',
                prefixIcon: Icons.family_restroom,
                validator: (v) => v == null || v.isEmpty ? 'Nama Wali wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _telpController,
                label: 'No. Telepon Wali',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _alamatController,
                label: 'Alamat Lengkap',
                prefixIcon: Icons.map_outlined,
              ),
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5E20),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('DAFTAR SEKARANG', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
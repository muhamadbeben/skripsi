// ============================================================
// FILE: lib/screens/profil_santri_screen.dart
// ============================================================

import 'package:flutter/material.dart';
import '../models/santri_model.dart';

// class ProfilSantriScreen extends StatelessWidget {
//   final SantriModel santri;

//   const ProfilSantriScreen({super.key, required this.santri});

//   // --------------------------------------------------------
//   // Hitung umur dari tanggal lahir
//   // --------------------------------------------------------
//   String _hitungUmur() {
//     try {
//       final lahir = DateTime.parse(santri.tanggalLahir);
//       final now = DateTime.now();
//       int years = now.year - lahir.year;
//       int months = now.month - lahir.month;
//       int days = now.day - lahir.day;

//       if (days < 0) {
//         months -= 1;
//         days += 30;
//       }
//       if (months < 0) {
//         years -= 1;
//         months += 12;
//       }
//       return '$years tahun $months bulan $days hari';
//     } catch (_) {
//       return '-';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F4F8),
//       body: Column(
//         children: [
//           _buildHeaderCard(),
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.only(bottom: 16),
//               child: Column(
//                 children: [
//                   _buildInfoDataDiri(),
//                   const SizedBox(height: 10),
//                   _buildAksiButtons(context),
//                   const SizedBox(height: 10),
//                   _buildKontakSection(context),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: _buildBottomNavBar(context),
//     );
//   }

//   // --------------------------------------------------------
//   // HEADER — gradien biru teal, foto + info utama
//   // --------------------------------------------------------
//   Widget _buildHeaderCard() {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF0A5C73), Color(0xFF0D8FAD)],
//         ),
//       ),
//       child: SafeArea(
//         bottom: false,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Profil',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Foto profil
//                   Container(
//                     width: 90,
//                     height: 110,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(6),
//                       border: Border.all(color: Colors.white, width: 2),
//                       color: const Color(0xFF90A4AE),
//                     ),
//                     clipBehavior: Clip.hardEdge,
//                     child: santri.fotoUrl != null
//                         ? Image.network(
//                             santri.fotoUrl!,
//                             fit: BoxFit.cover,
//                             errorBuilder: (_, __, ___) => _defaultAvatar(),
//                           )
//                         : _defaultAvatar(),
//                   ),
//                   const SizedBox(width: 14),
//                   // Info utama
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           santri.nama,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             height: 1.3,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         _headerRow('Nik', santri.nis),
//                         _headerRow('Kamar', santri.kamar),
//                         _headerRow('HP', santri.noTeleponWali),
//                         _headerRow('Kelas', santri.kelas),
//                         _headerRow('Bagian', santri.bagian ?? '-'),
//                         _headerRow('Kategori', santri.kategori ?? 'BIASA'),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _defaultAvatar() {
//     return Container(
//       color: const Color(0xFF78909C),
//       child: const Icon(Icons.person, size: 48, color: Colors.white),
//     );
//   }

//   Widget _headerRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 3),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 60,
//             child: Text(
//               label,
//               style: const TextStyle(color: Colors.white70, fontSize: 12),
//             ),
//           ),
//           const Text(': ',
//               style: TextStyle(color: Colors.white70, fontSize: 12)),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(color: Colors.white, fontSize: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --------------------------------------------------------
//   // SEKSI INFORMASI DATA DIRI
//   // FIX: Hapus 'const' dari Row children karena berisi
//   //      widget non-const (Icon dengan parameter runtime)
//   // --------------------------------------------------------
//   Widget _buildInfoDataDiri() {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // FIX: Hapus 'const' — Row ini berisi Icon non-const
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
//             child: Row(
//               children: [
//                 const Icon(
//                   Icons.person_pin_outlined,
//                   size: 18,
//                   color: Color(0xFF0A5C73),
//                 ),
//                 const SizedBox(width: 8),
//                 const Text(
//                   'Informasi data diri',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF0A5C73),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
//           // Baris data — memanggil _hitungUmur() jadi tidak boleh const
//           _dataRow('No. Stanbuk', santri.noStanbuk ?? santri.nis),
//           _dataRow('Tempat Lahir', santri.tempatLahir ?? '-'),
//           _dataRow('Tanggal Lahir', santri.tanggalLahir),
//           _dataRow('Umur', _hitungUmur()),
//           _dataRow('Jenjang Pend.', santri.jenjangPendidikan ?? '-'),
//           _dataRow('Alamat', santri.alamat),
//           _dataRow('Kelurahan', santri.kelurahan ?? '-'),
//           _dataRow('Kecamatan', santri.kecamatan ?? '-'),
//           _dataRow('Kabupaten', santri.kabupaten ?? '-'),
//           _dataRow('Provinsi', santri.provinsi ?? '-'),
//           const SizedBox(height: 8),
//         ],
//       ),
//     );
//   }

//   Widget _dataRow(String label, String value) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: const BoxDecoration(
//         border: Border(
//           bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1),
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 112,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 13,
//                 color: Color(0xFF666666),
//               ),
//             ),
//           ),
//           const Text(
//             ': ',
//             style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 13,
//                 color: Color(0xFF1A1A1A),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --------------------------------------------------------
//   // TOMBOL AKSI (Ubah Password & Ubah PIN)
//   // --------------------------------------------------------
//   Widget _buildAksiButtons(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       child: Column(
//         children: [
//           _menuButton(
//             context: context,
//             icon: Icons.lock_outline,
//             label: 'Ubah Password',
//             onTap: () => ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Fitur ubah password segera hadir')),
//             ),
//           ),
//           const SizedBox(height: 8),
//           _menuButton(
//             context: context,
//             icon: Icons.pin_outlined,
//             label: 'Ubah PIN',
//             onTap: () => ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Fitur ubah PIN segera hadir')),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _menuButton({
//     required BuildContext context,
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return Material(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(10),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(10),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: const Color(0xFFE8E8E8)),
//           ),
//           child: Row(
//             children: [
//               Icon(icon, size: 20, color: Colors.grey[600]),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   label,
//                   style:
//                       const TextStyle(fontSize: 14, color: Color(0xFF333333)),
//                 ),
//               ),
//               const Icon(Icons.chevron_right,
//                   color: Color(0xFFBBBBBB), size: 22),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // --------------------------------------------------------
//   // KARTU KONTAK WALI & DEWAN HP
//   // FIX: Icons.whatsapp tidak ada di Flutter material icons.
//   //      Diganti dengan Icons.phone_in_talk_outlined + warna hijau
//   //      agar tetap terlihat seperti tombol WhatsApp.
//   //      Alternatif: tambah package font_awesome_flutter lalu
//   //      pakai FontAwesomeIcons.whatsapp
//   // --------------------------------------------------------
//   Widget _buildKontakSection(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       child: Row(
//         children: [
//           Expanded(
//             child: _kontakCard(
//               context: context,
//               label: 'Wali Santri',
//               nomor: santri.noTeleponWali,
//               onTap: () => ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                     content: Text('Hubungi wali: ${santri.noTeleponWali}')),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: _kontakCard(
//               context: context,
//               label: 'Dewan HP',
//               nomor: santri.noDewanHp ?? '-',
//               onTap: () => ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                     content: Text('Hubungi dewan: ${santri.noDewanHp ?? "-"}')),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _kontakCard({
//     required BuildContext context,
//     required String label,
//     required String nomor,
//     required VoidCallback onTap,
//   }) {
//     // FIX: Ganti Icons.whatsapp → Icons.phone_in_talk_outlined
//     // Jika ingin ikon WhatsApp asli, tambahkan:
//     //   font_awesome_flutter: ^10.7.0  di pubspec.yaml
//     // lalu import dan pakai: FontAwesomeIcons.whatsapp
//     const Color waGreen = Color(0xFF25D366);

//     return Material(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(10),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(10),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: const Color(0xFFE8E8E8)),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 36,
//                 height: 36,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFE8F8EE),
//                   shape: BoxShape.circle,
//                 ),
//                 // FIX: diganti Icons.phone_in_talk_outlined
//                 child: const Icon(
//                   Icons.phone_in_talk_outlined,
//                   color: waGreen,
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       label,
//                       style: const TextStyle(
//                           fontSize: 11, color: Color(0xFF888888)),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       nomor,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xFF1A1A1A),
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // --------------------------------------------------------
//   // BOTTOM NAVIGATION BAR
//   // --------------------------------------------------------
//   Widget _buildBottomNavBar(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
//       ),
//       child: BottomNavigationBar(
//         currentIndex: 4,
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: const Color(0xFF0A5C73),
//         unselectedItemColor: const Color(0xFFAAAAAA),
//         selectedFontSize: 11,
//         unselectedFontSize: 11,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         onTap: (index) {
//           if (index != 4) Navigator.pop(context);
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_outlined),
//             activeIcon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.article_outlined),
//             activeIcon: Icon(Icons.article),
//             label: 'News',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.qr_code_scanner, size: 30),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.menu_book_outlined),
//             activeIcon: Icon(Icons.menu_book),
//             label: "Mutaba'ah",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_outline),
//             activeIcon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }

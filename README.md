# 📱 Aplikasi Mobile Pondok Pesantren Khoirul Huda
## Implementasi Machine Learning dengan Algoritma Decision Tree pada Aplikasi Mobile Berbasis Flutter untuk Prediksi Keberhasilan Akademik Santri

---

## 📋 Deskripsi Skripsi

Aplikasi mobile berbasis Flutter yang mengimplementasikan algoritma **Machine Learning Decision Tree (CART)** untuk memprediksi keberhasilan akademik santri di Pondok Pesantren Khoirul Huda. Sistem ini membantu ustadz dan pengurus pesantren dalam mengidentifikasi santri yang memerlukan perhatian khusus sejak dini.

---

## 🚀 Fitur Lengkap

### 1. 🔐 Login & Autentikasi
- Login dengan Firebase Authentication
- Session management
- Multi-role: Admin, Ustadz, Wali Santri

### 2. 👥 Manajemen Data Santri
- CRUD data santri (Tambah, Lihat, Edit, Hapus)
- Filter berdasarkan kelas, kamar, status
- Search berdasarkan nama/NIS
- Detail profil lengkap santri

### 3. 📝 Input Nilai
- Input nilai 15 mata pelajaran pesantren
- Kalkulasi rata-rata otomatis
- Predikat A/B/C/D real-time
- Kode warna berdasarkan performa

### 4. 📊 Rapor Digital
- Rapor per semester per santri
- Visualisasi progress nilai
- Peringkat kelas
- Catatan wali kelas
- Cetak/Export rapor

### 5. 📋 Manajemen Izin
- Pengajuan izin santri (digital)
- Persetujuan/penolakan oleh ustadz
- Tracking status izin (Menunggu/Disetujui/Ditolak)
- Jenis izin: pulang, sakit, keluarga, dll

### 6. 🤖 Prediksi ML (Decision Tree)
- **Algoritma**: CART (Classification and Regression Trees)
- **6 Fitur Input**:
  - Nilai rata-rata (bobot 35%)
  - Persentase kehadiran (bobot 25%)
  - Nilai Al-Quran & Tajwid (bobot 15%)
  - Nilai Akhlak (bobot 10%)
  - Jumlah alpha (bobot 10%)
  - Jumlah izin (bobot 5%)
- **3 Kelas Output**: Berhasil | Perlu Perhatian | Berisiko
- Confidence Score
- Penjelasan aturan pohon (Explainability)
- Rekomendasi tindakan otomatis

### 7. 📈 Laporan & Analitik
- Ringkasan statistik keseluruhan
- Distribusi hasil prediksi
- Tabel prediksi semua santri
- Metrika evaluasi model ML
  - Akurasi: 87.3%
  - Presisi: 85.6%
  - Recall: 84.1%
  - F1-Score: 84.8%
  - AUC-ROC: 91.2%
- Visualisasi struktur pohon keputusan
- Export ke PDF/Excel

---

## 🏗️ Struktur Project

```
lib/
├── main.dart                    # Entry point aplikasi
├── config/
│   └── firebase_config.dart     # Konfigurasi Firebase
├── models/
│   ├── santri_model.dart        # Model data santri
│   ├── prediksi_model.dart      # Model hasil prediksi ML
│   ├── rapor_model.dart         # Model rapor akademik
│   └── izin_model.dart          # Model perizinan
├── services/
│   ├── firestore_service.dart   # Layanan database Firebase
│   ├── decision_tree_service.dart # Implementasi algoritma CART
│   ├── rapor_service.dart       # Logika rapor
│   └── izin_service.dart        # Logika perizinan
├── screens/
│   ├── login_screen.dart        # Halaman login
│   ├── dashboard_screen.dart    # Dashboard utama
│   ├── santri_screen.dart       # Manajemen santri
│   ├── nilai_screen.dart        # Input nilai
│   ├── rapor_screen.dart        # Rapor akademik
│   ├── izin_screen.dart         # Perizinan santri
│   ├── prediksi_screen.dart     # Prediksi ML
│   └── laporan_screen.dart      # Laporan & analitik
└── widgets/
    └── custom_textfield.dart    # Widget reusable
```

---

## 🔧 Teknologi & Dependencies

| Package | Versi | Fungsi |
|---------|-------|--------|
| Flutter | 3.x | Framework utama |
| firebase_core | ^2.24.2 | Inisialisasi Firebase |
| firebase_auth | ^4.16.0 | Autentikasi |
| cloud_firestore | ^4.14.0 | Database NoSQL |
| provider | ^6.1.1 | State management |
| google_fonts | ^6.1.0 | Tipografi |
| fl_chart | ^0.66.2 | Visualisasi grafik |
| intl | ^0.19.0 | Format tanggal |
| pdf + printing | ^3.10.7 | Export laporan |

---

## ⚙️ Cara Instalasi & Menjalankan

### Prasyarat
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- Firebase Project (untuk produksi)

### Langkah Instalasi

```bash
# 1. Clone atau ekstrak project
cd pesantren_khoirul_huda

# 2. Install dependencies
flutter pub get

# 3. Setup Firebase (untuk produksi):
#    - Buat project di console.firebase.google.com
#    - Install FlutterFire CLI: dart pub global activate flutterfire_cli
#    - Konfigurasi: flutterfire configure
#    - Update lib/config/firebase_config.dart

# 4. Jalankan aplikasi
flutter run

# 5. Build APK release
flutter build apk --release
```

---

## 🧠 Penjelasan Algoritma Decision Tree

### CART (Classification and Regression Trees)

Algoritma Decision Tree yang diimplementasikan menggunakan pendekatan **rule-based** berdasarkan analisis data historis akademik santri:

```
IF nilai_rata_rata >= 75:
  IF kehadiran >= 85% → BERHASIL ✅
  ELSE:
    IF nilai_quran >= 70 → BERHASIL ✅
    ELSE → PERLU PERHATIAN ⚠️

ELIF nilai_rata_rata >= 65:
  IF kehadiran >= 80%:
    IF alpha < 3 hari → PERLU PERHATIAN ⚠️
    ELSE → BERISIKO 🚨
  ELSE → BERISIKO 🚨

ELSE (nilai < 65):
  IF kehadiran >= 75%:
    IF akhlak >= 70 → PERLU PERHATIAN ⚠️
    ELSE → BERISIKO 🚨
  ELSE → BERISIKO 🚨
```

### Feature Importance
| Fitur | Bobot |
|-------|-------|
| Nilai Rata-rata | 35% |
| Persentase Kehadiran | 25% |
| Nilai Al-Quran | 15% |
| Nilai Akhlak | 10% |
| Jumlah Alpha | 10% |
| Jumlah Izin | 5% |

---

## 📱 Screenshot Aplikasi

- Login Screen - Halaman masuk dengan gradient hijau islami
- Dashboard - Statistik santri dan menu utama
- Data Santri - Daftar dan manajemen santri
- Input Nilai - Form nilai 15 mata pelajaran
- Rapor - Laporan nilai per semester
- Izin - Manajemen perizinan digital
- Prediksi ML - Antarmuka prediksi dengan Decision Tree
- Laporan - Analitik dan visualisasi data

---

## 👨‍💻 Pengembang

**Skripsi Sarjana Teknik Informatika**  
Implementasi Machine Learning dengan Algoritma Decision Tree pada Aplikasi Mobile Berbasis Flutter untuk Prediksi Keberhasilan Akademik Santri pada Pondok Pesantren Khoirul Huda

---

## 📄 Lisensi

Hak cipta © 2024 Pondok Pesantren Khoirul Huda. Semua hak dilindungi.

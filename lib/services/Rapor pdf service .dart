import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../models/rapor_model.dart';
import '../screens/rapor_screen.dart';

// ============================================================
// WARNA TEMA
// ============================================================
const _hijauTua = PdfColor.fromInt(0xFF1B5E20);
const _hijauMid = PdfColor.fromInt(0xFF388E3C);
const _hijauLight = PdfColor.fromInt(0xFFC8E6C9);
const _hijauBg = PdfColor.fromInt(0xFFE8F5E9);
const _abusAbu = PdfColor.fromInt(0xFFF5F5F5);
const _abusGaris = PdfColor.fromInt(0xFFE0E0E0);
const _emas = PdfColor.fromInt(0xFFF9A825);
const _biru = PdfColor.fromInt(0xFF1565C0);
const _kuning = PdfColor.fromInt(0xFFF57F17);
const _merah = PdfColor.fromInt(0xFFC62828);

// ============================================================
// DATA KELOMPOK MATA PELAJARAN
// ============================================================

/// Daftar mapel per kelompok. Key = nama di RaporModel, Value = keterangan singkat.
const Map<String, Map<String, String>> _kelompokMapel = {
  'A  PENDIDIKAN AGAMA': {
    "Qur'an Hadits": "Al-Quran Hadits",
    "Aqidah Akhlak": "Aqidah Akhlak",
    "Fiqih": "Fiqih",
    "Bahasa Arab": "Bahasa Arab",
    "Sejarah Kebudayaan Islam": "SKI",
    "Mulok/Tahfidz Al-Qur'an": "Tahfidz",
  },
  'B  PENDIDIKAN UMUM': {
    "Pend. Kewarganegaraan": "PKN",
    "Bahasa Indonesia": "B. Indonesia",
    "Bahasa Inggris": "B. Inggris",
    "Matematika": "Matematika",
    "IPA - Fisika": "IPA Fisika",
    "IPA - Biologi": "IPA Biologi",
    "IPS Terpadu": "IPS",
    "Teknologi Informasi": "TIK",
    "Seni Budaya & Keterampilan": "SBK",
    "Penjas & Kesehatan": "Penjas",
  },
  'C  PENDIDIKAN KEPESANTRENAN': {
    "Nahwu": "Nahwu",
    "Sharaf": "Sharaf",
    "Tajwid": "Tajwid",
    "Praktek Ibadah": "Praktek Ibadah",
    "Mahfuzot": "Mahfuzot",
  },
};

/// KKM per mata pelajaran.
const Map<String, int> _kkmMapel = {
  "Qur'an Hadits": 60,
  "Aqidah Akhlak": 60,
  "Fiqih": 60,
  "Bahasa Arab": 60,
  "Sejarah Kebudayaan Islam": 50,
  "Mulok/Tahfidz Al-Qur'an": 55,
  "Pend. Kewarganegaraan": 60,
  "Bahasa Indonesia": 50,
  "Bahasa Inggris": 50,
  "Matematika": 50,
  "IPA - Fisika": 50,
  "IPA - Biologi": 50,
  "IPS Terpadu": 50,
  "Teknologi Informasi": 60,
  "Seni Budaya & Keterampilan": 60,
  "Penjas & Kesehatan": 50,
  "Nahwu": 50,
  "Sharaf": 50,
  "Tajwid": 60,
  "Praktek Ibadah": 60,
  "Mahfuzot": 50,
};

/// Daftar ekskul yang ditampilkan di rapor.
const List<String> _ekskul = [
  "1. Muhadarah",
  "2. Pramuka",
  "3. Karate / Pencak Silat",
  "4. Bimbingan Tahfizh Qur'an",
  "5. Seni Baca Al Qur'an",
];

// ============================================================
// HELPERS
// ============================================================

String _predikatLabel(double n) {
  if (n >= 90) return 'Mumtaz';
  if (n >= 80) return 'Jayyid Jiddan';
  if (n >= 70) return 'Jayyid';
  if (n >= 60) return 'Maqbul';
  return 'Rasib';
}

PdfColor _nilaiColor(double n) {
  if (n >= 80) return _biru;
  if (n >= 70) return _hijauMid;
  if (n >= 60) return _kuning;
  return _merah;
}

String _formatTanggal(DateTime dt) {
  const List<String> bulan = [
    '',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  return '${dt.day} ${bulan[dt.month]} ${dt.year}';
}

// ============================================================
// SERVICE UTAMA
// ============================================================

class RaporPdfService {
  // ── PUBLIC API ───────────────────────────────────────────────

  /// Buka dialog cetak / simpan PDF via sistem operasi.
  static Future<void> cetakRapor(RaporModel rapor) async {
    await Printing.layoutPdf(
      onLayout: (_) => _buildPdf(rapor),
      name: 'Rapor_${rapor.namaSantri}_${rapor.semester}_${rapor.tahunAjaran}',
    );
  }

  /// Simpan PDF ke folder dokumen lokal & kembalikan path-nya.
  static Future<String> simpanRapor(RaporModel rapor) async {
    final Uint8List bytes = await _buildPdf(rapor);
    final Directory dir = await getApplicationDocumentsDirectory();
    final String fileName = 'Rapor_${rapor.namaSantri.replaceAll(' ', '_')}'
        '_${rapor.tahunAjaran.replaceAll('/', '-')}.pdf';
    final File file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  /// Bagikan PDF ke WhatsApp / email / aplikasi lain.
  static Future<void> shareRapor(RaporModel rapor) async {
    final Uint8List bytes = await _buildPdf(rapor);
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'Rapor_${rapor.namaSantri}_${rapor.semester}.pdf',
    );
  }

  // ── BUILDER UTAMA ────────────────────────────────────────────

  static Future<Uint8List> _buildPdf(RaporModel rapor) async {
    final pw.Document doc = pw.Document(
      title: 'Rapor ${rapor.namaSantri}',
      author: 'Pondok Pesantren Khoirul Huda',
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.fromLTRB(18, 14, 18, 14),
        build: (_) => [
          _buildKop(),
          pw.SizedBox(height: 6),
          _buildJudul(),
          pw.SizedBox(height: 6),
          _buildInfoSantri(rapor),
          pw.SizedBox(height: 8),
          _buildTabelNilai(rapor),
          pw.SizedBox(height: 8),
          _buildPeringkatEkskul(rapor),
          pw.SizedBox(height: 8),
          _buildCatatanWaliKelas(rapor),
          pw.SizedBox(height: 8),
          _buildRingkasanBawah(rapor),
          pw.SizedBox(height: 16),
          _buildTandaTangan(),
        ],
      ),
    );

    return doc.save();
  }

  // ── SECTION 1 : KOP SEKOLAH ──────────────────────────────────

  static pw.Widget _buildKop() {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: _hijauTua,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      padding: pw.EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            'PONDOK PESANTREN KHOIRUL HUDA',
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Container(
            height: 1.5,
            color: _emas,
            margin: pw.EdgeInsets.symmetric(vertical: 4),
          ),
          pw.Text(
            'Jl. Contoh No. 1, Kec. Pesantren, Kab. Santri',
            style: pw.TextStyle(color: PdfColors.white, fontSize: 8),
          ),
        ],
      ),
    );
  }

  // ── SECTION 2 : JUDUL RAPOR ──────────────────────────────────

  static pw.Widget _buildJudul() {
    return pw.Center(
      child: pw.Column(
        children: [
          pw.Text(
            'RAPOR PONDOK',
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            'PENILAIAN AKHIR SEMESTER',
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Divider(color: _hijauTua, thickness: 1),
        ],
      ),
    );
  }

  // ── SECTION 3 : INFO SANTRI ──────────────────────────────────

  static pw.Widget _buildInfoSantri(RaporModel rapor) {
    return pw.Container(
      padding: pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _abusGaris),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _infoRow('NAMA', rapor.namaSantri),
                _infoRow('NOMOR INDUK', rapor.santriId),
                _infoRow('JENJANG', 'Madrasah Tsanawiyah'),
              ],
            ),
          ),
          pw.SizedBox(width: 10),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _infoRow('KELAS', rapor.kelas),
                _infoRow('SEMESTER', rapor.semester),
                _infoRow('TAHUN PELAJARAN', rapor.tahunAjaran),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _infoRow(String label, String value) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 95,
            child: pw.Text(
              label,
              style:
                  pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Text(': ', style: pw.TextStyle(fontSize: 8.5)),
          pw.Expanded(
            child: pw.Text(value, style: pw.TextStyle(fontSize: 8.5)),
          ),
        ],
      ),
    );
  }

  // ── SECTION 4 : TABEL NILAI ──────────────────────────────────

  static pw.Widget _buildTabelNilai(RaporModel rapor) {
    final List<pw.TableRow> rows = [];

    // — Header kolom —
    rows.add(pw.TableRow(
      decoration: pw.BoxDecoration(color: _hijauTua),
      children: [
        _thCell('NO'),
        _thCell('MATA PELAJARAN'),
        _thCell('Ket.'),
        _thCell('KKM'),
        _thCell('NILAI\nTeori'),
        _thCell('NILAI\nPraktek'),
      ],
    ));

    int rowNo = 0;
    double totalNilai = 0;
    int totalKkm = 0;

    _kelompokMapel.forEach((String grupLabel, Map<String, String> mapelMap) {
      // — Header kelompok (full-width, dibuat dengan 6 sel kosong + 1 sel label) —
      rows.add(pw.TableRow(
        decoration: pw.BoxDecoration(color: _hijauLight),
        children: [
          // Sel pertama berisi label kelompok
          pw.Padding(
            padding: pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: pw.Text(
              grupLabel,
              style: pw.TextStyle(
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
                color: _hijauTua,
              ),
            ),
          ),
          // 5 sel kosong agar kolom tetap terjaga
          pw.SizedBox(), pw.SizedBox(),
          pw.SizedBox(), pw.SizedBox(), pw.SizedBox(),
        ],
      ));

      int idx = 0;
      mapelMap.forEach((String mapelId, String mapelLabel) {
        rowNo++;
        final double nilai = rapor.nilaiMataPelajaran[mapelId] ?? 0.0;
        final int kkm = _kkmMapel[mapelId] ?? 50;
        totalNilai += nilai;
        totalKkm += kkm;

        final PdfColor nColor = _nilaiColor(nilai);
        final PdfColor rowBg = idx.isOdd ? _abusAbu : PdfColors.white;

        rows.add(pw.TableRow(
          decoration: pw.BoxDecoration(color: rowBg),
          children: [
            _tdCell(rowNo.toString(), center: true),
            _tdCell(mapelId),
            _tdCell(mapelLabel),
            _tdCell(kkm.toString(), center: true),
            // Nilai teori — kotak berwarna
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              child: pw.Center(
                child: pw.Container(
                  padding: pw.EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: pw.BoxDecoration(
                    color: nColor,
                    borderRadius: pw.BorderRadius.circular(3),
                  ),
                  child: pw.Text(
                    nilai.toStringAsFixed(0),
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // Nilai praktek (placeholder)
            _tdCell('-', center: true),
          ],
        ));
        idx++;
      });
    });

    // — Baris JUMLAH —
    rows.add(pw.TableRow(
      decoration: pw.BoxDecoration(color: _hijauTua),
      children: [
        // Label JUMLAH spanning kolom 0-2 (dibuat manual 3 sel)
        pw.Padding(
          padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
          child: pw.Text(
            'JUMLAH',
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 8.5,
              fontWeight: pw.FontWeight.bold,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.SizedBox(), // kolom 1 kosong (label JUMLAH menempati lebar kolom 0)
        pw.SizedBox(), // kolom 2 kosong
        // Total KKM
        _jumlahCell(totalKkm.toString()),
        // Total Nilai
        _jumlahCell(totalNilai.toStringAsFixed(0)),
        // Kolom praktek kosong
        _jumlahCell(''),
      ],
    ));

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _hijauTua, width: 1),
        borderRadius: pw.BorderRadius.circular(2),
      ),
      child: pw.Table(
        columnWidths: const {
          0: pw.FixedColumnWidth(22),
          1: pw.FlexColumnWidth(3.2),
          2: pw.FlexColumnWidth(1.8),
          3: pw.FixedColumnWidth(32),
          4: pw.FixedColumnWidth(42),
          5: pw.FixedColumnWidth(42),
        },
        border: pw.TableBorder.all(color: _abusGaris, width: 0.4),
        children: rows,
      ),
    );
  }

  // ── SECTION 5 : PERINGKAT & EKSKUL ──────────────────────────

  static pw.Widget _buildPeringkatEkskul(RaporModel rapor) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Peringkat kelas
        pw.Container(
          width: double.infinity,
          padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: pw.BoxDecoration(color: _hijauLight),
          child: pw.Text(
            'Peringkat Kelas ke- ${rapor.rankKelas}     dari     ${rapor.totalSiswaKelas}',
            style: pw.TextStyle(
              fontSize: 8.5,
              fontWeight: pw.FontWeight.bold,
              color: _hijauTua,
            ),
          ),
        ),
        pw.SizedBox(height: 2),
        // Kegiatan ekskul
        pw.Container(
          width: double.infinity,
          padding: pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            color: _abusAbu,
            border: pw.Border.all(color: _abusGaris),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'Kegiatan Ekstrakurikuler dan Kepribadian',
                  style: pw.TextStyle(
                    fontSize: 8.5,
                    fontWeight: pw.FontWeight.bold,
                    color: _hijauTua,
                  ),
                ),
              ),
              pw.SizedBox(height: 4),
              ..._ekskul.map(
                (String e) => pw.Padding(
                  padding: pw.EdgeInsets.only(bottom: 2),
                  child: pw.Text(e, style: pw.TextStyle(fontSize: 8)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── SECTION 6 : CATATAN WALI KELAS ──────────────────────────

  static pw.Widget _buildCatatanWaliKelas(RaporModel rapor) {
    return pw.Container(
      width: double.infinity,
      padding: pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: _hijauBg,
        borderRadius: pw.BorderRadius.circular(4),
        border: pw.Border.all(color: _hijauMid, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Catatan Wali Kelas:',
            style: pw.TextStyle(
              fontSize: 8.5,
              fontWeight: pw.FontWeight.bold,
              color: _hijauTua,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            '"${rapor.catatanWaliKelas}"',
            style: pw.TextStyle(
              fontSize: 8,
              fontStyle: pw.FontStyle.italic,
              color: PdfColors.black,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Tanggal: ${_formatTanggal(rapor.tanggalRapor)}',
              style: pw.TextStyle(fontSize: 7, color: PdfColors.grey),
            ),
          ),
        ],
      ),
    );
  }

  // ── SECTION 7 : RINGKASAN BAWAH ─────────────────────────────

  static pw.Widget _buildRingkasanBawah(RaporModel rapor) {
    final double rata = rapor.nilaiRataRata;

    // Gunakan List<Map> agar kompatibel semua versi Dart (tanpa Record syntax)
    final List<Map<String, String>> items = [
      {'label': 'Nilai Rata-rata', 'value': rata.toStringAsFixed(1)},
      {'label': 'Predikat', 'value': _predikatLabel(rata)},
      {'label': 'Tanggal Rapor', 'value': _formatTanggal(rapor.tanggalRapor)},
    ];

    return pw.Row(
      children: items.map((Map<String, String> item) {
        return pw.Expanded(
          child: pw.Container(
            margin: pw.EdgeInsets.only(right: 4),
            padding: pw.EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            decoration: pw.BoxDecoration(
              color: _hijauTua,
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  item['label']!,
                  style: pw.TextStyle(color: PdfColors.white, fontSize: 7),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  item['value']!,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── SECTION 8 : TANDA TANGAN ─────────────────────────────────

  static pw.Widget _buildTandaTangan() {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sigCol('Mengetahui,\nOrang Tua / Wali', '( _________________ )'),
        _sigCol('Mengetahui,\nKepala Pondok', 'Ust. _______________'),
        _sigCol('Wali Kelas,', 'Ust. _______________'),
      ],
    );
  }

  static pw.Widget _sigCol(String title, String name) {
    return pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(title,
              style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center),
          pw.SizedBox(height: 36),
          pw.Container(
            height: 0.5,
            color: PdfColors.black,
            margin: pw.EdgeInsets.symmetric(horizontal: 8),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            name,
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── CELL HELPERS ─────────────────────────────────────────────

  /// Header cell (latar hijau, teks putih tebal).
  static pw.Widget _thCell(String text) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: pw.Center(
        child: pw.Text(
          text,
          style: pw.TextStyle(
            color: PdfColors.white,
            fontSize: 7.5,
            fontWeight: pw.FontWeight.bold,
          ),
          textAlign: pw.TextAlign.center,
        ),
      ),
    );
  }

  /// Data cell biasa.
  static pw.Widget _tdCell(String text, {bool center = false}) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 7.5),
        textAlign: center ? pw.TextAlign.center : pw.TextAlign.left,
      ),
    );
  }

  /// Cell untuk baris JUMLAH (teks putih tebal).
  static pw.Widget _jumlahCell(String text) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(horizontal: 3, vertical: 5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 8.5,
          fontWeight: pw.FontWeight.bold,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }
}

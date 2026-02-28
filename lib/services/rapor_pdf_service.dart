import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/rapor_model.dart';

const _greenPrimary = PdfColor.fromInt(0xFF1B5E20);
const _black = PdfColors.black;
const _darkGrey = PdfColor.fromInt(0xFF424242);
const _lightGrey = PdfColor.fromInt(0xFFEEEEEE);

const Map<String, List<String>> _structureMapel = {
  "Al-Qur'an & Tahfidz": ['Tahfidz Al-Qur\'an', 'Tajwid', 'Tilawah'],
  'Fiqih & Ushul': ['Fiqih', 'Ushul Fiqih', 'Faroidh'],
  'Bahasa Arab & Nahwu Sharaf': ['Nahwu', 'Sharaf', 'Bahasa Arab'],
  'Ilmu Agama Lainnya': [
    'Aqidah / Tauhid',
    'Akhlaq / Tasawuf',
    'Hadits',
    'Tafsir'
  ],
};

class RaporPdfService {
  static Future<void> cetakRapor(RaporModel rapor) async {
    await Printing.layoutPdf(
      onLayout: (_) => _buildPdf(rapor),
      name: 'Rapor_${rapor.namaSantri.replaceAll(' ', '_')}',
    );
  }

  static Future<void> shareRapor(RaporModel rapor) async {
    final Uint8List bytes = await _buildPdf(rapor);
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'Rapor_${rapor.namaSantri.replaceAll(' ', '_')}.pdf',
    );
  }

  static Future<Uint8List> _buildPdf(RaporModel rapor) async {
    final pw.Document doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(vertical: 40, horizontal: 50),
        build: (pw.Context context) {
          return [
            _buildHeader(),
            pw.SizedBox(height: 20),
            _buildStudentInfo(rapor),
            pw.SizedBox(height: 20),
            _buildGradesTable(rapor),
            pw.SizedBox(height: 20),
            _buildFinalSummary(rapor),
            pw.SizedBox(height: 50),
            _buildSignatureSection(rapor),
          ];
        },
      ),
    );

    return doc.save();
  }

  static pw.Widget _buildHeader() {
    return pw.Column(
      children: [
        pw.Text(
          'PONDOK PESANTREN KHOIRUL HUDA',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: _greenPrimary,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'LAPORAN HASIL BELAJAR SANTRI',
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Container(height: 1.5, color: _greenPrimary, width: double.infinity),
        pw.SizedBox(height: 1),
        pw.Container(height: 0.5, color: _greenPrimary, width: double.infinity),
      ],
    );
  }

  static pw.Widget _buildStudentInfo(RaporModel rapor) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            children: [
              _infoRow('Nama Santri', rapor.namaSantri),
              _infoRow('Nomor Induk', rapor.santriId),
            ],
          ),
        ),
        pw.SizedBox(width: 40),
        pw.Expanded(
          child: pw.Column(
            children: [
              _infoRow(
                  'Kelas / Semester', '${rapor.kelas} / ${rapor.semester}'),
              _infoRow('Tahun Pelajaran', rapor.tahunAjaran),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _infoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        children: [
          pw.SizedBox(
              width: 80,
              child: pw.Text(label, style: const pw.TextStyle(fontSize: 9))),
          pw.Text(': ', style: const pw.TextStyle(fontSize: 9)),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildGradesTable(RaporModel rapor) {
    final headers = ['No', 'Mata Pelajaran', 'KKM', 'Nilai Akhir', 'Predikat'];

    final List<pw.TableRow> rows = [];

    rows.add(
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: _greenPrimary),
        children: headers
            .map((h) => pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Text(
                    h,
                    style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold),
                    textAlign: pw.TextAlign.center,
                  ),
                ))
            .toList(),
      ),
    );

    int no = 1;

    _structureMapel.forEach((kategori, listMapel) {
      final mapelAda = listMapel
          .where((m) => rapor.nilaiMataPelajaran.containsKey(m))
          .toList();

      if (mapelAda.isNotEmpty) {
        rows.add(
          pw.TableRow(
            decoration: const pw.BoxDecoration(color: _lightGrey),
            children: [
              pw.SizedBox(),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(
                  kategori.toUpperCase(),
                  style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                      color: _greenPrimary),
                ),
              ),
              pw.SizedBox(),
              pw.SizedBox(),
              pw.SizedBox(),
            ],
          ),
        );

        for (var mapel in mapelAda) {
          final nilai = rapor.nilaiMataPelajaran[mapel] ?? 0;
          rows.add(
            pw.TableRow(
              children: [
                _cellText('$no', align: pw.TextAlign.center),
                _cellText(mapel),
                _cellText('70', align: pw.TextAlign.center),
                _cellText(nilai.toStringAsFixed(0),
                    align: pw.TextAlign.center, isBold: true),
                _cellText(_getPredikatLabel(nilai), align: pw.TextAlign.center),
              ],
            ),
          );
          no++;
        }
      }
    });

    return pw.Table(
      columnWidths: {
        0: const pw.FixedColumnWidth(30),
        1: const pw.FlexColumnWidth(4),
        2: const pw.FixedColumnWidth(40),
        3: const pw.FixedColumnWidth(60),
        4: const pw.FixedColumnWidth(60),
      },
      border: pw.TableBorder.all(color: _darkGrey, width: 0.5),
      children: rows,
    );
  }

  static pw.Widget _buildFinalSummary(RaporModel rapor) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _darkGrey, width: 0.5),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _summaryItem('JUMLAH NILAI', _hitungTotal(rapor).toStringAsFixed(0)),
          _summaryItem('RATA-RATA', rapor.nilaiRataRata.toStringAsFixed(2)),
          _summaryItem('PREDIKAT UMUM', _getPredikatLabel(rapor.nilaiRataRata)),
        ],
      ),
    );
  }

  static pw.Widget _buildSignatureSection(RaporModel rapor) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _sigBox(
            'Mengetahui,\nOrang Tua / Wali', '( ........................... )'),
        _sigBox('Tangerang, ${_formatTanggal(rapor.tanggalRapor)}\nWali Kelas',
            '( ........................... )'),
      ],
    );
  }

  static pw.Widget _cellText(String text,
      {pw.TextAlign align = pw.TextAlign.left,
      bool isBold = false,
      double size = 9}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
            fontSize: size,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal),
      ),
    );
  }

  static pw.Widget _summaryItem(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(label,
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
        pw.SizedBox(height: 2),
        pw.Text(value,
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  static pw.Widget _sigBox(String title, String name) {
    return pw.Column(
      children: [
        pw.Text(title,
            textAlign: pw.TextAlign.center,
            style: const pw.TextStyle(fontSize: 9)),
        pw.SizedBox(height: 60),
        pw.Text(name,
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  static double _hitungTotal(RaporModel rapor) {
    if (rapor.nilaiMataPelajaran.isEmpty) return 0;
    return rapor.nilaiMataPelajaran.values.reduce((a, b) => a + b);
  }

  static String _getPredikatLabel(double n) {
    if (n >= 90) return 'Istimewa';
    if (n >= 80) return 'Sangat Baik';
    if (n >= 70) return 'Baik';
    if (n >= 60) return 'Cukup';
    return 'Gagal';
  }

  static String _formatTanggal(DateTime dt) {
    const bulan = [
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
      'Desember'
    ];
    return '${dt.day} ${bulan[dt.month]} ${dt.year}';
  }
}

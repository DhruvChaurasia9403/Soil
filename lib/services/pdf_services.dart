// lib/services/pdf_service.dart
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../models/soil_reading.dart';

class PdfService {
  final pw.Document pdf = pw.Document();

  Future<Uint8List> generateSoilReadingsPdf(List<SoilReading> readings) async {
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Soil Readings',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              _buildTable(readings),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildTable(List<SoilReading> readings) {
    final headers = ['Timestamp', 'Temperature (°C)', 'Moisture (%)'];

    final data = readings.map((reading) {
      return [
        reading.timestamp.toLocal().toString(),
        reading.temperature.toStringAsFixed(1),
        reading.moisture.toStringAsFixed(1),
      ];
    }).toList();

    return pw.Table.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(width: 0.5),
      headerDecoration: pw.BoxDecoration(color: PdfColors.red300),
      headerStyle:
      pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      cellAlignment: pw.Alignment.centerLeft,
      cellStyle: pw.TextStyle(fontSize: 12),
      cellHeight: 25,
      columnWidths: {
        0: pw.FlexColumnWidth(3),
        1: pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(2),
      },
    );
  }
}

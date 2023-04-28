import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:external_path/external_path.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:simple_login/helper/firebase_helper.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:http/http.dart' show get;
import 'package:simple_login/main.dart';

String pdfDateFormat(String date) {
  String year = date.substring(0, 4);
  String month = date.substring(4, 6);
  String day = date.substring(6);
  return year + "-" + month + "-" + day;
}

String timeRemoveColon(String time) {
  return time.substring(0, 2) + time.substring(3, 5);
}

Future<File> createfile(String filename) async {
  Directory dir = await getApplicationDocumentsDirectory();
  String pathName = path.join(dir.path, filename);
  return File(pathName);
}

void pdfGen(List appointment) async {
  // Check if we have permission to write to external storage
  if (await Permission.storage.request().isDenied) {
    print('permission denied');
    return;
  }

  // Get the downloads directory
  final downloadsDir = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOADS);
  if (downloadsDir == null) {
    print('Failed to get downloads directory');
    return;
  }

  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  print(formattedDate); // prints something like: 2023-04-28

  String appointmentDate = pdfDateFormat(appointment[0]);
  var historyId = appointment[0] + timeRemoveColon(appointment[1]);
  var uid = getUID();
  print('patient/$uid/history/$historyId');
  var report = await readFromServer('patient/$uid/history/$historyId');
  print(report);
  if (report == null) return;
  var netimage = await loadStorageUrl(report['signature_url']);
  final response = await get(Uri.parse(netimage));
  final bytes = response.bodyBytes;
  var myFile = await createfile(report['signature_url'] + '.png');
  await myFile.writeAsBytes(bytes);
  final image = pw.MemoryImage(
    myFile.readAsBytesSync(),
  );
  var profile = await readFromServer('patient/$uid');
  if(profile == null) return;
  var fullname = profile['first name'] + ' ' + profile['last name'];
  final pdf = pw.Document();
  // Add a page to the document
  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Title and date
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Medical report', style: pw.TextStyle(fontSize: 24)),
                pw.Text(formattedDate, style: pw.TextStyle(fontSize: 16)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Doctor: ${appointment[2]}",
                    style: pw.TextStyle(fontSize: 14)),
                pw.Text('Appointment time: $appointmentDate ${appointment[1]}',
                    style: pw.TextStyle(fontSize: 14)),
              ],
            ),
            pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text('Patient Name: $fullname', style: pw.TextStyle(fontSize: 16)),
                ),
            pw.SizedBox(height: 16),
            // Paragraphs with topics
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Header(
                    level: 0,
                    title: 'Diagnosis',
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: <pw.Widget>[
                          pw.Text('Diagnosis', textScaleFactor: 2),
                          pw.PdfLogo()
                        ])),
                pw.Paragraph(text: report['diagnosis']),
                pw.Header(level: 0, text: 'Medication'),
                pw.Paragraph(text: report['medicine']),
                pw.Header(level: 0, text: 'Extra Notes'),
                pw.Paragraph(text: report['extra_notes']),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text('Doctor Signature', style: pw.TextStyle(fontSize: 16)),
                ),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Image(image),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );

  // Save the PDF document to a file
  print(downloadsDir);
  final file = File('${downloadsDir}/$historyId.pdf');
  await file.writeAsBytes(await pdf.save());
  print('saved pdf');
  myFile.delete();
}

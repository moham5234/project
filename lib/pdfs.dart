import 'dart:io';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'Models/model_Appointment.dart';

class PDFs {
  static String target = '';
  static String deta = '';
  static String titell = '';
  static String sum = '';
  static List data = [];

  static void getAppointmentsData({
    required String target_,
    required String title_,
    required String date_,
    required List<Appointment> appointments,
  }) {
    target = target_;
    titell = title_;
    deta = date_;
    data = appointments
        .map((appointment) => {
              "serves": appointment.name,
              "address": appointment.address,
              "time": appointment.time,
              "date": appointment.date,
              "notes": appointment.notes,
              "status": appointment.status,
            })
        .toList();
    sum = "";
  }

  static init() async {
    arFont = pw.Font.ttf(await rootBundle.load(
        "Assets/fonts/alfont_com_AlFont_com_DINNextLTArabic-Regular-4.ttf"));
  }

  static pw.Widget IMG(i) {
    return pw.Center(child: pw.Expanded(child: i));
  }

  static late pw.Font arFont;

  static createPdf({required String fileName}) async {
    await init();

    Directory downloaddirct = Directory('/storage/emulated/0/Download');
    String path = '${downloaddirct.path}/$fileName.pdf';
    print('PDF Saved to: $path');
    Platform.isAndroid
        ? await getApplicationDocumentsDirectory()
        : await getTemporaryDirectory();

    File file = File(path);

    pw.Document pdf = pw.Document();



    pdf.addPage(pw.MultiPage(
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(
          base: arFont,
        ),
        build: (context) => [
              pw.Column(children: [
                pw.Container(
                  margin: const pw.EdgeInsets.only(top: -40),
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: []),
                ),
                pw.Container(
                    margin: const pw.EdgeInsets.only(top: 30),
                    alignment: pw.Alignment.topRight,
                    child: pw.Text(
                      "${PDFs.titell}",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 13,
                      ),
                    )),
                pw.Container(
                  color: PdfColor.fromHex("#6872ACFF"),
                  child: pw.Table(
                    border: pw.TableBorder.all(
                        color: PdfColor.fromHex("#FFFFFFFF")),
                    children: [
                      pw.TableRow(children: [
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                              alignment: pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                "الحاله",
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#FFFFFFFF"),
                                  fontSize: 15,
                                ),
                              )),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                              alignment: pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                "ملاحظات",
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#FFFFFFFF"),
                                  fontSize: 15,
                                ),
                              )),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                              alignment: pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                "التاريخ",
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#FFFFFFFF"),
                                  fontSize: 15,
                                ),
                              )),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                              alignment: pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                "العنوان",
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#FFFFFFFF"),
                                  fontSize: 15,
                                ),
                              )),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                              alignment: pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                "الاسم",
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#FFFFFFFF"),
                                  fontSize: 15,
                                ),
                              )),
                        ),
                      ]),
                    ],
                  ),
                ),
                ...List.generate(
                  PDFs.data.length,
                  (index) => pw.Container(
                    color: index % 2 == 0
                        ? PdfColor.fromHex("#DEE3F4FF")
                        : PdfColor.fromHex("#FFFFFFFF"),
                    child: pw.Table(
                      border: pw.TableBorder.all(
                          color: PdfColor.fromHex("#DEE3F4FF")),
                      children: [
                        pw.TableRow(children: [
                          pw.Expanded(
                            flex: 1,
                            child: pw.Container(
                                alignment: pw.Alignment.center,
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  " ${PDFs.data[index]["status"]} ",
                                  textAlign: pw.TextAlign.center,
                                  style: const pw.TextStyle(
                                    fontSize: 13,
                                  ),
                                )),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Container(
                                alignment: pw.Alignment.center,
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  " ${PDFs.data[index]["notes"]} ",
                                  textAlign: pw.TextAlign.center,
                                  style: const pw.TextStyle(
                                    fontSize: 13,
                                  ),
                                )),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Container(
                                alignment: pw.Alignment.center,
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  "${PDFs.data[index]["time"]}\n${PDFs.data[index]["date"]}",
                                  textAlign: pw.TextAlign.center,
                                  style: const pw.TextStyle(
                                    fontSize: 13,
                                  ),
                                )),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Container(
                                alignment: pw.Alignment.center,
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  " ${PDFs.data[index]["address"]} ",
                                  textAlign: pw.TextAlign.center,
                                  style: const pw.TextStyle(
                                    fontSize: 13,
                                  ),
                                )),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Container(
                                alignment: pw.Alignment.center,
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  "${PDFs.data[index]["serves"]}",
                                  textAlign: pw.TextAlign.center,
                                  style: const pw.TextStyle(
                                    fontSize: 13,
                                  ),
                                )),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ]),
            ]));

    Uint8List bytes = await pdf.save();
    await file.writeAsBytes(bytes);

    await OpenFile.open(file.path);
  }
}

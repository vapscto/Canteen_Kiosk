import 'dart:typed_data';

import 'package:canteen_kiosk_application/canteen_admin/admin_api/admin_api.dart';
import 'package:canteen_kiosk_application/canteen_management/controller/canteen_controller.dart';
import 'package:canteen_kiosk_application/canteen_management/model/bill_model.dart';
import 'package:canteen_kiosk_application/canteen_management/screens/kiosk_bill_preview.dart';
import 'package:canteen_kiosk_application/controller/global_utility.dart';
import 'package:canteen_kiosk_application/controller/mskool_controller.dart';
import 'package:canteen_kiosk_application/main.dart';
import 'package:canteen_kiosk_application/widgets/common_qr_code.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words_english/number_to_words_english.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;


class GenerateBillKiosk {
  GenerateBillKiosk.init();
  static final GenerateBillKiosk instance = GenerateBillKiosk.init();

  generateNow(
      {required CanteenManagementController controller,
        String? date,
        int? id,
        required MskoolController mskoolController}) async {
    final document =pw.Document();
    String dateFormat(DateTime dt) {
      return '${dt.day}-${dt.month}-${dt.year}';
    }
    String getTime(DateTime dt) {
      final DateFormat formatter = DateFormat('h:mm a');
      return formatter.format(dt);
    }
    var logo = await networkImage(controller.billModel.first.logo!);
    document.addPage(
     pw. Page(
        margin: const pw.EdgeInsets.only(
          top: 0,
        ),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return  pw.Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    height: 100,
                    width: 100,
                    child: Image(logo),
                  ),
                  pw.SizedBox(height: 3.0),
                  pw.Text(
                    "Bill No.: ${controller.billModel.first.cMOrderID}",
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColor.fromHex("#000000"),
                    ),
                  ),
                  pw.Container(
                    width: 120,
                    child: pw.Text(
                      'Name : ${controller.billModel.first.aMSTFirstName}',
                      maxLines: 2,
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColor.fromHex("#000000"),
                      ),
                    ),
                  ),
                  // (staffStudentFlag == 's')
                  //     ? pw.Text(
                  //   'Roll No. : ${controller.billModel.first.rollNo} Class  :${controller.billModel.first.className} | ${controller.billModel.first.sectionName}',
                  //   style: pw.TextStyle(
                  //     fontSize: 10,
                  //     color: PdfColor.fromHex("#000000"),
                  //   ),
                  // )
                  //     : pw.Text(
                  //   'Emp Code : ${controller.billModel.first.rollNo} ',
                  //   style: pw.TextStyle(
                  //     fontSize: 10,
                  //     color: PdfColor.fromHex("#000000"),
                  //   ),
                  // ),
                  pw.Text(
                    'Date/Time: ${dateFormat(DateTime.parse(date!))} / ${getTime(DateTime.parse(date))}',
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColor.fromHex("#000000"),
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Table(
                    tableWidth: TableWidth.min,
                    children: [
                      pw.TableRow(
                        decoration: pw.BoxDecoration(
                            border: pw.Border(
                                bottom: pw.BorderSide(
                                    color: PdfColor.fromHex('#000000')))),
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.all(1.0),
                            child: pw.Text(
                              "Name",
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColor.fromHex("#000000"),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(3.0),
                            child:pw. Text(
                              "Qty",
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColor.fromHex("#000000"),
                              ),
                            ),
                          ),
                          pw.Container(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                "Price",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: PdfColor.fromHex("#000000"),
                                ),
                              )),
                          pw.Container(
                              padding: const EdgeInsets.all(1.0),
                              child: Text(
                                "Amount",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: PdfColor.fromHex("#000000"),
                                ),
                              )),
                        ],
                      ),
                      ...List.generate(controller.billModel.length, (index) {
                        return pw.TableRow(children: [
                          pw.Container(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              controller.billModel[index].cMTRANSIName ?? '',
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 10,
                                color: PdfColor.fromHex("#000000"),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              controller.billModel[index].cMTRANSQty.toString(),
                              style: TextStyle(
                                fontSize: 10,
                                color: PdfColor.fromHex("#000000"),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              controller.billModel[index].cMTRANSIUnitRate
                                  .toString(),
                              style: TextStyle(
                                fontSize: 10,
                                color: PdfColor.fromHex("#000000"),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const EdgeInsets.all(1.0),
                            child: Text(
                              (controller.billModel[index].cMTRANSIUnitRate! *
                                  controller.billModel[index].cMTRANSQty!)
                                  .toString(),
                              style: TextStyle(
                                fontSize: 10,
                                color: PdfColor.fromHex("#000000"),
                              ),
                            ),
                          ),
                        ]);
                      }),

                    ],
                  ),
                  pw. SizedBox(height: 3.0),
                  pw.Text(
                    "Total Quantity : ${controller.quantity}",
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColor.fromHex("#000000"),
                    ),
                  ),
                  pw.SizedBox(height: 3.0),
                  pw. Text(
                    "Total Amount : ${controller.billModel.first.cMTRANSTotalAmount}",
                    style:pw. TextStyle(
                      fontSize: 10,
                      color: PdfColor.fromHex("#000000"),
                    ),
                  ),
                  pw.SizedBox(height: 3.0),
                  pw.Text(
                    "Amount In Words : ${NumberToWordsEnglish.convert(controller.billModel.first.cMTRANSTotalAmount!.toInt())} rupees only",
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColor.fromHex("#000000"),
                    ),
                  ),
                  pw. SizedBox(height: 5.0),
                  pw. Container(
                    decoration: pw.BoxDecoration(
                        borderRadius: pw.BorderRadius.circular(2),
                        border: pw.Border.all(color: PdfColors.black)),
                    child: getQrCode(controller.billModel.first.cMOrderID!),
                  ),
                  pw. SizedBox(height: 15),

                ],
              );
        },
      ),
    );
    try {
      bool printResult = await Printing.directPrintPdf(
        onLayout: (PdfPageFormat format) async => document.save(),
        printer: await _getRpc327Printer(),
      );
      if (printResult) {

        logger.i("Print successful");
        await oneTimePrint(
          base: baseUrlFromInsCode("canteen", mskoolController),
          orderId: controller.billModel.first.cMOrderID!,
        );
        Get.back();
      } else {
        logger.i("Print failed");

      }
    } catch (e) {
      logger.e("Error during printing: $e");

    }


  }
List<Printer> printers1 = [];
  Future<Printer> _getRpc327Printer() async {
    final printers = await Printing.listPrinters();
    printers1 = printers;
    for (var element in printers) {
      logger.w(element.name);
    }
    return printers.first;
    //   printers.firstWhere((printer)
    // => printer.name == 'RP327 Printer');
  }
}





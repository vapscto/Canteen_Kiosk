import 'package:canteen_kiosk_application/canteen_admin/admin_api/admin_api.dart';
import 'package:canteen_kiosk_application/canteen_management/controller/canteen_controller.dart';
import 'package:canteen_kiosk_application/controller/global_utility.dart';
import 'package:canteen_kiosk_application/controller/mskool_controller.dart';
import 'package:canteen_kiosk_application/main.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../model/bill_model.dart';

class KioskKotPrint {
  KioskKotPrint.init();

  static final KioskKotPrint instance = KioskKotPrint.init();

  kotBill(
      {required CanteenManagementController controller,
        String? date,
        int? id,
        required MskoolController mskoolController}) async {
    fetchLeadCommentsReport(controller);
    for (var i in quickSearchKotList) {
      await kot(
          date: date,
          mskoolController: mskoolController,
          data: i.items,
          controller: controller);
    }
  }
  void fetchLeadCommentsReport(CanteenManagementController controller) {
    quickSearchKotList.clear();

    for (var dev in controller.billModel) {
      var category = quickSearchKotList.firstWhere(
              (cat) => cat.categoryId == dev.cMMCAId,
          orElse: () {
            var newCategory = QuickSearchCategory(dev.cMMCAId!, []);
            quickSearchKotList.add(newCategory);
            return newCategory;
          }
      );
      category.items.add(dev);
    }
  }
  kot(
      {required CanteenManagementController controller,
        String? date,
        required MskoolController mskoolController,
        required List<TransationBillModelValues> data}) async {
    String dateFormat(DateTime dt) {
      return '${dt.day}-${dt.month}-${dt.year}';
    }

    String getTime(DateTime dt) {
      final DateFormat formatter = DateFormat('h:mm a');
      return formatter.format(dt);
    }

    var logo = await networkImage(controller.billModel.first.logo!);
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
        margin: const pw.EdgeInsets.only(top: 0),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Container(
                      height: 100,
                      width: 100,
                      child: pw.Image(logo),
                    ),
                    pw.Text(
                      "Bill No.: ${data.first.cMOrderID}",
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColor.fromHex("#000000"),
                      ),
                    ),
                    pw.Container(
                      width: 120,
                      child: pw.Text(
                        'Name  : ${data.first.aMSTFirstName}',
                        maxLines: 2,
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: PdfColor.fromHex("#000000"),
                        ),
                      ),
                    ),
                    pw.Text(
                      'Date/Time: ${dateFormat(DateTime.parse(date!))} / ${getTime(DateTime.parse(date))}',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColor.fromHex("#000000"),
                      ),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Table(
                        tableWidth: pw.TableWidth.min,
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
                                    "Food Name",
                                    maxLines: 2,
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      color: PdfColor.fromHex("#000000"),
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  padding: const pw.EdgeInsets.all(1.0),
                                  child: pw.Text(
                                    "Qty",
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      color: PdfColor.fromHex("#000000"),
                                    ),
                                  ),
                                ),
                                pw.Container(
                                    padding: const pw.EdgeInsets.all(1.0),
                                    child: pw.Text(
                                      "Price",
                                      style: pw.TextStyle(
                                        fontSize: 10,
                                        color: PdfColor.fromHex("#000000"),
                                      ),
                                    )),
                                pw.Container(
                                    padding: const pw.EdgeInsets.all(1.0),
                                    child: pw.Text(
                                      "Amount",
                                      style: pw.TextStyle(
                                        fontSize: 10,
                                        color: PdfColor.fromHex("#000000"),
                                      ),
                                    )),
                              ]
                          ),
                          ...data.map((item) => pw.TableRow(
                              children: [
                                pw.Container(
                                  padding: const pw.EdgeInsets.all(1.0),
                                  child: pw.Text(
                                    item.cMTRANSIName ?? '',
                                    maxLines: 2,
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      color: PdfColor.fromHex("#000000"),
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  padding: const pw.EdgeInsets.all(1.0),
                                  child: pw.Text(
                                    item.cMTRANSQty.toString(),
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      color: PdfColor.fromHex("#000000"),
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  padding: const pw.EdgeInsets.all(1.0),
                                  child: pw.Text(
                                    item.cMTRANSIUnitRate.toString(),
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      color: PdfColor.fromHex("#000000"),
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  padding: const pw.EdgeInsets.all(1.0),
                                  child: pw.Text(
                                    (item.cMTRANSIUnitRate! * item.cMTRANSQty!).toString(),
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      color: PdfColor.fromHex("#000000"),
                                    ),
                                  ),
                                ),
                              ]
                          ))
                        ]
                    ),
                  ]));
        }));
    try {
      bool printResult = await Printing.directPrintPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        printer: await _getRpc327Printer(),
      );
      if (printResult) {
        // await oneTimePrint(
        //   base: baseUrlFromInsCode("canteen", mskoolController),
        //   orderId: controller.billModel.first.cMOrderID!,
        // );
        logger.i("Print successful");
      } else {
        logger.i("Print failed");
      }
    } catch (e) {
      logger.i("Error during printing: $e");
    }
  }
  Future<Printer> _getRpc327Printer() async {
    final printers = await Printing.listPrinters();
    for (var element in printers) {
      logger.w(element.name);
    }
    return printers.first;
  }
  List<QuickSearchCategory> quickSearchKotList = [];
}
class QuickSearchCategory {
  final int categoryId;
  final List<TransationBillModelValues> items;

  QuickSearchCategory(this.categoryId, this.items);
}
import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
const int PRINTER_STATUS_POWER_SAVE = 0x00002000;
const int PRINTER_STATUS_OFFLINE = 0x00000080;
const int PRINTER_STATUS_PAPER_OUT = 0x00000040;
final winspool = DynamicLibrary.open('winspool.drv');

final openPrinter = winspool.lookupFunction<
    Int32 Function(Pointer<Utf16> pPrinterName, Pointer<IntPtr> phPrinter, Pointer<Uint8> pDefault),
    int Function(Pointer<Utf16> pPrinterName, Pointer<IntPtr> phPrinter, Pointer<Uint8> pDefault)>('OpenPrinterW');

final getPrinter = winspool.lookupFunction<
    Int32 Function(IntPtr hPrinter, Uint32 level, Pointer<Uint8> pPrinter, Uint32 cbBuf, Pointer<Uint32> pcbNeeded),
    int Function(int hPrinter, int level, Pointer<Uint8> pPrinter, int cbBuf, Pointer<Uint32> pcbNeeded)>('GetPrinterW');

final closePrinter = winspool.lookupFunction<
    Int32 Function(IntPtr hPrinter),
    int Function(int hPrinter)>('ClosePrinter');
bool hasPower(String printerName) {
  final pPrinterName = printerName.toNativeUtf16();
  final hPrinter = calloc<IntPtr>();
  final pDefault = nullptr;

  final result = openPrinter(pPrinterName, hPrinter, pDefault);

  calloc.free(pPrinterName);

  if (result != 0) {
    final hPrinterValue = hPrinter.value;
    final pData = calloc<Uint8>(4096);
    final pcbNeeded = calloc<Uint32>();

    final res = getPrinter(hPrinterValue, 2, pData, 4096, pcbNeeded);

    if (res != 0) {
      final status = ByteData.sublistView(Uint8List.fromList(pData.asTypedList(pcbNeeded.value)));

      final statusFlags = status.getUint32(24, Endian.little); // Offset for Status field in PRINTER_INFO_2 struct

      closePrinter(hPrinterValue);
      calloc.free(hPrinter);
      calloc.free(pData);
      calloc.free(pcbNeeded);

      return (statusFlags & PRINTER_STATUS_POWER_SAVE) == 0 &&
          (statusFlags & PRINTER_STATUS_OFFLINE) == 0;
    }
  }

  return false;
}

bool hasPaper(String printerName) {
  final pPrinterName = printerName.toNativeUtf16();
  final hPrinter = calloc<IntPtr>();
  final pDefault = nullptr;

  final result = openPrinter(pPrinterName, hPrinter, pDefault);

  calloc.free(pPrinterName);

  if (result != 0) {
    final hPrinterValue = hPrinter.value;
    final pData = calloc<Uint8>(4096);
    final pcbNeeded = calloc<Uint32>();

    final res = getPrinter(hPrinterValue, 2, pData, 4096, pcbNeeded);

    if (res != 0) {
      final status = ByteData.sublistView(Uint8List.fromList(pData.asTypedList(pcbNeeded.value)));

      final statusFlags = status.getUint32(24, Endian.little); // Offset for Status field in PRINTER_INFO_2 struct

      closePrinter(hPrinterValue);
      calloc.free(hPrinter);
      calloc.free(pData);
      calloc.free(pcbNeeded);

      return (statusFlags & PRINTER_STATUS_PAPER_OUT) == 0;
    }
  }

  return false;
}



import 'package:canteen_kiosk_application/screens/institution_login.dart';
import 'package:canteen_kiosk_application/screens/splash_screen.dart';
import 'package:canteen_kiosk_application/widgets/check_printer_status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'constants/theme_constants.dart';
import 'controller/global_utility.dart';
import 'controller/theme_controller.dart';

class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
  
Logger logger =
    Logger(printer: PrettyPrinter(methodCount: 0), filter: MyFilter());
ThemeController themeData = Get.put(ThemeController());
Box? themeBox;
Box? logInBox;
Box? cookieBox;
Box? institutionalCode;
Box? institutionalCookie;
Box? importantIds;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  themeBox = await Hive.openBox("themeData");
  logInBox = await Hive.openBox("login");
  await Hive.openBox("cookie").then((value) => cookieBox = value);
  await Hive.openBox("institutionalCode").then((value) => institutionalCode = value);
  await Hive.openBox("insCookie").then((value) => institutionalCookie = value);
  importantIds = await Hive.openBox("commonCodes");
  if (themeBox!.get("isLightMode") != null) {
    themeData.isLightMode.value = themeBox!.get("isLightMode");
  } else {
    await themeBox!.put(
      "isLightMode",
      themeData.isLightMode.value,
    );
  }
  await SentryFlutter.init(
        (options) {
          options.dsn = 'https://e0176a30f5d5df771fb20d77320d197c@o4507424416202752.ingest.us.sentry.io/4507424417710081';
        },
    appRunner: () => runApp(const MyApp()),
  );
  await printIps();
  if (kReleaseMode) {
    await clearHiveDatabase();
  }
  _getRpc327Printer();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          darkTheme: CustomThemeData()
              .getThemeData(themeData.isLightMode.value, themeData.theme.value),
          theme: CustomThemeData()
              .getThemeData(themeData.isLightMode.value, themeData.theme.value),
          home: const SplashScreen(),
          builder: (context, child) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: child!);
          },
        ),
      );
    });
  }

}
Future<void> clearHiveDatabase() async {
  // Clear all Hive boxes
  await themeBox!.clear();
  await logInBox!.clear();
  await cookieBox!.clear();
  await institutionalCode!.clear();
  await institutionalCookie!.clear();
  await importantIds!.clear();
}
Future<Printer> _getRpc327Printer() async {
  final printers = await Printing.listPrinters();
  for (var element in printers) {
    logger.w(element);
    final hasPower1 =  hasPower(element.name);
    logger.i(hasPower1);
    if(hasPower1 == true){
      final hasPaper1 = hasPaper(element.name);
      _hasPaper = hasPaper1;
      logger.w(_hasPaper);
    }
  }
  return printers.first;
}
bool _hasPaper = false;

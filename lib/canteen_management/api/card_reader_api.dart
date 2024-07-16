
import 'package:canteen_kiosk_application/canteen_management/controller/canteen_controller.dart';
import 'package:canteen_kiosk_application/canteen_management/model/card_reader_model.dart';
import 'package:canteen_kiosk_application/constants/api_url.dart';
import 'package:canteen_kiosk_application/controller/global_utility.dart';
import 'package:canteen_kiosk_application/main.dart';
import 'package:dio/dio.dart';


Future<CardReaderModel?> cardReaderAPI(
    {required String base,
    required Map<String, dynamic> body,
    required CanteenManagementController controller}) async {
  var dio = Dio();
  var api = base + URLS.cardReader;
  logger.i(body);
  logger.i(api);
  var response =
      await dio.post(api, data: body, options: Options(headers: getSession()));
  CardReaderModel cardReaderModel =
      CardReaderModel.fromJson(response.data['getstudentdetails']);
  logger.w(response.data['getstudentdetails']);
  logger.i(response.data['getstudentdetails']);
  if (response.data['getstudentdetails'] != null) {
    controller.cardReaderList.clear();
    controller.cardReaderList.addAll(cardReaderModel.values!);
  }
  return cardReaderModel;
}

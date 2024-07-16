import 'package:canteen_kiosk_application/canteen_admin/model/counter_wise_food_model.dart';
import 'package:canteen_kiosk_application/canteen_management/model/counter_list_model.dart';
import 'package:canteen_kiosk_application/constants/api_url.dart';
import 'package:canteen_kiosk_application/controller/global_utility.dart';
import 'package:canteen_kiosk_application/main.dart';
import 'package:canteen_kiosk_application/screens/splash_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/canteen_controller.dart';
import '../model/bill_model.dart';
import '../model/food_category_model.dart';
import '../model/food_image_list_model.dart';
import '../model/generate_pin_model.dart';
import '../model/student_wallet_model.dart';
import '../model/transation_his_model.dart';

class CanteeenCategoryAPI {
  CanteeenCategoryAPI.init();

  static final CanteeenCategoryAPI instance = CanteeenCategoryAPI.init();

  Stream<List<FoodCategoryModelValues>> getCanteenItems({
    required CanteenManagementController canteenManagementController,
    required String base,
    required int miId,
    int? categoryId,
    required int counterId,
  }) async* {
    var dio = Dio();
    var url = base + URLS.categoryList;
    try {
      canteenManagementController.categoryLoading(true);
      var response = await dio.post(url,
          data: {"CMMCO_Id": counterId},
          options: Options(headers: getSession()));
      logger.d(url);
      logger.w({"CMMCO_Id": counterId});
      if (response.statusCode == 200) {
        if (await checkConnectivity()) {
          if (response.data['categeorylist'] != null) {
            FoodCategoryModel foodCategoryModel =
            FoodCategoryModel.fromJson(response.data['categeorylist']);
            // canteenManagementController.foodCategory(foodCategoryModel.values!);
            yield foodCategoryModel.values!;
          }

          // if(response.data['fooditeam'] != null){
          //   FoodListModel foodListModel =
          //   FoodListModel.fromJson(response.data['fooditeam']);
          //   canteenManagementController.foodData(foodListModel.values!);
          // }

          if (response.data['padamountdeatils'] != null) {
            StudentWalletModel studentWalletModel =
            StudentWalletModel.fromJson(response.data['padamountdeatils']);
            canteenManagementController.studentWalletData.clear();
            canteenManagementController.studentWalletData
                .addAll(studentWalletModel.values!);
          }
          if (response.data['studentpinlist'] != null) {
            GeneratePinModel foodListModel =
            GeneratePinModel.fromJson(response.data['studentpinlist']);
            canteenManagementController.pinlist.clear();
            canteenManagementController.pinlist.addAll(foodListModel.values!);
          }

          if (response.data['transactiondeatils'] != null) {
            TransationHistoryModel transationHistoryModel =
            TransationHistoryModel.fromJson(
                response.data['transactiondeatils']);
            canteenManagementController.transationHistory.clear();
            canteenManagementController.transationHistory
                .addAll(transationHistoryModel.values!);
          }
          if (response.data['counterlist'] != null) {
            CounterListModel counterListModel =
            CounterListModel.fromJson(response.data['counterlist']);
            canteenManagementController.counterList.clear();
            canteenManagementController.counterList
                .addAll(counterListModel.values!);
          }

          canteenManagementController.categoryLoading(false);
        } else {
          yield* Stream.error("Internet is not connected");
        }
      }
    } on Exception catch (e) {
      logger.e(e.toString());
      yield* Stream.error(e.toString());
    }
  }


   foodList(
      {required CanteenManagementController canteenManagementController,
      required String base,
      required int counterId,
      required int categoryId}) async {
    var dio = Dio();
    var url = base + URLS.counterWiseFoodList;
    logger.w(url);
    logger.v({"CMMCO_Id": counterId, "CMMCA_Id": categoryId});
    try {
      canteenManagementController.categoryLoading(true);
      var response = await dio.post(url,
          data: {"CMMCO_Id": counterId, "CMMCA_Id": categoryId},
          options: Options(headers: getSession()));
      if (response.statusCode == 200) {
        if (await checkConnectivity()) {
          if (response.data['counterFooditeamDeatils'] != null) {
            CounterWiseFoodModel foodListModel = CounterWiseFoodModel.fromJson(
                response.data['counterFooditeamDeatils']);
            canteenManagementController.foodData(foodListModel.values!);
          }
          canteenManagementController.categoryLoading(false);
        } else {
          Dialog(
            backgroundColor: Colors.transparent,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              content: Column(
                children: [
                  Text(
                    "InterNet is Not Connected",
                    style: Get.textTheme.titleSmall,
                  ),
                  TextButton(
                      onPressed: () {
                        Get.offAll(() => const SplashScreen());
                      },
                      child: Text(
                        "OK",
                        style: Get.textTheme.titleMedium!
                            .copyWith(color: Colors.blue),
                      ))
                ],
              ),
            ),
          );
        }
      }
    } on Exception catch (e) {
      logger.e(e.toString());
    }
  }

  studentTransationData({
    required CanteenManagementController canteenManagementController,
    required String base,
    required int miId,
    required int acmstId,
    required String flag,
  }) async {
    var dio = Dio();
    var url = base + URLS.transationHistory;
    try {
      canteenManagementController.historyLoading(true);
      var response = await dio.post(url,
          data: {"MI_Id": miId, "ACMST_Id": acmstId, "Flag": flag},
          options: Options(headers: getSession()));
      logger.d('==$url');
      logger.e({"MI_Id": miId, "ACMST_Id": acmstId, "Flag": flag});
      if (response.statusCode == 200) {
        if (response.data['transactiondeatils'] != null) {
          TransationHistoryModel transationHistoryModel =
              TransationHistoryModel.fromJson(
                  response.data['transactiondeatils']);
          canteenManagementController.transationHistory.clear();
          canteenManagementController.transationHistory
              .addAll(transationHistoryModel.values!);
          canteenManagementController.historyLoading(false);
        }
      }
    } on Exception catch (e) {
      logger.e(e.toString());
    }
  }

  Future<TransationBillModel?> transationHistory({
    required CanteenManagementController canteenManagementController,
    required String base,
    required int cmtransId,
    required String flag,
  }) async {
    var dio = Dio();
    var url = base + URLS.transactionPaymentHistory;
    try {
      var response = await dio.post(url,
          data: {"CMTRANS_Id": cmtransId, "Flag": flag},
          options: Options(headers: getSession()));
      logger.d(url);
      logger.e({"CMTRANS_Id": cmtransId, "Flag": flag});
        TransationBillModel transationBillModel =
        TransationBillModel.fromJson(response.data['payment_deatils']);
        canteenManagementController.billModel.clear();
        canteenManagementController.billModel.addAll(transationBillModel.values!);
        logger.w(canteenManagementController.billModel.length);
        canteenManagementController.quantity = 0;
        for (var i in transationBillModel.values!) {
          canteenManagementController.quantity += i.cMTRANSQty!;
        }
      return transationBillModel;
    } on DioException catch (e) {
      logger.e(e);
    } on Exception catch (e) {
      logger.e(e.toString());
    }
    return null;
  }
}

class CanteenItemApi {
  CanteenItemApi.init();

  static final CanteenItemApi ap = CanteenItemApi.init();

  foodImageList(
      {required CanteenManagementController canteenManagementController,
      required String base,
      required int cmmfiId}) async {
    var dio = Dio();
    var url = base + URLS.imageList;
    try {
      var response = await dio.post(url,
          data: {"CMMFI_Id": cmmfiId}, options: Options(headers: getSession()));
      if (response.statusCode == 200) {
        FoodImageListModel foodListModel =
            FoodImageListModel.fromJson(response.data['imageDetails']);
        canteenManagementController.foodImageList.clear();
        canteenManagementController.foodImageList.addAll(foodListModel.values!);
      }
    } on Exception catch (e) {
      logger.e(e.toString());
    }
  }
}

// class PinGenerateAPI {
//   PinGenerateAPI.init();
//
//   static final PinGenerateAPI instance = PinGenerateAPI.init();
//   var dio = Dio();

//   pinGenerateAPI(
//       {required String base,
//       required CanteenManagementController controller,
//       required Map<String, dynamic> data}) async {
//     var url = base + URLS.generatePin;
//     try {
//       var response = await dio.post(url,
//           data: data, options: Options(headers: getSession()));
//       logger.i(data);
//       logger.i(url);
//       if (response.statusCode == 200) {
//         if (response.data['returnval'] == 'save') {
//
//           Fluttertoast.showToast(msg: "Pin Generated Successfully");
//         } else {
//           Fluttertoast.showToast(msg: "Pin Already Exist");
//         }
//       }
//     } on Exception catch (e) {
//       logger.e(e.toString());
//     }
//   }
//
//   pinUpdateAPI(
//       {required String base,
//       required CanteenManagementController controller,
//       required Map<String, dynamic> data}) async {
//     var url = base + URLS.generatePin;
//     try {
//       var response = await dio.post(url,
//           data: data, options: Options(headers: getSession()));
//       logger.i(data);
//       logger.i(url);
//       if (response.statusCode == 200) {
//         if (response.data['returnval'] == 'update') {
//           Fluttertoast.showToast(msg: "Pin Update Successfully");
//         }
//       }
//     } on Exception catch (e) {
//       logger.e(e.toString());
//     }
//   }
//
//   resetPinAPI(
//       {required String base,
//       required CanteenManagementController controller,
//       required Map<String, dynamic> data}) async {
//     var url = base + URLS.forgotPin;
//     try {
//       var response = await dio.post(url,
//           data: data, options: Options(headers: getSession()));
//       logger.i(data);
//       logger.i(url);
//       if (response.statusCode == 200) {
//         if (response.data['returnval'] == 'Reset sucessfully') {
//           Fluttertoast.showToast(msg: "Pin Reset successfully");
//         }
//       }
//     } on Exception catch (e) {
//       logger.e(e.toString());
//     }
//   }
// }
//
// Future<bool?> forgotPinAPI(
//     {required String base,
//     required CanteenManagementController controller,
//     required Map<String, dynamic> data}) async {
//   var url = base + URLS.forgotPin;
//   var dio = Dio();
//   try {
//     var response = await dio.post(url,
//         data: data, options: Options(headers: getSession()));
//     logger.i(data);
//     logger.i(url);
//     if (response.statusCode == 200) {
//       if (response.data['returnval'] == 'Matched') {
//         controller.email = response.data['amst_emailid'];
//         Fluttertoast.showToast(msg: "Email Id  Matched Successfully");
//         return true;
//       } else {
//         return false;
//       }
//     }
//   } on Exception catch (e) {
//     logger.e(e.toString());
//   }
//   return null;
// }

Future<int?> deductAmount(
    {required String base,
    required CanteenManagementController controller,
    required Map<String, dynamic> data}) async {
  var api = base + URLS.deductAmountAPI;
  var dio = Dio();
  logger.i(data);
  logger.e(api);
  try {
    var response = await dio.post(api,
        data: data, options: Options(headers: getSession()));
    controller.transactionId = response.data['cmtranS_Id'];
    logger.d(controller.transactionId);
    return response.data['cmtranS_Id'];
  } on Exception catch (e) {
    logger.e(e.toString());
  }
  return 0;
}

Future<int?> cancelTransaction(
    {required String base, required Map<String, dynamic> body}) async {
  var dio = Dio();
  var api = base + URLS.cancelTransaction;
  logger.w(api);
  logger.e(body);
  try {
    var response = await dio.post(api,
        data: body, options: Options(headers: getSession()));
    return response.statusCode;
  } on Exception catch (e) {
    logger.e(e);
  }
  return 0;
}

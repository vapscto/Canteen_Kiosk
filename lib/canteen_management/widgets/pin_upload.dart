import 'package:canteen_kiosk_application/controller/mskool_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../widgets/m_skool_btn.dart';
import '../controller/canteen_controller.dart';

class PinFillWidget extends StatelessWidget {
  final CanteenManagementController controller;
  final MskoolController mskoolController;
  final String amount;
  final int miId;

  PinFillWidget(
      {super.key,
      required this.controller,
      // required this.loginSuccessModel,
      required this.mskoolController,
      required this.amount,
      required this.miId});

  final pinController = TextEditingController();

  final focusedBorderColor = const Color.fromRGBO(23, 171, 144, 1);

  final fillColor = const Color.fromRGBO(243, 246, 249, 0);

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: const Color.fromRGBO(23, 171, 144, 0.4)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      contentPadding: const EdgeInsets.all(10),
      content: SizedBox(
        width: Get.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Enter PIN",
              style: Get.textTheme.titleMedium!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 10),
            Pinput(
              controller: pinController,
              defaultPinTheme: defaultPinTheme,
              onChanged: (value) {},
              onCompleted: (pin) {},
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: TextButton(
                      onPressed: () {
                        Get.back();
                        // Get.dialog(ChangePinWidget(
                        //   controller: controller,
                        //   mskoolController: mskoolController,
                        //   loginSuccessModel: loginSuccessModel,
                        //   amount: amount,
                        // ));
                      },
                      child: Text(
                        "Change Pin",
                        style: Get.textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      )),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: TextButton(
                      onPressed: () {
                        Get.back();
                        // Get.dialog(ForgotPinWidget(
                        //   controller: controller,
                        //   mskoolController: mskoolController,
                        //   loginSuccessModel: loginSuccessModel,
                        //   amount: amount,
                        // ));
                      },
                      child: Text(
                        "Forgot Pin",
                        style: Get.textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(height: 10),
            MSkollBtn(
                title: "Proceed",
                onPress: () async {
                  // logger.v(controller.pinlist.first.amcstWWalletPIN);
                  // if (pinController.text.isEmpty) {
                  //   // Fluttertoast.showToast(msg: "Enter pin");
                  //   return;
                  // } else {
                  //   if (controller.pinlist.first.amcstWWalletPIN ==
                  //       pinController.text) {
                  //     await deductAmount(
                  //         base: baseUrlFromInsCode('canteen', mskoolController),
                  //         controller: controller,
                  //         data: {
                  //           "MI_Id": 0,
                  //           "AMST_Id": 0,
                  //           // "ASMAY_Id": loginSuccessModel.asmaYId,
                  //           "CMTRANS_Amount": amount,
                  //           "CMTransactionItems": controller.itemDetails,
                  //           "CMTransactionPaymentMode": [
                  //             {
                  //               "CMTRANSPM_PaymentModeId":
                  //                   controller.paymentMode,
                  //               "CMTRANSPM_PaymentMode": "PDA"
                  //             }
                  //           ]
                  //         }).then((value) async {
                  //       if (value == 200) {
                  //         Fluttertoast.showToast(
                  //             msg: "Amount Deducted Successfully");
                  //         // await CanteeenCategoryAPI.instance.getCanteenItems(
                  //         //   canteenManagementController: controller,
                  //         //   base: baseUrlFromInsCode('canteen',
                  //         //       mskoolController), //'https://ivrmstaging.vapssmartecampus.com:41040/',
                  //         //   miId: w.mIID!,
                  //         // );
                  //         controller.addToCartList.clear();
                  //
                  //         // Get.to(() => SuccessAnimation(
                  //         //       controller: controller,
                  //         //       mskoolController: mskoolController,
                  //         //       loginSuccessModel: loginSuccessModel,
                  //         //     ));
                  //       } else {
                  //         Fluttertoast.showToast(
                  //             msg: "Unable to Deduct Amount");
                  //       }
                  //     });
                  //   } else {
                  //     Fluttertoast.showToast(msg: "Pin does not Match ");
                  //   }
                  // }
                })
          ],
        ),
      ),
    );
  }
}

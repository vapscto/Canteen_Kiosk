import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/mskool_controller.dart';
import '../../model/login_success_model.dart';
import '../../widgets/m_skool_btn.dart';
import '../controller/canteen_controller.dart';

class ForgotPinWidget extends StatelessWidget {
  final CanteenManagementController controller;
  final LoginSuccessModel loginSuccessModel;
  final MskoolController mskoolController;
  final String amount;

  const ForgotPinWidget(
      {super.key,
      required this.controller,
      required this.loginSuccessModel,
      required this.mskoolController,
      required this.amount});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
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
              TextFormField(
                controller: emailController,
                style: Get.textTheme.titleSmall,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: 'Email Id',
                    hintStyle:
                        Get.textTheme.titleSmall!.copyWith(color: Colors.grey),
                    labelText: "Email Id",
                    labelStyle: Get.textTheme.titleSmall,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey))),
              ),
              const SizedBox(height: 10),
              MSkollBtn(
                  title: "Proceed",
                  onPress: () async {
                    // if (emailController.text.isEmpty) {
                    //   Fluttertoast.showToast(msg: "Enter Register Email Id");
                    //   return;
                    // } else {
                    //   await forgotPinAPI(
                    //           base: baseUrlFromInsCode(
                    //               'canteen', mskoolController),
                    //           // 'https://ivrmstaging.vapssmartecampus.com:41040/',
                    //           data: {
                    //             "MI_Id": loginSuccessModel.mIID,
                    //             "AMST_Id": loginSuccessModel.amsTId,
                    //             "AMCSTW_Id": controller.pinlist.first.amcstWId,
                    //             "amst_emailid": emailController.text,
                    //             "message": "Match"
                    //           },
                    //           controller: controller)
                    //       .then((value) {
                    //     if (value == true) {
                    //       Get.back();
                    //       Get.dialog(ResetPinWidget(
                    //         controller: controller,
                    //         loginSuccessModel: loginSuccessModel,
                    //         mskoolController: mskoolController,
                    //         amount: amount,
                    //       ));
                    //     } else {
                    //       Fluttertoast.showToast(msg: "Email is not Matched");
                    //       return;
                    //     }
                    //   });
                    // }
                  })
            ],
          ),
        ));
  }
}

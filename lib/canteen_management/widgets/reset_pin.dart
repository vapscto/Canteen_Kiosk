import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controller/mskool_controller.dart';
import '../../model/login_success_model.dart';
import '../../widgets/m_skool_btn.dart';
import '../controller/canteen_controller.dart';

class ResetPinWidget extends StatefulWidget {
  final LoginSuccessModel loginSuccessModel;
  final MskoolController mskoolController;
  final CanteenManagementController controller;
  final String amount;

  const ResetPinWidget(
      {super.key,
      required this.loginSuccessModel,
      required this.mskoolController,
      required this.controller,
      required this.amount});

  @override
  State<ResetPinWidget> createState() => _ResetPinWidgetState();
}

class _ResetPinWidgetState extends State<ResetPinWidget> {
  final key = GlobalKey<FormState>();
  final pinController = TextEditingController();
  final confPinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.all(8),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Reset Pin",
                style: Get.textTheme.titleMedium!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: pinController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter pin';
                  } else if (value.length < 4) {
                    return 'Pin should be 4 degit';
                  }
                  return null;
                },
                style: Get.textTheme.titleSmall,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  LengthLimitingTextInputFormatter(4),
                ],
                decoration: InputDecoration(
                    hintText: "Enter pin",
                    hintStyle:
                        Get.textTheme.titleSmall!.copyWith(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red),
                    )),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: confPinController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter pin';
                  } else if (pinController.text != value) {
                    return 'Pin does not match';
                  }
                  return null;
                },
                style: Get.textTheme.titleSmall,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  LengthLimitingTextInputFormatter(4),
                ],
                decoration: InputDecoration(
                    hintText: "Enter Confirm pin",
                    hintStyle:
                        Get.textTheme.titleSmall!.copyWith(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red),
                    )),
              ),
              const SizedBox(height: 10),
              Obx(() {
                return (widget.controller.isPinGenerate.value)
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      )
                    : MSkollBtn(
                        title: "Generate",
                        onPress: () async {
                          // if (key.currentState!.validate()) {
                          //   widget.controller.generatePin(true);
                          //   await PinGenerateAPI.instance.resetPinAPI(
                          //       base: baseUrlFromInsCode(
                          //           'canteen', widget.mskoolController),
                          //       // 'https://ivrmstaging.vapssmartecampus.com:41040/',
                          //       controller: widget.controller,
                          //       data: {
                          //         "MI_Id": widget.loginSuccessModel.mIID,
                          //         "AMST_Id": widget.loginSuccessModel.amsTId,
                          //         "AMCSTW_Id":
                          //             widget.controller.pinlist.first.amcstWId,
                          //         "amst_emailid": widget.controller.email,
                          //         "message": "sucess",
                          //         "AMCSTW_WalletPIN": pinController.text
                          //       });
                          //   widget.controller.generatePin(false);
                          //   await CanteeenCategoryAPI.instance.getCanteenItems(
                          //     canteenManagementController: widget.controller,
                          //     base: baseUrlFromInsCode(
                          //         'canteen', widget.mskoolController),
                          //     //'https://ivrmstaging.vapssmartecampus.com:41040/',
                          //     miId: widget.loginSuccessModel.mIID!,
                          //   );
                          //   Get.back();
                          //   // Get.dialog(PinFillWidget(
                          //   //   loginSuccessModel: widget.loginSuccessModel,
                          //   //   mskoolController: widget.mskoolController,
                          //   //   controller: widget.controller,
                          //   //   amount: widget.amount,
                          //   // ));
                          // }
                        });
              })
            ],
          ),
        ),
      ),
    );
  }
}

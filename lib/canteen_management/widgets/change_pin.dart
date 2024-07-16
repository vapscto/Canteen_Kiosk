import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controller/global_utility.dart';
import '../../controller/mskool_controller.dart';
import '../../model/login_success_model.dart';
import '../../widgets/m_skool_btn.dart';
import '../api/item_list_api.dart';
import '../controller/canteen_controller.dart';

class ChangePinWidget extends StatefulWidget {
  final LoginSuccessModel loginSuccessModel;
  final MskoolController mskoolController;
  final CanteenManagementController controller;
  final String amount;

  const ChangePinWidget(
      {super.key,
      required this.loginSuccessModel,
      required this.mskoolController,
      required this.controller,
      required this.amount});

  @override
  State<ChangePinWidget> createState() => _ChangePinWidgetState();
}

class _ChangePinWidgetState extends State<ChangePinWidget> {
  final key = GlobalKey<FormState>();
  final pinController = TextEditingController();
  final oldPinController = TextEditingController();
  final confPinController = TextEditingController();

  _changePin() async {
    widget.controller.updatePin(true);
    // await PinGenerateAPI.instance.pinUpdateAPI(
    //     base: baseUrlFromInsCode('canteen', widget.mskoolController),
    //     //'https://ivrmstaging.vapssmartecampus.com:41040/',
    //     controller: widget.controller,
    //     data: {
    //       "MI_Id": widget.loginSuccessModel.mIID,
    //       "AMST_Id": widget.loginSuccessModel.amsTId,
    //       "AMCSTW_Id": widget.controller.pinlist.first.amcstWId,
    //       "AMCSTW_WalletPIN": pinController.text
    //     });
    widget.controller.updatePin(false);
    await CanteeenCategoryAPI.instance.getCanteenItems(
      canteenManagementController: widget.controller,
      base: baseUrlFromInsCode('canteen', widget.mskoolController),
      miId: widget.loginSuccessModel.mIID!, categoryId: 0, counterId: 0,
    );
  }

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
                "Change Pin",
                style: Get.textTheme.titleMedium!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: oldPinController,
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
                    hintText: "Enter Old pin",
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
                controller: pinController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter New pin';
                  } else if (value.length < 4) {
                    return 'Pin should be 4 degit';
                  } else if (oldPinController.text == value) {
                    return 'New pin must be different from old pin';
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
                    hintText: "Enter New pin",
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
                return (widget.controller.isPinUpdate.value)
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      )
                    : MSkollBtn(
                        title: "Save",
                        onPress: () {
                          if (key.currentState!.validate()) {
                            _changePin();
                            Get.back();
                            // Get.dialog(
                            //     PinFillWidget(
                            //       loginSuccessModel: widget.loginSuccessModel,
                            //       mskoolController: widget.mskoolController,
                            //       controller: widget.controller,
                            //       amount: widget.amount,
                            //     ),
                            //     barrierDismissible: false);
                          }
                        });
              })
            ],
          ),
        ),
      ),
    );
  }
}

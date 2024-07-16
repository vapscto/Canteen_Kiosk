import 'package:canteen_kiosk_application/canteen_admin/widgets/log_out_widget.dart';
import 'package:canteen_kiosk_application/canteen_management/api/item_list_api.dart';
import 'package:canteen_kiosk_application/canteen_management/controller/canteen_controller.dart';
import 'package:canteen_kiosk_application/constants/api_url.dart';
import 'package:canteen_kiosk_application/controller/global_utility.dart';
import 'package:canteen_kiosk_application/controller/mskool_controller.dart';
import 'package:canteen_kiosk_application/main.dart';
import 'package:canteen_kiosk_application/model/login_success_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/fade_in.dart';

class CategoryWidget extends StatefulWidget {
  final CanteenManagementController canteenManagementController;
  final MskoolController mskoolController;
  final LoginSuccessModel loginSuccessModel;

  const CategoryWidget(
      {super.key,
      required this.canteenManagementController,
      required this.mskoolController,
      required this.loginSuccessModel});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CanteeenCategoryAPI.instance.getCanteenItems(
        canteenManagementController: widget.canteenManagementController,
        base: baseUrlFromInsCode('canteen', widget.mskoolController),
        miId: importantIds!.get(URLS.miId),
        counterId: counterId,
      ),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(2, 2.1),
                  spreadRadius: 0,
                  blurRadius: 0,
                  color: Colors.black12,
                ),
              ],
            ),
            child: Obx(() {
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Select Category",
                      style: Get.textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  ...List.generate(
                    snapshot.data.length,
                    (index) {
                      return FadeInAnimation(
                        delay: 1.0,
                        direction: FadeInDirection.ttb,
                        fadeOffset: index == 0 ? 100 : 100.0 + index,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: ListTile(
                            title: Text(
                              widget
                                      .canteenManagementController
                                      .foodCategoryList[index]
                                      .cmmcACategoryName ??
                                  "",
                              style: Get.textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.w600,
                                color:
                                    (categoryId == snapshot.data[index].cmmcAId)
                                        ? Colors.green
                                        : Colors.black,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                categoryId = snapshot.data[index].cmmcAId ?? 0;
                                // foodList(categoryId);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  (categoryId == 0)
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                categoryId = 0;
                                // foodList(0);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 202, 202),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(2, 2.1),
                                    spreadRadius: 0,
                                    blurRadius: 0,
                                    color: Colors.black12,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  "Clear Filter",
                                  style: Get.textTheme.titleSmall!.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          Get.dialog(const LogoutConfirmationPopup());
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 202, 202),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(2, 2.1),
                              spreadRadius: 0,
                              blurRadius: 0,
                              color: Colors.black12,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            "Log Out",
                            style: Get.textTheme.titleSmall!.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          );
        }
        if (snapshot.hasError) {
          Text(snapshot.error.toString());
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  int categoryId = 0;
}

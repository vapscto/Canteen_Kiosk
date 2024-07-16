import 'package:canteen_kiosk_application/canteen_admin/admin_api/admin_api.dart';
import 'package:canteen_kiosk_application/canteen_admin/model/counter_wise_food_model.dart';
import 'package:canteen_kiosk_application/canteen_admin/widgets/log_out_widget.dart';
import 'package:canteen_kiosk_application/canteen_management/api/card_reader_api.dart';
import 'package:canteen_kiosk_application/canteen_management/screens/quick_search_kot.dart';
import 'package:canteen_kiosk_application/canteen_management/screens/quick_search_pdf.dart';
import 'package:canteen_kiosk_application/canteen_management/screens/select_theme.dart';
import 'package:canteen_kiosk_application/canteen_management/widgets/item_list_widgets.dart';
import 'package:canteen_kiosk_application/constants/api_url.dart';
import 'package:canteen_kiosk_application/main.dart';
import 'package:canteen_kiosk_application/widgets/animated_progress.dart';
import 'package:canteen_kiosk_application/widgets/fade_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../canteen_admin/admin_controller/admin_controller.dart';
import '../../controller/global_utility.dart';
import '../../controller/mskool_controller.dart';
import '../../widgets/m_skool_btn.dart';
import '../api/item_list_api.dart';
import '../controller/canteen_controller.dart';
import '../model/food_category_model.dart';
import 'canteen_bill_pay.dart';

class CanteenHomeScreen extends StatefulWidget {
  final MskoolController mskoolController;

  const CanteenHomeScreen({
    super.key,
    required this.mskoolController,
  });

  @override
  State<CanteenHomeScreen> createState() => _CanteenHomeScreenState();
}

class _CanteenHomeScreenState extends State<CanteenHomeScreen> {
  @override
  void initState() {
    // _category(0);
    foodList(0);

    super.initState();
  }

  List itemType = ['VEG', 'NON-VEG'];
  CanteenManagementController canteenManagementController =
      Get.put(CanteenManagementController());

  foodList(int id) async {
  await  CanteeenCategoryAPI.instance.foodList(
        canteenManagementController: canteenManagementController,
        base: baseUrlFromInsCode('canteen', widget.mskoolController),
        counterId: counterId,
        categoryId: id);

    foodListFilter.value = canteenManagementController.foodList;

  }

  int categoryId = 0;

  _category(int id) async {
    setState(() {
      canteenManagementController.isCategoryLoading.value = true;
    });
    CanteeenCategoryAPI.instance.getCanteenItems(
      canteenManagementController: canteenManagementController,
      base: baseUrlFromInsCode('canteen', widget.mskoolController),
      miId: importantIds!.get(URLS.miId),
      counterId: counterId,
    );
    await foodList(0);
    setState(() {
      canteenManagementController.isCategoryLoading.value = false;
    });
  }

  String name = '';
  final searchController = TextEditingController();
  final quickSearchController = TextEditingController();
  RxList<CounterWiseFoodModelValues> foodListFilter =
      <CounterWiseFoodModelValues>[].obs;
  int bgColor = -1;

  @override
  void dispose() {
    super.dispose();
  }

  AdminController controller = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Canteen Management",
                style: Get.textTheme.titleMedium!.copyWith(color: Colors.white),
              ),
              const SizedBox(width: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.2,
                child: TextField(
                  controller: quickSearchController,
                  style: Get.textTheme.titleSmall,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(5),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white)),
                      hintText: 'Search Order ID...',
                      hintStyle: Get.textTheme.titleSmall!
                          .copyWith(color: Colors.grey),
                      suffixIcon: (quickSearchController.text.isNotEmpty)
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  quickSearchController.clear();
                                });
                              },
                              icon: Icon(
                                Icons.close,
                                color: Theme.of(context).primaryColor,
                                size: 30,
                              ))
                          : const SizedBox()),
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: () async {
                  if (quickSearchController.text.isEmpty) {
                    toastMessage("Enter OrderId", context, Colors.red);
                    return;
                  } else {
                    await quickSearch(
                            base: baseUrlFromInsCode(
                                'canteen', widget.mskoolController),
                            orderId: int.parse(searchController.text.trim()),
                            controller: controller,
                            flag: 'overall')
                        .then((value) async {
                      if (value!.values!.isNotEmpty) {
                        await QuickSearchPdf.i.generateNow(
                            controller: controller,
                            mskoolController: widget.mskoolController,
                            date: DateTime.now().toIso8601String());
                        await QuickSearchKotPrint.instance.quickSearch(
                            controller: controller,
                            mskoolController: widget.mskoolController,
                            date: DateTime.now().toIso8601String());
                        searchController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            elevation: 2,
                            content: Text(
                              "Already been printed or check Order Id",
                              style: Get.textTheme.titleSmall!
                                  .copyWith(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                      setState(() {});
                    });
                  }
                },
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.08,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(2, 2.1),
                              blurRadius: 0,
                              spreadRadius: 0,
                              color: Colors.black12)
                        ]),
                    child: Center(
                      child: Text(
                        "Print",
                        style: Get.textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          centerTitle: false,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          _sortList(value);
                        });
                      },
                      style: Get.textTheme.titleSmall,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white)),
                        hintText: 'Search...',
                        hintStyle: Get.textTheme.titleSmall!
                            .copyWith(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                      onTap: () async {
                        if (canteenManagementController
                            .cardReaderList.isNotEmpty) {
                          await cancelTransaction(
                              base: baseUrlFromInsCode(
                                  'canteen', widget.mskoolController),
                              body: {
                                "MI_Id": miId,
                                "AMST_Id": canteenManagementController
                                    .cardReaderList.last.aMSTId,
                                "Flag": canteenManagementController.selectedType
                                    .toLowerCase(),
                              }).then((value) {
                            if (value == 200) {
                              setState(() {
                                canteenManagementController.item = 'All';
                                canteenManagementController.addToCartList
                                    .clear();
                                categoryId = 0;
                                _category(0);
                                foodList(0);
                                searchController.clear();
                              });
                            }
                          });
                        } else {
                          setState(() {
                            canteenManagementController.item = 'All';
                            canteenManagementController.addToCartList.clear();
                            categoryId = 0;
                            _category(0);
                            foodList(0);
                            searchController.clear();
                          });
                        }
                      },
                      child: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      )),
                  const SizedBox(width: 10),
                  IconButton(
                      onPressed: () {
                        Get.to(() => const ThemeSwitcher());
                      },
                      icon: const Icon(
                        Icons.palette,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
          ]),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.15,
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder(
                stream: CanteeenCategoryAPI.instance.getCanteenItems(
                  canteenManagementController: canteenManagementController,
                  base: baseUrlFromInsCode('canteen', widget.mskoolController),
                  miId: importantIds!.get(URLS.miId),
                  counterId: counterId,
                ),
                builder: (BuildContext context,
                    AsyncSnapshot<List<FoodCategoryModelValues>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available'));
                  } else {
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
                      child: ListView(
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
                          ...List.generate(snapshot.data!.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: ListTile(
                                title: Text(
                                  snapshot.data![index].cmmcACategoryName!,
                                  style: Get.textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: (categoryId ==
                                            snapshot.data![index].cmmcAId)
                                        ? Colors.green
                                        : Colors.black,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    categoryId = snapshot.data![index].cmmcAId!;
                                    foodList(categoryId);
                                  });
                                },
                              ),
                            );
                          }),
                          const SizedBox(height: 20),
                          if (categoryId != 0)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    categoryId = 0;
                                    foodList(0);
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 255, 202, 202),
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
                                  color:
                                      const Color.fromARGB(255, 255, 202, 202),
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
                      ),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: Obx(() {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      foodListFilter.isNotEmpty
                          ? LayoutBuilder(
                              builder: (context, BoxConstraints constraints) {
                                return GridView.builder(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: foodListFilter.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: _calculateCrossAxisCount(
                                        constraints.maxWidth),
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 0.87,
                                  ),
                                  itemBuilder: (context, index) {
                                    return FadeInAnimation(
                                      delay: 1.0,
                                      direction: FadeInDirection.ltr,
                                      fadeOffset:
                                          index == 0 ? 80 : 80.0 * index,
                                      child: ItemListWidget(
                                        canteenManagementController:
                                            canteenManagementController,
                                        values: foodListFilter[index],
                                        mskoolController:
                                            widget.mskoolController,
                                        foodId:
                                            foodListFilter[index].cmmfIId ?? 0,
                                      ),
                                    );
                                  },
                                );
                              },
                            )
                          : const Center(
                              child: AnimatedProgressWidget(
                                title: "Data is not available",
                                desc: "Food list is not available",
                                animationPath: "assets/json/nodata.json",
                                animatorHeight: 350,
                              ),
                            ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(() {
        return (canteenManagementController.addToCartList.isNotEmpty)
            ? FadeInAnimation(
                delay: 2.0,
                direction: FadeInDirection.ltr,
                fadeOffset: 80,
                child: MSkollBtn(
                    title:
                        "Place Order ${canteenManagementController.addToCartList.length}",
                    onPress: () async {
                      await cardReaderAPI(
                              base: baseUrlFromInsCode(
                                  'canteen', widget.mskoolController),
                              body: {
                                "AMCTST_IP": ipAddress,
                              },
                              controller: canteenManagementController)
                          .then((value) {
                        if (value!.values!.isEmpty) {
                          toastMessage(
                              'Scan your smart Card', context, Colors.red);
                          return;
                        } else {
                          setState(() {
                            miId = canteenManagementController
                                .cardReaderList.last.mIId!;
                            staffStudentFlag = canteenManagementController
                                .cardReaderList.last.flag!
                                .toLowerCase();
                            Get.to(() => CanteenBillPay(
                                  data:
                                      canteenManagementController.addToCartList,
                                  controller: canteenManagementController,
                                  mskoolController: widget.mskoolController,
                                  miId: 0,
                                ));
                          });
                        }
                      });
                    }),
              )
            : const SizedBox();
      }),
    );
  }

  _sortList(String data) {
    if (data.isEmpty) {
      foodListFilter.value = canteenManagementController.foodList;
    } else {
      foodListFilter.value =
          canteenManagementController.foodList.where((value) {
        return value.cmmfIFoodItemName!
            .toLowerCase()
            .contains(data.toLowerCase());
      }).toList();
    }
    setState(() {});
  }

  int _calculateCrossAxisCount(double width) {
    return (width / 250).floor();
  }
}

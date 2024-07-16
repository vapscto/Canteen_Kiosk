import 'dart:async';

import 'package:canteen_kiosk_application/api/institution_code_api.dart';
import 'package:canteen_kiosk_application/api/login_api.dart';
import 'package:canteen_kiosk_application/constants/api_url.dart';
import 'package:canteen_kiosk_application/controller/global_utility.dart';
import 'package:canteen_kiosk_application/controller/mskool_controller.dart';
import 'package:canteen_kiosk_application/forgotpassword/screens/change_expired_password.dart';
import 'package:canteen_kiosk_application/main.dart';
import 'package:canteen_kiosk_application/model/category_item_model.dart';
import 'package:canteen_kiosk_application/model/institution_data_model.dart';
import 'package:canteen_kiosk_application/model/login_success_model.dart';
import 'package:canteen_kiosk_application/screens/login_screen.dart';
import 'package:canteen_kiosk_application/widgets/m_skool_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:platform_device_id_v3/platform_device_id.dart';

import '../canteen_management/screens/canteen_management_home_screen.dart';
import 'institution_login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: FutureBuilder<Widget>(
            future: handleAuth(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!;
              }
              if (snapshot.hasError) {
                dynamic err = snapshot.error;
                if (err is Map<String, dynamic> &&
                    err.containsKey('type')  &&
                    err['type'] == "exp" ) {
                  return Center(
                    child: Container(
                        margin: const EdgeInsets.all(24.0),
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Remainder",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 20.0,
                              ),
                            ),
                            SvgPicture.asset(
                              "assets/svg/remainder.svg",
                              height: 100,
                            ),
                            const Text(
                                "Your password is expired!\nReset password now "),
                            const SizedBox(
                              height: 12.0,
                            ),
                            MSkollBtn(
                              onPress: () {
                                final MskoolController mskoolController =
                                Get.find<MskoolController>();
                                Get.offAll(ResetExpiredPassword(
                                  fromSplash: "yes",
                                  base: baseUrlFromInsCode(
                                      "login", mskoolController),
                                  userName: err['userName'],
                                  mskoolController: mskoolController,
                                ));
                              },
                              title: 'Update Password',
                            ),
                          ],
                        )),
                  );

                }
                return Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text(
                        //   err['errorTitle'],
                        //   textAlign: TextAlign.center,
                        //   style: Theme.of(context).textTheme.titleMedium!.merge(
                        //     const TextStyle(
                        //         fontSize: 20.0, color: Colors.white),
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 12.0,
                        // ),
                        Text(
                          err.toString(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelMedium!.merge(
                            const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              "assets/images/app_icon.png",
                              fit: BoxFit.fill,
                            )),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Canteen Kiosk",
                        style: Get.textTheme.titleMedium!.copyWith(color: Colors.white),
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
  Future<Widget> handleAuth() async {
    try {
      if (institutionalCode!.get("institutionalCode") == null) {
        return Future.value(
          const InstitutionLogin(),
        );
      }
      final InstitutionalCodeModel codeModel = await InstitutionalCodeApi
          .instance
          .loginWithInsCode(institutionalCode!.get("institutionalCode"), true);
      final MskoolController mskoolController = Get.put(MskoolController());
      mskoolController.updateUniversalInsCodeModel(codeModel);
      if (logInBox!.get("isLoggedIn") == null || !logInBox!.get("isLoggedIn")) {
        return Future.value(LoginScreen(
          mskoolController: mskoolController,
        ));
      }
      String userName = logInBox!.get("userName");
      String password = logInBox!.get("password");
      int miId = importantIds!.get(URLS.miId);
      String loginBaseUrl = "";
      for (int i = 0; i < codeModel.apiarray.values.length; i++) {
        final CategoriesApiItem apiItem =
            codeModel.apiarray.values.elementAt(i);
        if (apiItem.iivrscurLAPIName.toLowerCase() == "login") {
          loginBaseUrl = apiItem.iivrscurLAPIURL;
        }
      }
      var deviceToken = (await PlatformDeviceId.getDeviceId)!;
      final LoginSuccessModel loginSuccessModel = await AuthenticateUserApi
          .instance
          .authenticateNow(userName, password, miId, loginBaseUrl, deviceToken);
      mskoolController.updateLoginSuccessModel(loginSuccessModel);
      counterId = loginSuccessModel.counterNameModel!.values!.first.cMMCOId!;

      return Future.value(CanteenHomeScreen(
          mskoolController: mskoolController,));
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Future.error(
        {
          "errorTitle": "Something went wrong",
          "errorMsg":
              "An error occurred in server side, may be currently it is down or page is not available."
        },
      );
    }
  }
}

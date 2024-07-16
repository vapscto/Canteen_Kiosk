import 'package:canteen_kiosk_application/controller/mskool_controller.dart';
import 'package:canteen_kiosk_application/main.dart';
import 'package:canteen_kiosk_application/model/login_success_model.dart';
import 'package:flutter/material.dart';


class CommonFile extends StatefulWidget {
  final LoginSuccessModel loginSuccessModel;
  final MskoolController mskoolController;
  final int miId;
  const CommonFile(
      {super.key,
      required this.loginSuccessModel,
      required this.mskoolController,
      required this.miId});
  @override
  State<CommonFile> createState() => _CommonFileState();
}

class _CommonFileState extends State<CommonFile> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      logInBox!.put("isLoggedIn", true);
      if (widget.loginSuccessModel.roleforlogin!.toLowerCase() == 'admin') {
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (_) => CanteenAdminHome(
        //           mskoolController: widget.mskoolController,
        //           miId: widget.miId,
        //           loginSuccessModel: widget.loginSuccessModel,
        //         )));
      } else {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (_) => CanteenAdminHome(
        //         mskoolController: widget.mskoolController,
        //         miId: widget.miId,
        //         loginSuccessModel: widget.loginSuccessModel,
        //       )));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

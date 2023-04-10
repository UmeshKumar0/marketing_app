import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/models/user_model.dart';

class CloudController extends GetxController {
  RxBool alive = false.obs;
  RxBool attendanceSyncing = false.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late ApiController _apiController;
  RxString syncMessage = "IDLE".obs;
  ApiController get apiController => _apiController;
  List<Function> functions = [];

  @override
  void onInit() {
    super.onInit();

    print('initilizing cloud controller');

    _apiController = Get.find<ApiController>();
    checkConnection();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        if (result == ConnectivityResult.none) {
          alive.value = false;
          syncMessage.value = "NO INTERNET";
        } else {
          alive.value = true;
          sync();
        }
      },
    );
  }

  checkConnection() async {
    var result = await _connectivity.checkConnectivity();

    if (result == ConnectivityResult.none) {
      alive.value = false;
      syncMessage.value = "NO INTERNET";
    } else {
      alive.value = true;
      syncMessage.value = "IDLE";
    }
  }

  sync() async {
    try {
      if (syncMessage.value != "SYNCING..") {
        syncMessage.value = "SYNCING..";
        UserModel? userModel = await _apiController.userProfile();
        if (userModel != null && userModel.token != null) {
          await _apiController.gettodayattendancestatus(alive: true);
          await _apiController.getProductsAndBrand(product: true);
          await _apiController.getProductsAndBrand(product: false);
          await _apiController.getUserNotification(online: true);
          await _apiController.loadAllShop();

          /* 

           uncomment this if you want to sync all data on home screen
           await _apiController.getPersonalShops();
          await _apiController.getAttendance(
             month: DateTime.now().month.toString(),
             year: DateTime.now().year.toString(),
             online: true,
           );
           await _apiController.getTypes(online: true);
           await _apiController.getTeams(online: true);
          
          */

        }
        syncMessage.value = "IDLE";
      } else {
        Fluttertoast.showToast(
            msg: 'Already syncing in background, please wait ');
      }
    } catch (e) {
      syncMessage.value = "ERROR";
      if (e.toString() == 'TOKEN_EXPIRE') {
        // Get.dialog(
        //   AlertDialog(
        //     title: Text(
        //       'Token Expire',
        //       style: GoogleFonts.firaSans(
        //         color: Colors.black,
        //       ),
        //     ),
        //     content: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Container(
        //           alignment: Alignment.center,
        //           child: Text(
        //             'You token is expire please login again',
        //             style: GoogleFonts.firaSans(
        //               color: Colors.black,
        //             ),
        //           ),
        //         )
        //       ],
        //     ),
        //     actions: [
        //       ElevatedButton(
        //         onPressed: () async {
        //           Get.offAllNamed(AppConfig.LOGIN_ROUTE);
        //         },
        //         child: Text(
        //           'Login Again',
        //           style: GoogleFonts.firaSans(
        //             color: Colors.white,
        //           ),
        //         ),
        //       )
        //     ],
        //   ),
        // );
      } else {
        Get.dialog(
          AlertDialog(
            title: Text(
              "Sync Error",
              style: GoogleFonts.firaSans(
                color: Colors.black,
              ),
            ),
            content: Text(e.toString()),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("Retry", style: GoogleFonts.firaSans()),
              ),
            ],
          ),
        );
      }
      syncMessage.value = e.toString();
    }
  }

  @override
  void onClose() {
    super.onClose();
    _connectivitySubscription.cancel();
  }
}

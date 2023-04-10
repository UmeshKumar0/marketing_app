import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/PermissionManager.dart';
import 'package:marketing/src/admin/screens/admin_home.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/settings_controller.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:marketing/src/user/models/Sim.dart';
import 'package:marketing/src/user/models/deviceInfo.dart';
import 'package:marketing/src/user/models/user_model.dart';
import 'package:marketing/src/user/screens/validation/views/ValidationView.dart';

class SplashController extends GetxController {
  late StorageController _storageController;
  late ApiController _apiController;
  late SettingController _settingController;
  late CloudController _cloudController;
  PermissionManager permissionManager = PermissionManager();
  @override
  void onInit() {
    super.onInit();
    _apiController = Get.find<ApiController>();
    _storageController = Get.find<StorageController>();
    _settingController = Get.find<SettingController>();
    _cloudController = Get.find<CloudController>();
  }

  sendToServer(String? token, String? userId) async {
    if (userId != null) {
      MyDeviceInfo? deviceInfo = await _storageController.getMyDeviceInfo();
      deviceInfo!.userId = userId;
      if (deviceInfo != null) {
        print('seeting up device token and info to server');
        await _apiController.registerDevice(myDeviceInfo: deviceInfo);
      }
    }
  }

  Future<UserModel?> checktoken() async {
    try {
      UserModel? userModel = await _storageController.getToken();
      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  Future validatetoken({required UserModel userModel}) async {
    try {
      final Connectivity connectivity = Connectivity();
      ConnectivityResult status = await connectivity.checkConnectivity();
      if (status == ConnectivityResult.none) {
        /* 
          check sim card details and match it with authorized sim card details which is stored in local hive database
          if(condition is true){
            Get.offAndToNamed(AppConfig.HOME_ROUTE);
          }else{
            throw HttpException('Sim Change Detected please reverify your sim card and account');
          }


        */

        String status = await _storageController.getOdometerStatus();
        if (status == AppConfig.COMPLETE) {
          if (!(await FlutterBackgroundService().isRunning())) {
            if (kDebugMode) {
              print(
                  "++++++++++++++++++++=========++++++++++++++++++++++==========++++++++++");
            }
            FlutterBackgroundService().invoke('stopService', {"status": true});
          }
        }

        if (kDebugMode) {
          Get.offAndToNamed(AppConfig.HOME_ROUTE);
          return;
        }

        /* Getting sim card list from native channel */
        List<Sim> simList = await permissionManager.getSimNumbers();
        List<String> ids = [];

        /* Checking if sim card list is empty */
        if (simList.isEmpty) {
          /* If sim card list is empty then throw exception */
          throw HttpException('No Sim Card Detected');
        } else {
          for (var element in simList) {
            ids.add("${element.slot}@${element.subsId}@${element.number}");
          }
          String sim = await _storageController.getAuthorizedSim();
          if (sim == "0") {
            Fluttertoast.showToast(msg: 'No Authorized Sim Card Found');
            Get.offAndToNamed(ValidationViews.routeName);
          } else {
            if (ids.contains(sim)) {
              if (userModel.user!.role == 'ADMIN') {
                throw HttpException(
                    'You are logged in as a admin. No internet connection , please connect to internet for continue as admin');
              } else {
                await _apiController.gettodayattendancestatus(
                  alive: false,
                );
                Get.offAndToNamed(AppConfig.HOME_ROUTE);
              }
            } else {
              Fluttertoast.showToast(
                  msg:
                      'Sim Change Detected please reverify your sim card and account');
              Get.offAndToNamed(ValidationViews.routeName);
            }
          }
        }
      } else {
        User user = await _apiController.userprofile();
        await _storageController.setUsermodel(
          userModel: UserModel(
            user: user,
            token: userModel.token,
          ),
        );
        sendToServer(null, userModel.user!.sId);
        FirebaseMessaging.instance.onTokenRefresh.listen((token) {
          sendToServer(token, userModel.user!.sId);
        });

        print("Hello +++++++++++++======+++++++++++++++++++++");

        String status = await _storageController.getOdometerStatus();
        if (status == AppConfig.COMPLETE) {
          if (!(await FlutterBackgroundService().isRunning())) {
            if (kDebugMode) {
              print(
                  "++++++++++++++++++++=========++++++++++++++++++++++==========++++++++++");
            }
            FlutterBackgroundService().invoke('stopService', {"status": true});
          }
        }

        if (kDebugMode) {
          Get.offAndToNamed(AppConfig.HOME_ROUTE);
          return;
        }

        /* 
          check sim card details and match it with authorized sim card details which is stored in local hive database
          if(condition is true){
            Get.offAndToNamed(AppConfig.HOME_ROUTE);
          }else{
            throw HttpException('Sim Change Detected please reverify your sim card and account');
          }


        */

        /* Getting sim card list from native channel */
        List<Sim> simList = await permissionManager.getSimNumbers();
        List<String> ids = [];
        if (simList.isEmpty) {
          throw HttpException('No Sim Card Detected');
        } else {
          for (var element in simList) {
            ids.add("${element.slot}@${element.subsId}@${element.number}");
          }
          String sim = await _storageController.getAuthorizedSim();
          if (sim == "0") {
            Fluttertoast.showToast(msg: 'No Authorized Sim Card Found');
            Get.offAndToNamed(ValidationViews.routeName);
          } else {
            if (ids.contains(sim)) {
              if (user.role == "ADMIN") {
                Get.offAndToNamed(AdminHome.adminHomeRoute);
              } else {
                await _cloudController.sync();
                if (AppConfig.MODE == "PROD") {
                  await checkupdate();
                }
                Get.offAndToNamed(AppConfig.HOME_ROUTE);
              }
            } else {
              Fluttertoast.showToast(
                  msg:
                      'Sim Change Detected please reverify your sim card and account');
              Get.offAndToNamed(ValidationViews.routeName);
            }
          }
        }
      }
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> checkupdate() async {
    try {
      InAppUpdate.checkForUpdate().then((value) {
        if (value.updateAvailability == UpdateAvailability.updateAvailable) {
          InAppUpdate.startFlexibleUpdate().then((value) {
            return;
          });
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  showError({
    required BuildContext context,
    required String errorMessage,
    required Function callback,
  }) {
    _settingController.messageDialogue(
      context: context,
      errorMessage: errorMessage,
      callback: callback,
    );
  }
}

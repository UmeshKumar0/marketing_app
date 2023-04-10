import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:marketing/src/admin/screens/admin_home.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/controller/args.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/settings_controller.dart';
import 'package:marketing/src/user/models/user_model.dart';

class VerificationController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool resendOtp = false.obs;
  RxBool showTimer = false.obs;
  RxBool validLen = false.obs;

  late Timer _timer;

  late ApiController _apiController;
  late SettingController _settingController;
  late CloudController _cloudController;
  RxInt timer = 59.obs;

  VerificationController() {
    _apiController = Get.find<ApiController>();
    _settingController = Get.find<SettingController>();
    _cloudController = Get.find<CloudController>();
  }

  Future otprequest({required String phone}) async {
    try {
      if (_cloudController.alive.isTrue) {
        otpController.text = "";
        resendOtp.value = true;
        await _apiController.login(phone: phone);
        resendOtp.value = false;
        initTimer();
      } else {
        throw HttpException('No internet connection');
      }
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  void showError({
    required BuildContext context,
    required String errorMessage,
    required Function callback,
  }) {
    _settingController.messageDialogue(
        context: context, errorMessage: errorMessage, callback: callback);
  }

  void initTimer() async {
    showTimer.value = true;
    timer.value = 59;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      this.timer.value = this.timer.value - 1;
      if (this.timer.value == 0) {
        _timer.cancel();
        showTimer.value = false;
      }
    });
  }

  Future performverification({
    required String phone,
  }) async {
    isLoading.value = true;
    try {
      if (_cloudController.alive.isTrue) {
        UserModel userModel = await _apiController.verify(
          phone: phone,
          otp: otpController.text,
        );
        if (userModel.user!.role == "ADMIN") {
          Get.offAndToNamed(AdminHome.adminHomeRoute);
        } else {
          await _apiController.gettodayattendancestatus(
            alive: true,
          );
          _cloudController.sync();
          isLoading.value = false;
          return ApiResponseStatus(status: true, message: "verified");
        }
      } else {
        throw HttpException('No internet connection');
      }
    } on HttpException catch (e) {
      isLoading.value = false;
      return ApiResponseStatus(status: false, message: e.message);
    } catch (e) {
      isLoading.value = false;
      return ApiResponseStatus(status: false, message: e.toString());
    }
  }

  setValidLen({required bool value}) {
    validLen.value = value;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/settings_controller.dart';

class LoginController extends GetxController {
  late ApiController _apiController;
  late SettingController _settingController;
  RxString screenState = AppConfig.IDEAL_STATE.obs;
  List<String> states = ["NORMAL", "LOADING", "IDEAL", "ERROR"];
  RxString numbervalidationstate = "NORMAL".obs;
  TextEditingController phoneController = TextEditingController();

  LoginController() {
    _apiController = Get.find<ApiController>();
    _settingController = Get.find<SettingController>();
  }

  validatenumber({required BuildContext context}) async {
    try {
      if (phoneController.text.length >= 10) {
        numbervalidationstate.value = states[1];
        bool status =
            await _apiController.checkNumber(number: phoneController.text);
        if (status) {
          numbervalidationstate.value = states[3];
        } else {
          numbervalidationstate.value = states[2];
        }
      } else {
        numbervalidationstate.value = states[0];
      }
    } on HttpException catch (e) {
      numbervalidationstate.value = states[3];
      _settingController.messageDialogue(
        context: context,
        errorMessage: e.toString(),
        callback: () {
          validatenumber(context: context);
        },
      );
    } catch (e) {
      numbervalidationstate.value = states[3];
      _settingController.messageDialogue(
        context: context,
        errorMessage: e.toString(),
        callback: () {
          validatenumber(context: context);
        },
      );
    }
  }

  Future login() async {
    if (phoneController.text.length >= 10) {
      try {
        screenState.value = AppConfig.LOADING_STATE;
        await _apiController.login(phone: phoneController.text);
        screenState.value = AppConfig.IDEAL_STATE;
      } on HttpException catch (e) {
        screenState.value = AppConfig.IDEAL_STATE;
        throw HttpException(e.message);
      } catch (e) {
        screenState.value = AppConfig.IDEAL_STATE;
        rethrow;
      }
    }
  }

  showError({
    required BuildContext context,
    required String e,
  }) {
    _settingController.messageDialogue(
      context: context,
      errorMessage: e,
      callback: () {},
    );
  }
}

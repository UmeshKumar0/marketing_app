import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/splash_controller.dart';
import 'package:marketing/src/user/models/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashController _splashController;

  @override
  void initState() {
    super.initState();
    _splashController = Get.find<SplashController>();
    changeScreen(splashController: _splashController);
  }

  void changeScreen({required SplashController splashController}) async {
    try {
      final UserModel? token = await splashController.checktoken();
      if (token == null) {
        Get.offAndToNamed(AppConfig.UTILS_SCREEN);
      } else {
        validatetoken(splashController: splashController, user: token);
      }
    } catch (e) {
      Timer(const Duration(seconds: 1), () {
        _splashController.showError(
          context: context,
          callback: () {
            changeScreen(splashController: splashController);
          },
          errorMessage: 'Token not found',
        );
      });
    }
  }

  void validatetoken({
    required SplashController splashController,
    required UserModel user,
  }) async {
    try {
      await splashController.validatetoken(userModel: user);
    } on HttpException catch (e) {
      splashController.showError(
        context: context,
        errorMessage: e.message,
        callback: () {
          validatetoken(splashController: splashController, user: user);
        },
      );
    } catch (e) {
      splashController.showError(
        context: context,
        errorMessage: e.toString(),
        callback: () {
          validatetoken(splashController: splashController, user: user);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        "assets/preloader.gif",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
    );
  }
}

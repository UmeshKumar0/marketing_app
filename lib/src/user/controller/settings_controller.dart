import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:marketing/src/user/screens/validation/views/ValidationView.dart';

class SettingController extends GetxController {
  late StorageController _storageController;

  SettingController() {
    _storageController = Get.find<StorageController>();
  }

  rightSlidePage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return page;
        },
        transitionsBuilder: (context, animation, secondAnimation, child) {
          return SlideTransition(
            position: animation.drive(
                Tween(begin: const Offset(1, 0), end: const Offset(0, 0))),
            child: child,
          );
        },
      ),
    );
  }

  messageDialogue({
    required BuildContext context,
    required String errorMessage,
    required Function callback,
  }) {
    return showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'Error !',
            style: GoogleFonts.firaSans(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ), // To display the title it is optional
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/error.png",
                  height: 90,
                  width: 90,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text(
                  errorMessage == "TOKEN_EXPIRE"
                      ? 'Your token is expire please login again'
                      : errorMessage,
                  style: GoogleFonts.firaSans(
                    color: Colors.red.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue.withOpacity(0.7),
                  ),
                  child: Text(
                    'Back',
                    style: GoogleFonts.firaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            errorMessage == "TOKEN_EXPIRE"
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        bool status = await _storageController.removetoken();
                        if (status) {
                          Get.offAllNamed(
                            ValidationViews.routeName,
                          );
                        } else {
                          exit(0);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red.withOpacity(0.7),
                        ),
                        child: Text(
                          'Login Again',
                          style: GoogleFonts.firaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        callback();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red.withOpacity(0.7),
                        ),
                        child: Text(
                          'Try Again',
                          style: GoogleFonts.firaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  )
          ],
          elevation: 10,
        );
      },
    );
  }
}

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/screens/validation/views/ValidationView.dart';

class CustomErrorWidget extends StatelessWidget {
  CustomErrorWidget({
    Key? key,
    required this.errorMessage,
    required this.buttonText,
    required this.loggedOut,
    required this.cb,
  }) : super(key: key);
  bool loggedOut;
  String errorMessage;
  String buttonText;
  Function cb;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset("assets/errorImg.png"),
        Container(
          alignment: Alignment.center,
          child: Text(
            errorMessage,
            style: GoogleFonts.firaSans(
              color: Colors.red.withOpacity(0.7),
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        loggedOut
            ? OutlinedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue.withOpacity(0.7)),
                    elevation: MaterialStateProperty.all(3)),
                child: Text(
                  'Log in',
                  style: GoogleFonts.firaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                onPressed: () {
                  Get.offAllNamed(ValidationViews.routeName);
                },
              )
            : OutlinedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue.withOpacity(0.7)),
                    elevation: MaterialStateProperty.all(3)),
                child: Text(
                  buttonText,
                  style: GoogleFonts.firaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                onPressed: () {
                  cb();
                },
              ),
      ],
    );
  }
}

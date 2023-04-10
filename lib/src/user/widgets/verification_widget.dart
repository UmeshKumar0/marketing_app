import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/args.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/verification_controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationWidget extends StatelessWidget {
  VerificationWidget({
    super.key,
    required this.loginArgs,
  });
  LoginArgs loginArgs;
  @override
  Widget build(BuildContext context) {
    return GetX<VerificationController>(builder: (verification) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PinCodeTextField(
              cursorHeight: 18,
              cursorColor: Colors.blue.withOpacity(0.7),
              appContext: context,
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 55,
                fieldWidth: 50,
                activeColor: Colors.blue.withOpacity(0.7),
                inactiveColor: AppConfig.primaryColor7,
                disabledColor: Colors.grey.withOpacity(0.7),
                inactiveFillColor: Colors.white,
              ),
              length: 6,
              onChanged: (value) {
                if (value.length == 6) {
                  verification.setValidLen(value: true);
                } else {
                  verification.setValidLen(value: false);
                }
              },
              animationCurve: Curves.fastOutSlowIn,
              animationDuration: const Duration(milliseconds: 500),
              autoDismissKeyboard: true,
              autoDisposeControllers: true,
              autoFocus: true,
              autoUnfocus: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: verification.otpController,
              enabled:
                  verification.isLoading.isTrue || verification.resendOtp.isTrue
                      ? false
                      : true,
              onCompleted: (value) async {
                verification.setValidLen(value: true);
                if (verification.otpController.text.length == 6) {
                  ApiResponseStatus apiResponseStatus =
                      await verification.performverification(
                    phone: loginArgs.phone,
                  );

                  if (apiResponseStatus.status) {
                    Fluttertoast.showToast(
                        msg: 'Verification completed logged in');
                    Get.offAllNamed(AppConfig.HOME_ROUTE);
                  } else {
                    verification.showError(
                      context: context,
                      errorMessage: apiResponseStatus.message,
                      callback: () {},
                    );
                  }
                }
              },
            ),
          ),
          verification.isLoading.isTrue
              ? Container()
              : Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: verification.resendOtp.isTrue
                      ? Container(
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: verification.showTimer.isTrue
                              ? [
                                  Text(
                                    'You can request for new otp after ',
                                    style: GoogleFonts.firaSans(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 16),
                                  ),
                                  Text(
                                    '${verification.timer.value}',
                                    style: GoogleFonts.firaSans(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 16,
                                    ),
                                  )
                                ]
                              : [
                                  Text(
                                    'Didn\'t recieve code ?',
                                    style: GoogleFonts.firaSans(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 16),
                                  ),
                                  InkWell(
                                    child: Text(
                                      'Request again',
                                      style: GoogleFonts.firaSans(
                                        color: verification.showTimer.isTrue
                                            ? Colors.black.withOpacity(0.6)
                                            : Colors.black.withOpacity(0.8),
                                        fontSize: 16,
                                      ),
                                    ),
                                    onTap: () async {
                                      try {
                                        await verification.otprequest(
                                            phone: loginArgs.phone);
                                        Fluttertoast.showToast(
                                            msg:
                                                'otp sent to ${loginArgs.phone}');
                                      } on HttpException catch (e) {
                                        verification.showError(
                                          context: context,
                                          errorMessage: e.message,
                                          callback: () {},
                                        );
                                      } catch (e) {
                                        verification.showError(
                                          context: context,
                                          errorMessage: e.toString(),
                                          callback: () {},
                                        );
                                      }
                                    },
                                  )
                                ],
                        ),
                ),
          verification.isLoading.isTrue
              ? Container()
              : Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Wrong Number ?',
                      style: GoogleFonts.firaSans(
                          color: Colors.black.withOpacity(0.6), fontSize: 16),
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () async {
                if (verification.otpController.text.length == 6) {
                  ApiResponseStatus apiResponseStatus =
                      await verification.performverification(
                    phone: loginArgs.phone,
                  );

                  if (apiResponseStatus.status) {
                    Fluttertoast.showToast(
                        msg: 'Verification completed logged in');
                    Get.offAllNamed(AppConfig.HOME_ROUTE);
                  } else {
                    verification.showError(
                      context: context,
                      errorMessage: apiResponseStatus.message,
                      callback: () {},
                    );
                  }
                } else {
                  Fluttertoast.showToast(
                    msg: "OTP length should be 6 digits",
                  );
                }
              },
              child: verification.isLoading.isTrue
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppConfig.primaryColor7,
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      child: const CircularProgressIndicator(),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: verification.validLen.isTrue
                              ? AppConfig.primaryColor5
                              : AppConfig.primaryColor7),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Verify and Login Account',
                        style: GoogleFonts.firaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
            ),
          )
        ],
      );
    });
  }
}

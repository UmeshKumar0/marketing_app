import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/args.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/login_controller.dart';
import 'package:marketing/src/user/widgets/StylishName_widget.dart';
import 'package:marketing/src/user/widgets/connection_status.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double margin = 10;
    if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
      margin = 20;
    } else {
      margin = 20;
    }
    return Scaffold(
      appBar: AppBar(
        title: StylishName(firstName: 'LOG', lastName: 'IN'),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: GetX<LoginController>(builder: (loginController) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const ConnectionStatus(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/login.png",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: margin),
              child: Container(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 4),
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Enter your phone',
                                style: GoogleFonts.firaSans(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, bottom: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '+91 ',
                                    style: GoogleFonts.firaSans(
                                      color: Colors.black,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (value) async {
                                        if (loginController
                                                .numbervalidationstate.value ==
                                            loginController.states[2]) {
                                          try {
                                            await loginController.login();
                                            Get.toNamed(
                                              AppConfig.VERIFY_SCREEN,
                                              arguments: LoginArgs(
                                                phone: loginController
                                                    .phoneController.text,
                                              ),
                                            );
                                          } on HttpException catch (e) {
                                            loginController.showError(
                                                context: context, e: e.message);
                                          } catch (e) {
                                            loginController.showError(
                                                context: context,
                                                e: e.toString());
                                          }
                                        }
                                      },
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      enabled:
                                          loginController.screenState.value ==
                                                  AppConfig.LOADING_STATE
                                              ? false
                                              : true,
                                      keyboardType: TextInputType.number,
                                      controller:
                                          loginController.phoneController,
                                      decoration: const InputDecoration(
                                        isCollapsed: true,
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (value) async {
                                        loginController.validatenumber(
                                          context: context,
                                        );
                                      },
                                      cursorHeight: 20,
                                      style: GoogleFonts.firaSans(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),
                                    height: 25,
                                    width: 30,
                                    // alignment: Alignment.center,
                                    child: loginController
                                                .numbervalidationstate.value ==
                                            loginController.states[0]
                                        ? Container()
                                        : loginController.numbervalidationstate
                                                    .value ==
                                                loginController.states[1]
                                            ? CircularProgressIndicator(
                                                color: AppConfig.primaryColor7,
                                              )
                                            : loginController
                                                        .numbervalidationstate
                                                        .value ==
                                                    loginController.states[2]
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                  )
                                                : Icon(
                                                    Icons.clear,
                                                    color:
                                                        AppConfig.primaryColor8,
                                                  ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: loginController.screenState.value ==
                                      AppConfig.LOADING_STATE
                                  ? AppConfig.primaryColor7
                                  : loginController
                                              .numbervalidationstate.value ==
                                          loginController.states[2]
                                      ? AppConfig.primaryColor5
                                      : AppConfig.primaryColor7,
                            ),
                            child: loginController.screenState.value ==
                                    AppConfig.LOADING_STATE
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Continue',
                                    style: GoogleFonts.firaSans(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                          onTap: () async {
                            if (loginController.numbervalidationstate.value ==
                                loginController.states[2]) {
                              try {
                                await loginController.login();
                                Get.toNamed(
                                  AppConfig.VERIFY_SCREEN,
                                  arguments: LoginArgs(
                                    phone: loginController.phoneController.text,
                                  ),
                                );
                              } on HttpException catch (e) {
                                loginController.showError(
                                    context: context, e: e.message);
                              } catch (e) {
                                loginController.showError(
                                    context: context, e: e.toString());
                              }
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              child: Text(
                'You\'ll receive a 6 digit code to verify next.',
                style: GoogleFonts.firaSans(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      }),
    );
  }
}

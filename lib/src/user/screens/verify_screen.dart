import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/args.dart';
import 'package:marketing/src/user/widgets/StylishName_widget.dart';
import 'package:marketing/src/user/widgets/connection_status.dart';
import 'package:marketing/src/user/widgets/verification_widget.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginArgs loginArgs =
        ModalRoute.of(context)!.settings.arguments as LoginArgs;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.offAndToNamed(AppConfig.LOGIN_ROUTE);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        centerTitle: true,
        title: StylishName(firstName: 'Verify', lastName: 'Phone'),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const ConnectionStatus(),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                'Code is sent to +91 ${loginArgs.phone}',
                style: GoogleFonts.firaSans(
                    fontSize: 18, color: Colors.black.withOpacity(0.5)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Image.asset(
              "assets/verify.png",
            ),
          ),
          VerificationWidget(
            loginArgs: loginArgs,
          ),
        ],
      ),
    );
  }
}

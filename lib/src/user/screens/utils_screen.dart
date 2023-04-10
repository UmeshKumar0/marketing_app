import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/screens/app_permission/views/AppPermissionView.dart';
import 'package:marketing/src/user/widgets/StylishName_widget.dart';

class UtilsScreen extends StatelessWidget {
  UtilsScreen({Key? key}) : super(key: key);
  getPermissions() async {
    Get.offAndToNamed(AppPermissionViews.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StylishName(firstName: "About", lastName: "us"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset("assets/bg.gif"),
          Container(
            alignment: Alignment.center,
            child: Text(
              'Hey! Welcome',
              style: GoogleFonts.firaSans(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.7),
                letterSpacing: 1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Text(
              'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book',
              style: TextStyle(
                color: Colors.grey.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            child: Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppConfig.primaryColor7,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Contact us',
                style: GoogleFonts.firaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              child: Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'I already have an account',
                  style: GoogleFonts.firaSans(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
              onTap: () async {
                await getPermissions();
              },
            ),
          ),
        ],
      ),
    );
  }
}

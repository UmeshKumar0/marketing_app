import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10,
      child: GetX<StorageController>(builder: (controller) {
        return ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppConfig.primaryColor7,
              ),
              child: Container(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10),
                  child: Text(
                    controller.userModel.value.user!.name.toString().length > 15
                        ? '${controller.userModel.value.user!.name.toString().substring(0, 15)}...'
                        : controller.userModel.value.user!.name.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.grey.shade500,
              ),
              title: Text(
                'Profile',
                style: GoogleFonts.poppins(
                  color: AppConfig.primaryColor5,
                ),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: Icon(
                Icons.shop,
                color: Colors.grey.shade500,
              ),
              title: Text(
                'Shops',
                style: GoogleFonts.poppins(
                  color: AppConfig.primaryColor5,
                ),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: Icon(
                Icons.group,
                color: Colors.grey.shade500,
              ),
              title: Text(
                'Marketing Officers',
                style: GoogleFonts.poppins(
                  color: AppConfig.primaryColor5,
                ),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.grey.shade500,
              ),
              title: Text(
                'Settings',
                style: GoogleFonts.poppins(
                  color: AppConfig.primaryColor5,
                ),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.grey.shade500,
              ),
              title: Text(
                'Logout',
                style: GoogleFonts.poppins(
                  color: AppConfig.primaryColor5,
                ),
              ),
              onTap: () {
                controller.userBox.clear();
                Get.offAllNamed(AppConfig.LOGIN_ROUTE);
              },
            ),
          ],
        );
      }),
    );
  }
}

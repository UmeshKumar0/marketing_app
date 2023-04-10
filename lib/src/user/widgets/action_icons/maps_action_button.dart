import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';

class MapsActionButtons extends StatelessWidget {
  const MapsActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Get.toNamed(AppConfig.NOTIFICATION_SCREEN);
      },
      icon: GetX<StorageController>(
        builder: (storage) {
          return Badge(
            label: Text(
              storage.getCount().toString(),
              style: GoogleFonts.firaSans(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
            child: Icon(
              Icons.notifications,
              color: AppConfig.primaryColor7,
            ),
          );
        },
      ),
    );
  }
}

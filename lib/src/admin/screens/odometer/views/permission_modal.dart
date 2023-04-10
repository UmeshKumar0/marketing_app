import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/models/AOdometer.model.dart';

class PermissionModal extends StatelessWidget {
  PermissionModal({
    super.key,
    required this.odometer,
  });
  AOdometer odometer;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Get.dialog(
          AlertDialog(
            title: Text(
              'Permissions',
              style: GoogleFonts.firaSans(),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (odometer.user!.appMetadata!.permissions!.isEmpty)
                  Text(
                    'No permissions',
                    style: GoogleFonts.firaSans(),
                  )
                else
                  ...odometer.user!.appMetadata!.permissions!
                      .map(
                        (e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.key.toString(),
                              style: GoogleFonts.firaSans(),
                            ),
                            Text(
                              e.value.toString(),
                              style: GoogleFonts.firaSans(
                                color: e.value == true
                                    ? AppConfig.primaryColor5
                                    : AppConfig.primaryColor8,
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'app_version : ',
                      style: GoogleFonts.firaSans(),
                    ),
                    Text(
                      '${odometer.user!.appMetadata!.version}',
                      style:
                          GoogleFonts.firaSans(color: AppConfig.primaryColor5),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
      icon: Icon(
        Icons.accessibility,
        color: AppConfig.primaryColor5,
      ),
    );
  }
}

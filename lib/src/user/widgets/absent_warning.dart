import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/odometer_controller.dart';

class AbsentWarning extends StatelessWidget {
  const AbsentWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<OdometerController>(builder: (attendance) {
      return AlertDialog(
        title: Text(
          attendance.absentCompleted.isTrue ? 'Completed' : 'Warning !',
          style: GoogleFonts.firaSans(
            color: Colors.black.withOpacity(0.7),
            fontWeight: FontWeight.w400,
            fontSize: 17,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                attendance.absentMessage.value,
                style: GoogleFonts.firaSans(
                    color: AppConfig.primaryColor7,
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actions: attendance.absentCompleted.isTrue
            ? [
                OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Okay"),
                )
              ]
            : attendance.attendanceCreating.isTrue
                ? [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: CircularProgressIndicator(),
                    ),
                  ]
                : [
                    OutlinedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(3),
                        backgroundColor: MaterialStateProperty.all(
                          Colors.red.withOpacity(0.7),
                        ),
                        foregroundColor: MaterialStateProperty.all(
                          Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        'No',
                        style: GoogleFonts.firaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        attendance.markAbsent();
                      },
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(3),
                        backgroundColor: MaterialStateProperty.all(
                          AppConfig.primaryColor7,
                        ),
                        foregroundColor: MaterialStateProperty.all(
                          Colors.white,
                        ),
                      ),
                      child: Text(
                        'Yes I am sure',
                        style: GoogleFonts.firaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
      );
    });
  }
}

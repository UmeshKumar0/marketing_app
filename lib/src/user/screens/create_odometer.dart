import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/odometer_controller.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:marketing/src/user/widgets/connection_status.dart';
import 'package:marketing/src/user/widgets/create_attendance.dart';

class CreateOdoMeterScreen extends GetView<StorageController> {
  const CreateOdoMeterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        OdometerController odometerController = Get.find<OdometerController>();
        if (odometerController.workingProcess.isTrue) {
          Get.snackbar('Error', 'Please wait for the process to complete');
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: AppConfig.primaryColor7,
            ),
          ),
          titleSpacing: 1,
          title: Text(
            'Attendance',
            style: GoogleFonts.firaSans(
              fontWeight: FontWeight.w400,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          actions: const [],
        ),
        body: Obx(
          () {
            return controller.odoMeter.value == AppConfig.PRESENT
                ? CreateAttendance(
                    startReading: false,
                  )
                : controller.odoMeter.value == AppConfig.ABSENT
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const ConnectionStatus(),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset("assets/absent.png"),
                          ),
                          Text(
                            "You are absent for today",
                            style: GoogleFonts.firaSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : controller.odoMeter.value == AppConfig.HALFDAY
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppConfig.primaryColor5,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Your duty is marked as half day by admin, thank you for your contribution',
                                  style: GoogleFonts.firaSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset("assets/absent.png"),
                              ),
                            ],
                          )
                        : controller.odoMeter.value == AppConfig.COMPLETE
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppConfig.primaryColor5,
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Your duty is completed, Thank you for your contribution',
                                      style: GoogleFonts.firaSans(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.asset("assets/absent.png"),
                                  )
                                ],
                              )
                            : controller.odoMeter.value == AppConfig.NOTMARKED
                                ? CreateAttendance(
                                    startReading: true,
                                  )
                                : Container();
          },
        ),
      ),
    );
  }
}

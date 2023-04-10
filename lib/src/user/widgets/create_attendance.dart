// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/odometer_controller.dart';
import 'package:marketing/src/user/widgets/absent_warning.dart';
import 'package:marketing/src/user/widgets/connection_status.dart';
import 'package:marketing/src/user/widgets/cool_button.dart';
import 'package:marketing/src/user/widgets/customButton.dart';

class CreateAttendance extends StatelessWidget {
  CreateAttendance({
    Key? key,
    required this.startReading,
  }) : super(key: key);
  bool startReading;
  @override
  Widget build(BuildContext context) {
    return GetX<OdometerController>(builder: (attendance) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const ConnectionStatus(),
          startReading == false
              ? Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppConfig.primaryColor7,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Your Attendance status is PRESENT please complete the form for add end reading of your odo meter',
                    style: GoogleFonts.firaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: -10,
                  ),
                ],
              ),
              child: TextField(
                controller: attendance.readingConroller,
                enabled: !attendance.attendanceCreating.value,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: startReading
                      ? 'Enter start reading '
                      : 'Enter end reading',
                  hintStyle: GoogleFonts.firaSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppConfig.primaryColor7,
                  ),
                  prefixIcon: Icon(
                    Icons.lock_clock,
                    color: AppConfig.primaryColor7,
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {},
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: -10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: AppConfig.primaryColor7,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: attendance.imagePath.value == 'N/A'
                        ? const Icon(
                            Icons.image,
                            color: Colors.white,
                          )
                        : ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            child: Image.file(
                              File(attendance.imagePath.value),
                              fit: BoxFit.fill,
                            ),
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  attendance.imagePath.value != 'N/A'
                      ? Flexible(
                          flex: 4,
                          fit: FlexFit.loose,
                          child: Text(
                            attendance.imagePath.value,
                            style: GoogleFonts.firaSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppConfig.primaryColor7,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : InkWell(
                          onTap: () async {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');

                            Get.bottomSheet(
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 15,
                                        spreadRadius: -10,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Select Image',
                                              style: GoogleFonts.firaSans(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                color: AppConfig.primaryColor7,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                color: AppConfig.primaryColor7,
                                              ),
                                              onPressed: () {
                                                Get.back();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            CoolButton(
                                              icon: Icons.camera,
                                              onTap: () async {
                                                final String image =
                                                    await Get.toNamed(AppConfig
                                                        .CAMERA_SCREEN);

                                                attendance.setImage(
                                                    path: image);
                                                Get.back();
                                              },
                                              text: "Camera 1",
                                              backgroundColor:
                                                  AppConfig.primaryColor5,
                                              iconColor: Colors.white,
                                              textColor:
                                                  AppConfig.primaryColor5,
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            CoolButton(
                                              icon: Icons.camera_alt,
                                              onTap: () async {
                                                ImagePicker picker =
                                                    ImagePicker();
                                                final XFile? image =
                                                    await picker.pickImage(
                                                  source: ImageSource.camera,
                                                  preferredCameraDevice:
                                                      CameraDevice.rear,
                                                  imageQuality: 50,
                                                  maxHeight: 640,
                                                  maxWidth: 480,
                                                );

                                                if (image != null) {
                                                  attendance.setImage(
                                                    path: image.path,
                                                  );
                                                  Get.back();
                                                } else {
                                                  Get.snackbar(
                                                    'Error',
                                                    'No Image Selected',
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white,
                                                  );
                                                }
                                              },
                                              text: "Camera 2",
                                              backgroundColor:
                                                  AppConfig.primaryColor5,
                                              iconColor: Colors.white,
                                              textColor:
                                                  AppConfig.primaryColor5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                              isDismissible: false,
                            );
                          },
                          child: Text(
                            startReading
                                ? 'Enter start reading Image'
                                : 'Enter end reading Image',
                            style: GoogleFonts.firaSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppConfig.primaryColor7,
                            ),
                          ),
                        ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: attendance.attendanceCreating.isTrue
                          ? Container()
                          : attendance.imagePath.value != 'N/A'
                              ? InkWell(
                                  onTap: () {
                                    attendance.clearImage();
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: AppConfig.primaryColor7,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : Container(),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: -10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: AppConfig.primaryColor7,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.map_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  attendance.mapAddress.value != 'N/A'
                      ? Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            attendance.mapAddress.value,
                            style: GoogleFonts.firaSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppConfig.primaryColor7,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : InkWell(
                          onTap: () {},
                          child: Text(
                            'Your current address',
                            style: GoogleFonts.firaSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppConfig.primaryColor7,
                            ),
                          ),
                        ),
                  Expanded(
                    child: attendance.attendanceCreating.isTrue
                        ? Container()
                        : Container(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                if (attendance.locationLoading.isFalse) {
                                  attendance.getAddress();
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: AppConfig.primaryColor7,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: attendance.locationLoading.isTrue
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ),
                  )
                ],
              ),
            ),
          ),
          attendance.attendanceCreating.isTrue
              ? Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: CircularProgressIndicator(
                    color: AppConfig.primaryColor7,
                  ),
                )
              : CustomButton(
                  onTap: () async {
                    bool value = await attendance.markPresent(
                      context: context,
                      completed: !startReading,
                    );
                    if (value) {
                      Get.back();
                    }
                  },
                  text: startReading ? "Mark Present" : "Completed Attendance",
                  color: AppConfig.primaryColor7,
                ),
          attendance.attendanceCreating.isTrue
              ? Container()
              : startReading == false
                  ? Container()
                  : TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Are you sure?',
                                style: GoogleFonts.firaSans(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: AppConfig.primaryColor7,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: OutlinedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(2),
                          backgroundColor: MaterialStateProperty.all(
                            Colors.red.withOpacity(0.7),
                          ),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible:
                                attendance.attendanceCreating.value,
                            builder: (context) {
                              return const AbsentWarning();
                            },
                          );
                        },
                        child: Text(
                          'Don\'t want to work ? Mark Absent',
                          style: GoogleFonts.firaSans(),
                        ),
                      ),
                    ),
        ],
      );
    });
  }
}

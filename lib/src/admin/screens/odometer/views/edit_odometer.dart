import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/admin/models/AOdometer.model.dart';
import 'package:marketing/src/admin/screens/odometer/controller/admin_odometer.controller.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';

class EditOdometer extends StatelessWidget {
  EditOdometer({
    super.key,
    required this.controller,
    required this.odometer,
  });
  AOdometerController controller;
  AOdometer odometer;
  @override
  Widget build(BuildContext context) {
    return GetX<StorageController>(
      builder: (storage) {
        return storage.isEditOdometer == true
            ? ElevatedButton(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Close Odometer'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Close odometer for user ${odometer.user!.name}',
                              style: GoogleFonts.firaSans(),
                            ),
                          ),
                          Obx(() {
                            return controller.readingImage.value != "N/A"
                                ? SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image.file(
                                      File(controller.readingImage.value),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Please select image  for end reading',
                                      style: GoogleFonts.firaSans(
                                          color: Colors.red),
                                    ),
                                  );
                          }),
                          Obx(() {
                            return controller.readingImage.value == "N/A"
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          controller.getImage(
                                            camera: true,
                                          );
                                        },
                                        icon: const Icon(Icons.camera),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          controller.getImage(camera: false);
                                        },
                                        icon: const Icon(Icons.image),
                                      ),
                                    ],
                                  )
                                : TextButton(
                                    onPressed: () {
                                      controller.readingImage.value = "N/A";
                                    },
                                    child: const Text(
                                      "Change Image",
                                    ),
                                  );
                          }),
                          TextField(
                            controller: controller.manualReading,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Enter End Reading',
                            ),
                          )
                        ],
                      ),
                      actions: [
                        Obx(() {
                          return controller.closingOdo.isFalse
                              ? TextButton(
                                  onPressed: () {
                                    controller.readingImage.value = "N/A";
                                    Get.back();
                                  },
                                  child: const Text('Cancel'),
                                )
                              : Container();
                        }),
                        Obx(() {
                          return controller.readingImage.value != "N/A"
                              ? controller.closingOdo.isTrue
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton(
                                      onPressed: () async {
                                        await controller.closeOdometer(
                                          odoId: odometer.sId as String,
                                        );
                                        Get.back();
                                      },
                                      child: const Text('Submit & Close'),
                                    )
                              : Container();
                        })
                      ],
                    ),
                    useSafeArea: true,
                    barrierDismissible: false,
                  );
                },
                child: Text(
                  "ClOSE",
                  style: GoogleFonts.firaSans(),
                ),
              )
            : Container();
      },
    );
  }
}

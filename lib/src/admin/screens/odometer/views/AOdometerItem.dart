import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/models/AOdometer.model.dart';
import 'package:marketing/src/admin/screens/odometer/controller/admin_odometer.controller.dart';
import 'package:marketing/src/admin/screens/odometer/views/edit_odometer.dart';
import 'package:marketing/src/admin/screens/odometer/views/login_history.dart';
import 'package:marketing/src/admin/screens/odometer/views/permission_modal.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';

class AOdometerItem extends StatelessWidget {
  AOdometerItem({
    super.key,
    required this.odometer,
    required this.controller,
  });
  AOdometer odometer;
  AOdometerController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: AppConfig.lightBG,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.person,
                        color: AppConfig.primaryColor5,
                      ),
                    ),
                  ),
                  Text(
                    odometer.user!.name != null
                        ? odometer.user!.name!.length > 15
                            ? '${odometer.user!.name.toString().substring(0, 15)}...'
                            : odometer.user!.name.toString()
                        : 'No name',
                    style: GoogleFonts.poppins(color: Colors.grey.shade600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GetX<StorageController>(builder: (storage) {
                    return storage.isDeleteOdometer
                        ? IconButton(
                            onPressed: () {
                              controller.deleteodometer(
                                  id: odometer.sId as String);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: AppConfig.primaryColor8,
                            ),
                          )
                        : Container();
                  }),
                  IconButton(
                    onPressed: () {
                      controller.loadVisits(
                          userId: odometer.user!.sId as String);
                      // Get.toNamed(AdminMaps.routeName);
                    },
                    icon: Icon(
                      Icons.map,
                      color: AppConfig.primaryColor8,
                    ),
                  ),
                  PermissionModal(odometer: odometer),
                ],
              )
            ],
          ),
        ),
        const Divider(
          thickness: 1,
        ),
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        if (odometer.startReading != null) {
                          Get.dialog(
                            AlertDialog(
                              title: const Text('Start Reading'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 300,
                                    width: 400,
                                    child: Image.network(
                                      '${AppConfig.SERVER_IP}/${odometer.startReadingImage}',
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text('Close'),
                                )
                              ],
                            ),
                          );
                        } else {
                          Fluttertoast.showToast(msg: 'No image');
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.green.withOpacity(0.8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'start',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              odometer.startReading.toString(),
                              style: GoogleFonts.firaSans(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text(
                        'to',
                        style: GoogleFonts.firaSans(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (odometer.endReading != null) {
                          Get.dialog(
                            AlertDialog(
                              title: const Text('End Reading'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 300,
                                    width: 400,
                                    child: Image.network(
                                      '${AppConfig.SERVER_IP}/${odometer.endReadingImage}',
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text('Close'),
                                )
                              ],
                            ),
                          );
                        } else {
                          Fluttertoast.showToast(msg: 'No image');
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.green.withOpacity(0.8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'end',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              odometer.endReading == null
                                  ? '0'
                                  : odometer.endReading.toString(),
                              style: GoogleFonts.firaSans(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    odometer.endReading == null
                        ? EditOdometer(
                            controller: controller,
                            odometer: odometer,
                          )
                        : Container(),
                    IconButton(
                      onPressed: () {
                        Get.toNamed(LoginHistory.routeName,
                            arguments: odometer.user!.appMetadata!.login);
                      },
                      icon: const Icon(Icons.history),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        const Divider(
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.watch,
                    color: AppConfig.primaryColor5,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    controller.visits[odometer.user!.sId] == null
                        ? 'NOT FOUND'
                        : controller.visits[odometer.user!.sId]!.time == null
                            ? 'NOT FOUND'
                            : DateTime.parse(controller
                                    .visits[odometer.user!.sId]!.time
                                    .toString())
                                .toLocal()
                                .toString()
                                .split('.')
                                .first,
                    style: GoogleFonts.firaSans(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.route,
                    color: Colors.green.withOpacity(0.6),
                    size: 15,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    controller.visits[odometer.user!.sId] != null
                        ? controller.visits[odometer.user!.sId]!.count
                            .toString()
                        : '0',
                    style: GoogleFonts.firaSans(
                      color: AppConfig.primaryColor5,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    odometer.endReading != null
                        ? '₦ ${odometer.endReading! - odometer.startReading!}'
                        : '₦ 0',
                    style: GoogleFonts.firaSans(
                      color: AppConfig.primaryColor5,
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
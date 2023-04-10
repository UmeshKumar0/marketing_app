// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.firaSans(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
      ),
      body: GetX<StorageController>(builder: (storage) {
        return storage.notificationLoading.isTrue
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : storage.userNotification.isEmpty
                ? Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Notification not found',
                      style: GoogleFonts.firaSans(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      storage.userNotification.value[index]
                                          .title as String,
                                      style: GoogleFonts.firaSans(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,
                                      ),
                                    ),
                                    content: Text(
                                      storage.userNotification.value[index]
                                          .message as String,
                                      style: GoogleFonts.firaSans(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          await Get.find<ApiController>()
                                              .deleteAllNotifications(
                                            ids: [
                                              storage.userNotification
                                                  .value[index].sId as String,
                                            ],
                                          );
                                          Get.back();
                                        },
                                        child: const Text('Delete'),
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Colors.red.withOpacity(0.7),
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (storage.userNotification[index]
                                                  .read ==
                                              false) {
                                            await Get.find<ApiController>()
                                                .markAsReadNotification(
                                              notificationId: storage
                                                  .userNotification
                                                  .value[index]
                                                  .sId as String,
                                            );
                                          }
                                          Get.back();
                                        },
                                        child: storage.userNotification[index]
                                                    .read ==
                                                true
                                            ? Text('Back')
                                            : const Text('Mark Read'),
                                      )
                                    ],
                                  );
                                });
                          },
                          tileColor:
                              storage.userNotification[index].read == false
                                  ? AppConfig.primaryColor7
                                  : Colors.white,
                          leading: Icon(
                            Icons.notifications_outlined,
                            color: storage.userNotification[index].read == true
                                ? AppConfig.primaryColor7
                                : Colors.white,
                          ),
                          title: Text(
                            storage.userNotification[index].title as String,
                            style: GoogleFonts.firaSans(
                              color:
                                  storage.userNotification[index].read == true
                                      ? AppConfig.primaryColor7
                                      : Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            storage.userNotification[index].message as String,
                            style: GoogleFonts.firaSans(
                                color:
                                    storage.userNotification[index].read == true
                                        ? AppConfig.primaryColor7
                                        : Colors.white),
                          ),
                        ),
                      );
                    },
                    itemCount: storage.userNotification.length,
                  );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/meetings_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:marketing/src/user/models/meetings/meeting_user.dart';
import 'package:marketing/src/user/screens/meetings_widgets/meeting_item.dart';

class MeetingScreen extends GetView<MeetingsController> {
  const MeetingScreen({super.key});

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
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        titleSpacing: 0,
        title: Text(
          'Meetings',
          style: GoogleFonts.firaSans(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          Obx(() {
            return controller.userLoading.isTrue
                ? const Center(child: CircularProgressIndicator())
                : Container();
          }),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.prevDate,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.arrow_back_ios_new),
                        SizedBox(width: 5),
                        Text("Previous"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.nextDate,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Next"),
                        SizedBox(width: 5),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            alignment: Alignment.centerLeft,
            child: Obx(
              () {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.startDate.isEmpty
                          ? "N/A"
                          : controller.startDate.value.split(' ').first,
                      style: GoogleFonts.firaSans(
                        color: AppConfig.primaryColor7,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      controller.endDate.isEmpty
                          ? "N/A"
                          : controller.endDate.value.split(' ').first,
                      style: GoogleFonts.firaSans(
                        color: AppConfig.primaryColor7,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable:
                  controller.storageController.meetingUserBox.listenable(),
              builder: (context, value, child) {
                return controller.storageController.meetingUserBox.isEmpty
                    ? const Center(
                        child:
                            Text("No Meetings users found in local database"),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          MeetingUser? meetingUser = controller
                              .storageController.meetingUserBox
                              .getAt(index);
                          return MeetingUserItem(
                            meetingUser: meetingUser,
                          );
                        },
                        itemCount:
                            controller.storageController.meetingUserBox.length,
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}

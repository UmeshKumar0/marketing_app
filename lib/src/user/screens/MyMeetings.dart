import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/user/controller/my_meeting_controller.dart';
import 'package:marketing/src/user/screens/meetings_widgets/assigned_meetings.dart';
import 'package:marketing/src/user/screens/meetings_widgets/createdMeetings.dart';

class MyMeetings extends GetView<MyMeetingController> {
  const MyMeetings({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (controller.isWorking.isTrue) {
          Fluttertoast.showToast(
              msg: 'Please wait while meeting controller is working some work');
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
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
              controller.appTitle,
              style: GoogleFonts.firaSans(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            bottom: TabBar(
              onTap: (value) {
                if (value == 1) {
                  print('Hello World');
                  controller.getCreatedMeetings();
                } else {
                  controller.fetchMeetings();
                }
              },
              tabs: const [
                Tab(
                  text: "Assigned Meetings",
                ),
                Tab(
                  text: "Created Meetings",
                ),
              ],
            ),
          ),
          body: TabBarView(
            physics:
                const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
            children: [
              AssignedMeetings(controller: controller),
              CreatedMeetings(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}

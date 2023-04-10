import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketing/src/admin/screens/meetings/controller/admin_meetingcontroller.dart';

class AdminMeetingViews extends GetView<AdminMeetingController> {
  const AdminMeetingViews({super.key});
  static String routeName = '/admin/meeting_views';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Meetings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

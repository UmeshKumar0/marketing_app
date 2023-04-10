import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/user/controller/leave_controller.dart';
import 'package:marketing/src/user/screens/action_screens/leave_apply_widget.dart';
import 'package:marketing/src/user/screens/action_screens/your_leaves.dart';

class LeaveScreen extends GetView<LeaveController> {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          titleSpacing: 0,
          title: Text(
            'Leave Application',
            style: GoogleFonts.firaSans(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text('Leave Apply'),
              ),
              Tab(
                child: Text('Your Leaves'),
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            Image.asset(
              "assets/background.png",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            TabBarView(
              children: [
                LeaveApplyWidget(
                  leaveController: controller,
                ),
                YourLeaves(
                  leaveController: controller,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

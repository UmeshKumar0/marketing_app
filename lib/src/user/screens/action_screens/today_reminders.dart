import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/user/controller/reminder_controller.dart';
import 'package:marketing/src/user/widgets/reminders.dart';

class TodayReminders extends StatelessWidget {
  const TodayReminders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Today Reminders',
          style: GoogleFonts.firaSans(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Column(
        children: [
          RemindersScreen(
            point: 'reminderDate',
            value: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ).toString(),
            reminderController: Get.find<ReminderController>(),
          ),
        ],
      ),
    );
  }
}

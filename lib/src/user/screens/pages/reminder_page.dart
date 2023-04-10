// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/user/controller/reminder_controller.dart';
import 'package:marketing/src/user/widgets/reminders.dart';

class MorePage extends StatelessWidget {
  MorePage({
    Key? key,
    required this.reminderController,
  }) : super(key: key);
  ReminderController reminderController;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          alignment: Alignment.centerLeft,
          color: Colors.white,
          child: Row(
            children: [
              Icon(
                Icons.calendar_month,
                size: 20,
                color: Colors.red.withOpacity(0.7),
              ),
              const SizedBox(
                width: 5,
              ),
              Obx(() {
                return Text(
                  reminderController.reminderDate.value,
                  style: GoogleFonts.firaSans(
                    fontWeight: FontWeight.w500,
                  ),
                );
              })
            ],
          ),
        ),
        RemindersScreen(
          point: 'reminderDate',
          value: reminderController.reminderDate.value,
          reminderController: reminderController,
        ),
        const SizedBox(
          height: 70,
        )
      ],
    );
  }
}

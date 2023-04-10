// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/user/controller/reminder_controller.dart';
import 'package:marketing/src/user/widgets/customButton.dart';

class ReminderBottomSheet extends StatelessWidget {
  ReminderBottomSheet({
    Key? key,
    required this.reminderController,
  }) : super(key: key);
  ReminderController reminderController;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reminders Filter',
                  style: GoogleFonts.firaSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomButton(
                  color: Colors.black,
                  text: 'From ${reminderController.reminderDate.value}',
                  onTap: () async {
                    await reminderController.setStartDate(context: context);
                  },
                ),
              ],
            ),
          ),
          CustomButton(
            onTap: () {
              reminderController.getReminders(
                key: 'reminderDate',
                value: reminderController.reminderDate.value,
              );
              Get.back();
            },
            text: "Filter",
            color: Colors.blue.withOpacity(0.8),
          )
        ],
      ),
    );
  }
}

// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/reminder_controller.dart';
import 'package:marketing/src/user/models/reminder_model.dart';
import 'package:marketing/src/user/widgets/reminderDetails.dart';

class ReminderItem extends StatefulWidget {
  ReminderItem({
    Key? key,
    required this.reminders,
    required this.reminderController,
    required this.point,
    required this.value,
  }) : super(key: key);
  Reminders reminders;
  ReminderController reminderController;
  String point;
  String value;
  @override
  State<ReminderItem> createState() => _ReminderItemState();
}

class _ReminderItemState extends State<ReminderItem> {
  bool selected = false;

  setSelected() {
    setState(() {
      selected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      child: ListTile(
        onTap: () {
          setState(() {
            selected = !selected;
          });
          if (selected) {
            Get.bottomSheet(
              BottomSheet(
                onClosing: () {
                  setState(() {
                    selected = false;
                  });
                },
                builder: (context) {
                  return ReminderDetails(
                    point: widget.point,
                    value: widget.value,
                    reminderController: widget.reminderController,
                    setSelected: setSelected,
                    reminder: widget.reminders,
                  );
                },
              ),
              elevation: 10,
              isDismissible: false,
            );
          }
        },
        tileColor: selected ? Colors.blue.withOpacity(0.7) : Colors.white,
        leading: Icon(
          Icons.timer,
          color: selected ? Colors.white : AppConfig.primaryColor7,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.reminders.date?.split('T')[0] as String,
              style: GoogleFonts.firaSans(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: selected ? Colors.white : Colors.black,
              ),
            ),
            Chip(
              label: Text(
                widget.reminders.status as String,
                style: GoogleFonts.firaSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              backgroundColor: widget.reminders.status == 'PENDING'
                  ? Colors.red.withOpacity(0.7)
                  : AppConfig.primaryColor7,
            ),
          ],
        ),
        subtitle: Text(
          widget.reminders.remarks!.length > 35
              ? '${widget.reminders.remarks!.substring(0, 35)}...'
              : widget.reminders.remarks as String,
          style: GoogleFonts.firaSans(
            fontWeight: FontWeight.w400,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

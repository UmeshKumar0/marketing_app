import 'package:flutter/material.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/reminder_controller.dart';
import 'package:marketing/src/user/widgets/reminder_bottom_sheet.dart';

class VisitActionIcon extends StatelessWidget {
  VisitActionIcon({
    super.key,
    required this.reminderController,
  });
  ReminderController reminderController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: IconButton(
        onPressed: () {
          showModalBottomSheet(
            enableDrag: true,
            context: context,
            builder: (context) => BottomSheet(
              builder: (context) {
                return ReminderBottomSheet(
                  reminderController: reminderController,
                );
              },
              onClosing: () {},
            ),
          );
        },
        icon: Icon(
          Icons.filter_alt_outlined,
          color: AppConfig.primaryColor7,
        ),
      ),
    );
  }
}

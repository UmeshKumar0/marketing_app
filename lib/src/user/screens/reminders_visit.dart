import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/user/controller/reminder_controller.dart';
import 'package:marketing/src/user/models/visit_model.dart';
import 'package:marketing/src/user/widgets/reminders.dart';

class ReminderByVisit extends StatelessWidget {
  const ReminderByVisit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VisitModel visitModel =
        ModalRoute.of(context)!.settings.arguments as VisitModel;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        titleSpacing: 2,
        title: Text(
          'Reminders By Visit',
          style: GoogleFonts.firaSans(
            color: Colors.black.withOpacity(0.7),
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: Colors.blue.withOpacity(0.7),
            ),
            alignment: Alignment.center,
            child: Text(
              'All Reminders of Visit ${visitModel.shop != null ? visitModel.shop!.name : visitModel.name}',
              style: GoogleFonts.firaSans(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          RemindersScreen(
            point: 'visitId',
            value: visitModel.sId as String,
            reminderController: Get.find<ReminderController>(),
          ),
        ],
      ),
    );
  }
}

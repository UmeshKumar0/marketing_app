import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/user/controller/reminder_controller.dart';
import 'package:marketing/src/user/models/shop_model.dart';
import 'package:marketing/src/user/widgets/reminders.dart';

class ShopRemindersScreen extends StatelessWidget {
  const ShopRemindersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Shops shops = ModalRoute.of(context)!.settings.arguments as Shops;
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          'Reminders By Shop',
          style: GoogleFonts.firaSans(
            fontWeight: FontWeight.w400,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        titleSpacing: 2,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black.withOpacity(0.7),
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
              'All Reminders of shop ${shops.name}',
              style: GoogleFonts.firaSans(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          RemindersScreen(
            point: 'shopId',
            value: shops.sId as String,
            reminderController: Get.find<ReminderController>(),
          ),
        ],
      ),
    );
  }
}

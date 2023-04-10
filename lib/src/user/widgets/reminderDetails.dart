// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/reminder_controller.dart';
import 'package:marketing/src/user/models/reminder_model.dart';
import 'package:marketing/src/user/models/shop_model.dart';
import 'package:marketing/src/user/widgets/customButton.dart';

class ReminderDetails extends StatefulWidget {
  ReminderDetails({
    Key? key,
    required this.setSelected,
    required this.reminder,
    required this.reminderController,
    required this.point,
    required this.value,
  }) : super(key: key);

  Function setSelected;
  Reminders reminder;
  String point;
  String value;
  ReminderController reminderController;

  @override
  State<ReminderDetails> createState() => _ReminderDetailsState();
}

class _ReminderDetailsState extends State<ReminderDetails> {
  bool loadingShop = false;
  bool isError = false;
  String errorMessage = '';

  fetchShop({
    required String id,
  }) async {
    try {
      setState(() {
        loadingShop = true;
      });
      Shops shops = await widget.reminderController.apiController.getShopById(
        id: id,
        online: Get.find<CloudController>().alive.value,
      );
      setState(() {
        loadingShop = false;
      });
      return shops;
    } on HttpException catch (e) {
      setState(() {
        isError = true;
        errorMessage = e.message;
      });
    } catch (err) {
      setState(() {
        isError = true;
        errorMessage = err.toString();
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reminder Detail',
                    style: GoogleFonts.firaSans(
                      fontSize: 20,
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.setSelected();
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
            widget.reminder.shop != null
                ? ListTile(
                    onTap: () async {
                      Shops? shops = await fetchShop(
                          id: widget.reminder.shop!.sId as String);
                      if (shops != null) {
                        Get.toNamed(
                          AppConfig.SHOP_PREVIEW,
                          arguments: shops,
                        );
                      }
                    },
                    focusColor: Colors.indigo,
                    leading: Image.asset(
                      "assets/createShop.png",
                      height: 50,
                      width: 50,
                    ),
                    title: Text(
                      '${widget.reminder.shop!.name}',
                      style: GoogleFonts.firaSans(
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      loadingShop == true
                          ? 'Loading...'
                          : isError == true
                              ? errorMessage
                              : 'View Shop Detail',
                      style: GoogleFonts.firaSans(
                        color: Colors.green,
                      ),
                    ),
                  )
                : ListTile(
                    leading: Icon(
                      Icons.timer,
                      color: Colors.red.withOpacity(0.7),
                    ),
                    title: Text(
                      'Reminder By Visit',
                      style: GoogleFonts.firaSans(
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
            ListTile(
              leading: Icon(
                Icons.lock_clock,
                color: Colors.red.withOpacity(0.7),
              ),
              title: Text(
                'Date',
                style: GoogleFonts.firaSans(
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
              subtitle: Text(
                widget.reminder.date!.split('T')[0],
                style: GoogleFonts.firaSans(),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (contex) {
                    return AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reminder Remark',
                            style: GoogleFonts.firaSans(),
                          ),
                          IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Colors.red.withOpacity(0.7),
                            ),
                          )
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                widget.reminder.remarks as String,
                                style: GoogleFonts.firaSans(
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          )
                        ],
                      ),
                      actions: const [],
                    );
                  },
                );
              },
              leading: Icon(
                Icons.message,
                color: Colors.red.withOpacity(0.7),
              ),
              title: Text(
                'Remarks',
                style: GoogleFonts.firaSans(
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
              subtitle: Text(
                'Tap here to view remarks',
                style: GoogleFonts.firaSans(color: Colors.green),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.category,
                color: Colors.red.withOpacity(0.7),
              ),
              title: Text(
                'Status',
                style: GoogleFonts.firaSans(
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
              subtitle: Text(
                widget.reminder.status as String,
                style: GoogleFonts.firaSans(),
              ),
            ),
            widget.reminder.status == 'PENDING'
                ? Obx(() {
                    return widget.reminderController.isupdatingReminder.isTrue
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox(
                            height: 80,
                            child: CustomButton(
                              onTap: () async {
                                await widget.reminderController
                                    .completedReminder(
                                  key: widget.point,
                                  value: widget.value,
                                  remId: widget.reminder.sId as String,
                                );
                                Get.back();
                              },
                              text: "Mark As Completed",
                              color: Colors.blue.withOpacity(0.7),
                            ),
                          );
                  })
                : Container(
                    alignment: Alignment.center,
                    child: Text(
                      'This Reminder is completed',
                      style: GoogleFonts.firaSans(
                        fontSize: 15,
                        color: Colors.blue.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

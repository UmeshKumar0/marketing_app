// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:marketing/src/user/models/create_reminder.dart';
import 'package:marketing/src/user/models/create_visit.dart';
import 'package:marketing/src/user/models/meetings/meeting_model.dart';
import 'package:marketing/src/user/widgets/reload_widget.dart';
import 'package:workmanager/workmanager.dart';

class LocalDatabase extends GetView<StorageController> {
  const LocalDatabase({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Local Database",
            style: GoogleFonts.firaSans(
                fontWeight: FontWeight.w400, color: Colors.black),
          ),
          actions: const [
            DatabaseSync(),
          ],
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Shops",
              ),
              Tab(
                text: "Visits",
              ),
              Tab(
                text: "Image",
              ),
              Tab(
                text: "Reminders",
              ),
              Tab(
                text: 'Meetings',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ValueListenableBuilder(
              valueListenable: controller.shopCreateBox.listenable(),
              builder: (context, value, child) {
                return controller.shopCreateBox.isEmpty
                    ? const Center(
                        child: Text("No Shops found in local database"),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              controller.shopCreateBox.values
                                  .elementAt(index)
                                  .name
                                  .toString(),
                              style: GoogleFonts.firaSans(),
                            ),
                          );
                        },
                        itemCount: controller.shopCreateBox.length,
                      );
              },
            ),
            ValueListenableBuilder(
              valueListenable: controller.createVisitBox.listenable(),
              builder: (context, value, child) {
                return controller.createVisitBox.isEmpty
                    ? const Center(
                        child: Text("No Visits found in local database"),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          CreateVisit createVisit =
                              controller.createVisitBox.values.elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              tileColor: Colors.white,
                              leading: Icon(
                                Icons.paste,
                                color: AppConfig.primaryColor7,
                              ),
                              title: Text(
                                "Shop: ${createVisit.shop.toString()}",
                                style: GoogleFonts.firaSans(),
                              ),
                              subtitle: Text(
                                "Reminder status: - ${createVisit.createReminder != null ? "True" : "False"}",
                                style: GoogleFonts.firaSans(
                                  color: createVisit.createReminder != null
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: controller.createVisitBox.length,
                      );
              },
            ),
            ValueListenableBuilder(
              valueListenable: controller.imageModelBox.listenable(),
              builder: (context, value, child) {
                return controller.imageModelBox.isEmpty
                    ? const Center(
                        child: Text("No images found in local database"),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              tileColor: Colors.white,
                              title: Text(
                                controller.imageModelBox.values
                                    .elementAt(index)
                                    .syncId
                                    .toString(),
                                style: GoogleFonts.firaSans(),
                              ),
                              subtitle: Text(
                                controller.imageModelBox.values
                                            .elementAt(index)
                                            .visitId !=
                                        null
                                    ? "Visit Image"
                                    : "Shop Image",
                                style: GoogleFonts.firaSans(
                                  color: Colors.pinkAccent,
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: controller.imageModelBox.length,
                      );
              },
            ),
            ValueListenableBuilder(
              valueListenable: controller.createReminderBox.listenable(),
              builder: (context, value, child) {
                return controller.createReminderBox.isEmpty
                    ? const Center(
                        child: Text("No images found in local database"),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          CreateReminder createReminder = controller
                              .createReminderBox.values
                              .elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              tileColor: Colors.white,
                              title: Text(
                                createReminder.date.toString(),
                                style:
                                    GoogleFonts.firaSans(color: Colors.black),
                              ),
                              subtitle: Text(
                                controller.createReminderBox.values
                                            .elementAt(index)
                                            .shop !=
                                        null
                                    ? "Shop visit: ${createReminder.shop}"
                                    : "visit: ${createReminder.visit}",
                                style: GoogleFonts.firaSans(
                                  color: Colors.pinkAccent,
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: controller.createReminderBox.length,
                      );
              },
            ),
            ValueListenableBuilder(
              valueListenable: controller.meetingModelBox.listenable(),
              builder: (context, value, child) {
                return controller.meetingModelBox.isEmpty
                    ? const Center(
                        child: Text("No Meetings found in local database"),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          MeetingModel meeting = controller
                              .meetingModelBox.values
                              .elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              tileColor: Colors.white,
                              title: Text(
                                meeting.syncId.toString(),
                                style:
                                    GoogleFonts.firaSans(color: Colors.black),
                              ),
                              subtitle: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      "${meeting.requestedUser}",
                                      style: GoogleFonts.firaSans(
                                        color: Colors.pinkAccent,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    "Synced: ${meeting.synced}",
                                    style: GoogleFonts.firaSans(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: controller.meetingModelBox.length,
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketing/src/user/controller/reminder_controller.dart';
import 'package:marketing/src/user/widgets/error_widget.dart';
import 'package:marketing/src/user/widgets/reminderItem.dart';

class RemindersScreen extends StatefulWidget {
  RemindersScreen({
    Key? key,
    required this.point,
    required this.value,
    required this.reminderController,
  }) : super(key: key);
  String point;
  String value;
  ReminderController reminderController;
  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  @override
  void initState() {
    super.initState();
    fetchReminder();
  }

  fetchReminder() async {
    await widget.reminderController.getReminders(
      key: widget.point,
      value: widget.point == 'reminderDate'
          ? widget.reminderController.reminderDate.value
          : widget.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Expanded(
        child: widget.reminderController.isLoading.isTrue
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : widget.reminderController.isError.isTrue
                ? CustomErrorWidget(
                    errorMessage: widget.reminderController.errorMessage.value,
                    buttonText: 'Retry',
                    loggedOut: false,
                    cb: () {
                      fetchReminder();
                    },
                  )
                : widget.reminderController.isLoggedOut.isTrue
                    ? CustomErrorWidget(
                        errorMessage:
                            'You are logged out or your session has expired please login again',
                        buttonText: 'Login Again',
                        loggedOut: true,
                        cb: () {},
                      )
                    : widget.reminderController.reminders.isEmpty
                        ? CustomErrorWidget(
                            errorMessage: 'No reminders found ',
                            buttonText: 'Retry',
                            loggedOut: false,
                            cb: () {
                              fetchReminder();
                            },
                          )
                        : RefreshIndicator(
                            child: ListView.builder(
                              physics: const ScrollPhysics(
                                  parent: BouncingScrollPhysics()),
                              itemBuilder: (context, item) {
                                return ReminderItem(
                                  point: widget.point,
                                  value: widget.value,
                                  reminderController: widget.reminderController,
                                  reminders:
                                      widget.reminderController.reminders[item],
                                );
                              },
                              itemCount:
                                  widget.reminderController.reminders.length,
                            ),
                            onRefresh: () => Future.sync(
                              () => fetchReminder(),
                            ),
                          ),
      );
    });
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/models/create_reminder.dart';
import 'package:marketing/src/user/models/reminder_model.dart';

class ReminderController extends GetxController {
  late ApiController _apiController;
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxString errorMessage = ''.obs;
  RxList reminders = [].obs;
  RxBool isLoggedOut = false.obs;
  RxBool isupdatingReminder = false.obs;
  RxString reminderDate = DateTime.now().toString().split(' ')[0].obs;

  TextEditingController remarkController = TextEditingController();
  RxBool createReminderLoading = false.obs;
  RxString createReminderDate = 'N/A'.obs;

  ApiController get apiController => _apiController;

  ReminderController() {
    _apiController = Get.find<ApiController>();
  }

  getReminders({
    required String key,
    required String value,
  }) async {
    try {
      isLoading.value = true;
      List<Reminders> reminder = await _apiController.getReminders(
        key: key,
        value: value,
        online: Get.find<CloudController>().alive.value,
      );

      isLoading.value = false;
      reminders.value = reminder;
    } on HttpException catch (e) {
      if (e.message == "TOKEN_EXPIRED") {
        isLoading.value = false;
        errorMessage.value = e.message;
        isLoggedOut.value = true;
      } else {
        errorMessage.value = e.message;
        isLoading.value = false;
        isError.value = true;
      }
    } catch (err) {
      errorMessage.value = err.toString();
      isLoading.value = false;
      isError.value = true;
    }
  }

  setStartDate({
    required BuildContext context,
  }) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2008),
      lastDate: DateTime(2030, 12, 31),
    );

    if (picked != null) {
      reminderDate.value = picked.toString().split(' ')[0];
    }
  }

  getStartDate({
    required BuildContext context,
  }) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      createReminderDate.value = picked.toString().split(' ')[0];
    }
  }

  clearReminderCreateDate() {
    createReminderDate.value = 'N/A';
  }

  createReminder({
    required BuildContext context,
    String? shop,
    required String visit,
  }) async {
    try {
      if (remarkController.text.isNotEmpty &&
          createReminderDate.value != 'N/A') {
        createReminderLoading.value = true;
        await _apiController.createReminderInLocal(
          createReminder: CreateReminder(
            syncId:
                '${_apiController.storageController.userModel.value.user!.sId}/reminder/${DateTime.now().millisecondsSinceEpoch.toString()}',
            date: createReminderDate.value,
            remarks: remarkController.text,
            shop: shop,
            visit: visit,
          ),
        );

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Success',
                style: GoogleFonts.firaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.blue.withOpacity(0.7)),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Reminder created successfully',
                      style: GoogleFonts.firaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue.withOpacity(0.7),
                      ),
                    ),
                  )
                ],
              ),
              actions: [
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.red.withOpacity(0.7),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'Close',
                    style: GoogleFonts.firaSans(color: Colors.white),
                  ),
                ),
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.blue.withOpacity(0.7),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'Create Another',
                    style: GoogleFonts.firaSans(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );

        createReminderLoading.value = false;
        remarkController.clear();
        clearReminderCreateDate();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please fill all the fields',
              style: GoogleFonts.firaSans(color: Colors.white),
            ),
            backgroundColor: Colors.red.withOpacity(0.7),
          ),
        );
      }
    } on HttpException catch (e) {
      createReminderLoading.value = false;
      showError(
          context: context, errorMessage: e.message, shop: shop, visit: visit);
    } catch (e) {
      createReminderLoading.value = false;
      showError(
        context: context,
        errorMessage: e.toString(),
        shop: shop,
        visit: visit,
      );
    }
  }

  showError(
      {required BuildContext context,
      required String errorMessage,
      String? shop,
      required String visit}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Error',
            style: GoogleFonts.firaSans(
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/error.png',
                  height: 100,
                  width: 100,
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Something went wrong. Please try again later.',
                  style: GoogleFonts.firaSans(
                    color: Colors.black.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.red.withOpacity(0.7),
                ),
              ),
              onPressed: () {
                Get.back();
              },
              child: Text(
                'Close',
                style: GoogleFonts.firaSans(color: Colors.white),
              ),
            ),
            OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.blue.withOpacity(0.7),
                ),
              ),
              onPressed: () {
                createReminder(context: context, shop: shop, visit: visit);
                Get.back();
              },
              child: Text(
                'Retry',
                style: GoogleFonts.firaSans(color: Colors.white),
              ),
            )
          ],
        );
      },
    );
  }

  Future completedReminder(
      {required String remId,
      required String key,
      required String value}) async {
    try {
      isupdatingReminder.value = true;
      await _apiController.changeReminderStatus(remId: remId);
      isupdatingReminder.value = false;
      Fluttertoast.showToast(msg: 'Reminder completed');
      await getReminders(
        key: key,
        value: value,
      );
    } on HttpException catch (e) {
      isupdatingReminder.value = false;
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      isupdatingReminder.value = false;
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}

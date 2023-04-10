// ignore_for_file: unused_catch_clause

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:get/get.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:marketing/src/user/models/meetings/meeting_model.dart';
import 'package:marketing/src/user/models/meetings/meeting_user.dart';
import 'package:marketing/src/user/models/shop_model.dart';

class MeetingsController extends GetxController {
  RxString endDate = DateTime.now().add(const Duration(days: 7)).toString().obs;
  RxString startDate = DateTime.now().toString().obs;

  RxBool userLoading = false.obs;

  final ApiController _apiController = Get.find<ApiController>();
  final CloudController _cloudController = Get.find<CloudController>();
  final StorageController _storageController = Get.find<StorageController>();
  ApiController get apiController => _apiController;
  CloudController get cloudController => _cloudController;
  StorageController get storageController => _storageController;
  RxList days = [].obs;
  RxList fetchedShops = [].obs;
  RxList fetchShopWithInput = [].obs;
  RxBool fetchShop = false.obs;
  RxBool shopLoadingWithInput = false.obs;
  late Shops shops;
  RxBool shopSelected = false.obs;
  RxBool userSelected = false.obs;
  MeetingUser? user;
  Timer? _timer;

  /* 
    Only used in meeting create screen 
  */
  RxBool creatingMeeting = false.obs;
  RxString meetingDate = "N/A".obs;
  TextEditingController strength = TextEditingController();
  RxString food = "SELECT FOOD".obs;
  TextEditingController remark = TextEditingController();
  TextEditingController gift = TextEditingController();

  onInit() {
    super.onInit();

    getMeetingUsers();
  }

  MeetingsController() {
    days.value = getDaysInBetween(
        DateTime.parse(startDate.value), DateTime.parse(endDate.value));
  }

  setUser({required MeetingUser user}) {
    this.user = user;
    userSelected.value = true;
  }

  unSetUser() {
    userSelected.value = false;
  }

  List<String> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<String> days = [];
    for (int i = 0; i < endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)).toString().split(' ').first);
    }
    return days;
  }

  unsetDate() {
    meetingDate.value = "N/A";
  }

  setMeetingDate() async {
    final DateTime? picked = await showDatePicker(
        context: Get.context!,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      meetingDate.value = picked.toString().split(' ').first;
    }
  }

  prevDate() async {
    endDate.value = DateTime.parse(startDate.value).toString();
    startDate.value = DateTime.parse(startDate.value)
        .add(const Duration(days: -7))
        .toString();

    days.value = getDaysInBetween(
        DateTime.parse(startDate.value), DateTime.parse(endDate.value));
    await getMeetingUsers();
  }

  nextDate() async {
    startDate.value = DateTime.parse(endDate.value).toString();
    endDate.value =
        DateTime.parse(endDate.value).add(const Duration(days: 7)).toString();
    days.value = getDaysInBetween(
        DateTime.parse(startDate.value), DateTime.parse(endDate.value));
    await getMeetingUsers();
  }

  setShop({required Shops shops}) {
    this.shops = shops;
    shopSelected.value = true;
  }

  unSetShop() {
    shopSelected.value = false;
  }

  fetchShopWithCpCode({required String cpCode}) async {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _timer = Timer(const Duration(seconds: 2), () async {
        if (cpCode.isNotEmpty) {
          shopLoadingWithInput.value = true;
        } else {
          fetchShop.value = true;
        }
        try {
          fetchedShops.value = [];
          fetchShopWithInput.value = [];
          List shops = await _apiController.getShops(
            skip: "0",
            limit: "50",
            name: cpCode,
            online: _cloudController.alive.value,
          );

          if (cpCode.isNotEmpty) {
            fetchShopWithInput.value = shops;
            shopLoadingWithInput.value = false;
          } else {
            fetchShop.value = false;
            fetchedShops.value = shops;
          }
        } on HttpException catch (e) {
          if (cpCode.isNotEmpty) {
            shopLoadingWithInput.value = false;
          } else {
            fetchShop.value = false;
          }
        } catch (e) {
          if (cpCode.isNotEmpty) {
            shopLoadingWithInput.value = false;
          } else {
            fetchShop.value = false;
          }
        }
      });
    } else {
      _timer = Timer(const Duration(milliseconds: 500), () async {
        if (cpCode.isNotEmpty) {
          shopLoadingWithInput.value = true;
        } else {
          fetchShop.value = true;
        }
        try {
          fetchedShops.value = [];
          fetchShopWithInput.value = [];
          List shops = await _apiController.getShops(
            skip: "0",
            limit: "50",
            name: cpCode,
            online: _cloudController.alive.value,
          );
          if (cpCode.isNotEmpty) {
            fetchShopWithInput.value = shops;
            shopLoadingWithInput.value = false;
          } else {
            fetchShop.value = false;
            fetchedShops.value = shops;
          }
        } on HttpException catch (e) {
          if (cpCode.isNotEmpty) {
            shopLoadingWithInput.value = false;
          } else {
            fetchShop.value = false;
          }
        } catch (e) {
          if (cpCode.isNotEmpty) {
            shopLoadingWithInput.value = false;
          } else {
            fetchShop.value = false;
          }
        }
      });
    }
  }

  validateFields() {
    if (meetingDate.value == "N/A") {
      Get.snackbar("Error", "Please select a date");
      return false;
    }
    if (strength.text.isEmpty) {
      Get.snackbar("Error", "Please enter strength");
      return false;
    }
    if (food.isEmpty || food.value == "SELECT FOOD") {
      Get.snackbar("Error", "Please enter food");
      return false;
    }
    if (shopSelected.isFalse) {
      Get.snackbar("Error", "Please select a shop");
      return false;
    }
    if (userSelected.isFalse) {
      Get.snackbar("Error", "Please select a user");
      return false;
    }
    return true;
  }

  createMeeting({required Function callBack}) async {
    try {
      if (validateFields()) {
        if (user != null) {
          MeetingModel m = MeetingModel(
            date: DateTime.parse(meetingDate.value).millisecondsSinceEpoch,
            food: food.value,
            strength: int.parse(strength.text),
            remarks: remark.text,
            gift: gift.text,
            shop: MeetingShop(
              sId: shops.sId,
              name: shops.name,
              email: shops.email,
              phone: shops.phone,
            ),
            requestedUser: user != null ? user!.sId : "",
            status: 'PENDING',
            synced: false,
            user: storageController.userModel.value.user!.sId,
            syncId:
                '${storageController.userModel.value.user!.sId}-${DateTime.now().millisecondsSinceEpoch}',
          );
          await _apiController.createMeetingInLocalDatabase(meeting: m);
          callBack();
        } else {
          Get.snackbar("Error", "Please select a user");
        }
      }
    } catch (e) {
      Get.dialog(AlertDialog(
        title: const Text('Error'),
        content: e.toString().contains('FormatException')
            ? const Text('Please enter valid data')
            : Text(e.toString()),
      ));
    }
  }

  Future getMeetingUsers() async {
    userLoading.value = true;
    print('Cmmming here');
    try {
      await _apiController.getMeetingUsers(
        startDate: DateTime.parse(startDate.value.split(' ').first)
            .millisecondsSinceEpoch
            .toString(),
        endDate: DateTime.parse(endDate.value.split(' ').first)
            .millisecondsSinceEpoch
            .toString(),
      );
      userLoading.value = false;
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      Get.dialog(
        AlertDialog(
          title: Text("Error", style: GoogleFonts.firaSans()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  e.toString(),
                  style: GoogleFonts.firaSans(),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "Ok",
                style: GoogleFonts.firaSans(),
              ),
            )
          ],
        ),
      );
      userLoading.value = false;
    }
  }
}

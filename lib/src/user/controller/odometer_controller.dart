import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/controller/home_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:marketing/src/user/models/LatLon.dart';
import 'package:marketing/src/user/models/create_odometer.dart';
import 'package:marketing/src/user/models/odometers.dart';

class OdometerController extends GetxController {
  RxString imagePath = 'N/A'.obs;
  Uint8List uint8list = Uint8List(0);
  RxString mapAddress = 'N/A'.obs;
  RxBool locationLoading = false.obs;
  Rx<LatLong> latLong = LatLong(latitude: 0.00, longitude: 0.00).obs;
  final TextEditingController readingConroller = TextEditingController();
  RxBool attendanceCreating = false.obs;

  RxList<Odometers> odoMeters = <Odometers>[].obs;
  RxBool isLoading = false.obs;

  RxBool absentCompleted = false.obs;
  RxString absentMessage = 'Are you sure about it ?'.obs;
  Timer? _timer;
  RxBool workingProcess = false.obs;

  late StorageController _storageController;
  late CloudController _cloudController;

  OdometerController() {
    _storageController = Get.find<StorageController>();
    _cloudController = Get.find<CloudController>();
    getAddress();
  }

  Future<void> setImage({required String path}) async {
    imagePath.value = path;
  }

  void clearImage() {
    imagePath.value = 'N/A';
  }

  getAddress() async {
    locationLoading.value = true;
    try {
      Position addresses = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      mapAddress.value = await _storageController.getAddress(
        latLong: LatLong(
          longitude: addresses.longitude,
          latitude: addresses.latitude,
        ),
      ) as String;
      latLong.value = LatLong(
        longitude: addresses.longitude,
        latitude: addresses.latitude,
      );
    } catch (e) {
      mapAddress.value = e.toString();
    }
    locationLoading.value = false;
  }

  loadAttendance() async {
    HomeController homeController = Get.find<HomeController>();
    await homeController.getAttendance(
      months: DateTime.now().month.toString(),
      years: DateTime.now().year.toString(),
    );
  }

  void markAbsent() async {
    attendanceCreating.value = true;
    await getAddress();
    try {
      _storageController.addDataToOdoMeter(
        createOdometerModel: CreateOdometerModel(
          isAbsent: true,
          address: '',
          coordinate: LatLong(latitude: 0.00, longitude: 0.00),
          completed: true,
          imgPath: '',
          reading: '',
          time: DateTime.now().toString(),
        ),
      );
      _storageController.setOdometerStatus(AppConfig.ABSENT);
      FlutterBackgroundService().invoke('sync');
      Fluttertoast.showToast(msg: 'Your attendance has been marked absent');
      absentMessage.value = "You have marked absent for today's attendance";
      attendanceCreating.value = false;
      absentCompleted.value = true;
    } on HttpException catch (e) {
      attendanceCreating.value = false;
      absentMessage.value = e.message;
    } catch (e) {
      attendanceCreating.value = false;
      absentMessage.value = e.toString();
    }

    if (_timer == null) {
      _timer = Timer(const Duration(seconds: 5), () {
        absentMessage.value = "Are you sure about it ?";
      });
    } else {
      _timer!.cancel();
      _timer = Timer(const Duration(seconds: 5), () {
        absentMessage.value = "Are you sure about it ?";
      });
    }
  }

  Future markPresent({
    required BuildContext context,
    required bool completed,
  }) async {
    await getAddress();
    if (readingConroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: _storageController.odoMeter.value == AppConfig.PRESENT
            ? 'Please enter end reading of your odometer'
            : 'Please enter start reading of your odometer',
      );
      return false;
    } else if (readingConroller.text.contains('-') ||
        readingConroller.text.contains(' ')) {
      Fluttertoast.showToast(
        msg: '- and white spaces are not allowed please enter valid reading.',
      );
      return false;
    } else if (imagePath.value == "N/A") {
      Fluttertoast.showToast(
        msg: 'Please take a picture of your odometer',
      );

      return false;
    } else {
      if (_cloudController.alive.isTrue) {
        attendanceCreating.value = true;
        workingProcess.value = true;
        try {
          await _cloudController.apiController.createattendance(
            startReading: readingConroller.text,
            startCoordinate: latLong.value,
            imagePath: imagePath.value,
            date: DateTime.now().millisecondsSinceEpoch.toString(),
            completed: completed,
            time: DateTime.now().millisecondsSinceEpoch.toString(),
          );
          if (completed == false) {
            FlutterBackgroundService().startService();
            FlutterBackgroundService().invoke('setAsBackground');
          } else {
            FlutterBackgroundService().invoke('stopService');
          }
          attendanceCreating.value = false;
          workingProcess.value = false;
          Fluttertoast.showToast(msg: 'Your attendance has been marked');
          return true;
        } on HttpException catch (e) {
          Fluttertoast.showToast(msg: e.message);
          attendanceCreating.value = false;
          workingProcess.value = false;
          Fluttertoast.showToast(msg: e.message);
        } catch (e) {
          attendanceCreating.value = false;
          workingProcess.value = false;
          Fluttertoast.showToast(msg: e.toString());
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Please make sure you are connected to internet',
        );
        return false;
      }
    }
  }
}

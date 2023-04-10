import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/maps_controller.dart';
import 'package:marketing/src/user/controller/reminder_controller.dart';
import 'package:marketing/src/user/controller/shop_controller.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:marketing/src/user/controller/visit_controller.dart';
import 'package:marketing/src/user/models/attendanceData.dart';
import 'package:marketing/src/user/models/deviceInfo.dart';

class HomeController extends GetxController {
  late MapsController _mapsController;
  late ShopController _shopController;
  late ReminderController _reminderController;
  late VisitController _visitController;
  late ApiController _apiController;
  late StorageController _storageController;
  StorageController get storageControler => _storageController;
  MapsController get mapsController => _mapsController;
  ShopController get shopController => _shopController;
  ReminderController get reminderController => _reminderController;
  VisitController get visitController => _visitController;
  ApiController get apiController => _apiController;
  RxInt currentIndex = 2.obs;
  RxInt targetIndex = 2.obs;
  RxBool isPostView = false.obs;
 RxList<DateTime> blackoutDates =  <DateTime>[].obs;
  RxMap attendance = {}.obs;
  RxString distance = ''.obs;
  RxBool loadingAttendance = false.obs;
  RxBool isErrorLoadingAttendance = false.obs;
  String errorMessage = '';

  PageController pageController = PageController(initialPage: 2);

  @override
  void onInit() {
    super.onInit();
    _storageController = Get.find<StorageController>();
    _mapsController = Get.find<MapsController>();
    _shopController = Get.find<ShopController>();
    _reminderController = Get.find<ReminderController>();
    _visitController = Get.find<VisitController>();
    _apiController = Get.find<ApiController>();
    _mapsController.init();
    getAttendance(
      months: DateTime.now().month.toString(),
      years: DateTime.now().year.toString(),
    );
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      sendToServer(token, _storageController.userModel.value.user!.sId);
    });

    print(_storageController.userModel.value.token);
  }

  sendToServer(String? token, String? userId) async {
    if (userId != null) {
      MyDeviceInfo? deviceInfo = await _storageController.getMyDeviceInfo();
      deviceInfo!.userId = userId;
      if (deviceInfo != null) {
        print('seeting up device token and info to server');
        await _apiController.registerDevice(myDeviceInfo: deviceInfo);
      }
    }
  }

  getAttendance({
    required String months,
    required String years,
  }) async {
    try {
      loadingAttendance.value = true;
      AttendanceData? attendanceData = await _apiController.getAttendance(
        month: months,
        year: years,
        online: Get.find<CloudController>().alive.value,
      );
      attendance.value = attendanceData.data;
      distance.value = attendanceData.distance;
      isErrorLoadingAttendance.value = false;
      loadingAttendance.value = false;
    } on HttpException catch (e) {
      errorMessage = e.message;
      loadingAttendance.value = false;
      isErrorLoadingAttendance.value = true;
    } catch (e) {
      errorMessage = e.toString();
      loadingAttendance.value = false;
      isErrorLoadingAttendance.value = true;
    }
  }

  changePage({required int value}) {
    currentIndex.value = value;
    pageController.animateToPage(value,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  changetargetIndex({required int value}) {
    targetIndex.value = value;
    currentIndex.value = value;
    pageController.animateToPage(
      currentIndex.value,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }

  changeVisitView() async {
    isPostView.value = await _visitController.changeView();
  }
}

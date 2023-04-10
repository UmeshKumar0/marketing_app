// ignore_for_file: invalid_use_of_protected_member, unrelated_type_equality_checks

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/settings_controller.dart';
import 'package:marketing/src/user/models/create_reminder.dart';
import 'package:marketing/src/user/models/create_visit.dart';
import 'package:marketing/src/user/models/shop_model.dart';
import 'package:marketing/src/user/models/types.dart';
import 'package:marketing/src/user/models/visit_model.dart';

class VisitController extends GetxController {
  late ApiController _apiController;
  RxList visits = [].obs;
  RxString from =
      DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch)
          .toString()
          .split(' ')[0]
          .obs;
  RxString to = DateTime.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch + 1000 * 24 * 60 * 60)
      .toString()
      .split(' ')[0]
      .obs;

  ApiController get apiController => _apiController;
  TextEditingController remarkController = TextEditingController();
  late CloudController _cloudController;
  late SettingController _settingController;

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxBool isLoggedOut = false.obs;
  String errorMessage = '';
  RxBool isPostView = false.obs;
  RxBool instantCreate = false.obs;
  RxList nearbyShops = [].obs;
  RxBool loadingNearByShops = false.obs;
  RxBool loadingType = false.obs;
  RxList types = [].obs;
  RxString visitType = 'N/A'.obs;
  RxBool creatingVisit = false.obs;
  RxList visitImg = [].obs;
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  ApiController get api => _apiController;

  RxList fetchedShops = [].obs;
  RxBool fetchShop = false.obs;
  Timer? _timer;

  RxBool reminder = false.obs;
  RxString pickedDate = "N/A".obs;

  VisitController() {
    _apiController = Get.find<ApiController>();
    _settingController = Get.find<SettingController>();
    _cloudController = Get.find<CloudController>();
  }

  fetchShopWithCpCode({required String cpCode}) async {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _timer = Timer(const Duration(seconds: 2), () async {
        fetchShop.value = true;
        try {
          fetchedShops.value = [];
          fetchedShops.value = await _apiController.getShops(
            skip: "0",
            limit: "10",
            name: cpCode,
            online: _cloudController.alive.value,
          );

          fetchShop.value = false;
        } on HttpException catch (e) {
          fetchShop.value = false;
        } catch (e) {
          fetchShop.value = false;
        }
      });
    } else {
      _timer = Timer(const Duration(milliseconds: 500), () async {
        fetchShop.value = true;
        try {
          fetchedShops.value = [];
          fetchedShops.value = await _apiController.getShops(
            skip: "0",
            limit: "10",
            name: cpCode,
            online: _cloudController.alive.value,
          );

          fetchShop.value = false;
        } on HttpException catch (e) {
          fetchShop.value = false;
          print(e);
        } catch (e) {
          fetchShop.value = false;
          print(e.toString());
        }
      });
    }
  }

  Future getVisits() async {
    try {
      isLoading.value = true;
      List<VisitModel> visits = await _apiController.getVisits(
        startDate: from.value,
        endDate: to.value,
        online: _cloudController.alive.value,
      );
      this.visits.value = visits;
      isLoading.value = false;
    } on HttpException catch (e) {
      isLoading.value = false;
      if (e.message == "TOKEN_EXPIRE") {
        isLoggedOut.value = true;
      } else {
        isError.value = true;
        errorMessage = e.message;
      }
    } catch (e) {
      isLoading.value = false;
      if (e.toString().contains("TOKEN_EXPIRE")) {
        isLoggedOut.value = true;
      } else {
        isError.value = true;
        errorMessage = e.toString();
      }
    }
  }

  setStartDate({
    required BuildContext context,
  }) async {
    var n = DateTime.now().millisecondsSinceEpoch;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2008),
      lastDate: DateTime.fromMillisecondsSinceEpoch(n + 24 * 60 * 60 * 1000),
    );

    if (picked != null) {
      from.value = picked.toString().split(' ')[0];
    }
  }

  pickDateAndTimeFor({
    required BuildContext context,
  }) async {
    var n = DateTime.now().millisecondsSinceEpoch;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2008),
      lastDate: DateTime(DateTime.now().year + 50),
    );

    if (picked != null) {
      pickedDate.value = picked.toString().split(' ')[0];
    }
  }

  setEndDate({
    required BuildContext context,
  }) async {
    var n = DateTime.now().millisecondsSinceEpoch;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.fromMillisecondsSinceEpoch(n + 24 * 60 * 60 * 1000),
    );
    if (picked != null) {
      to.value = picked.toString().split(' ')[0];
    }
  }

  // setShops({required Shops shop}) {
  //   shops.value = shop;
  // }

  // clearShops() {
  //   shops.value = Shops();
  // }

  getNearbyShops() async {
    try {
      loadingNearByShops.value = true;
      List<Shops> shops = await _apiController.getShopsByKm(
        distance: 200,
        online: _cloudController.alive.value,
      );
      nearbyShops.value = shops;
      loadingNearByShops.value = false;
    } on HttpException catch (e) {
      errorMessage = e.message;
      loadingNearByShops.value = false;
    } catch (e) {
      // print(e.toString());
      loadingNearByShops.value = false;
    }
  }

  getTypes() async {
    try {
      loadingType.value = true;
      List<VisitType> types = await _apiController.getTypes(
        online: _cloudController.alive.value,
      );
      this.types.value = types;
      loadingType.value = false;
    } on HttpException catch (e) {
      errorMessage = e.message;
      loadingType.value = false;
    } catch (e) {
      loadingType.value = false;
    }
  }

  setType({required String type}) {
    visitType.value = type;
  }

  clearType() {
    visitType.value = 'N/A';
  }

  createVisit({
    required BuildContext context,
    required String remarks,
    String? shopId,
    required bool shopUploaded,
    required Function cb,
    required bool withOutShop,
  }) async {
    try {
      /* 
      First step is validation. validating fields of visit form
      */

      if (remarks.isEmpty) {
        snackbar(context: context, message: 'Remarks is required');
        return;
      } else if (withOutShop == true &&
          (phoneController.text.isEmpty || nameController.text.isEmpty)) {
        snackbar(context: context, message: 'Phone and Name is required');
      } else if (withOutShop == false && shopId == null) {
        snackbar(context: context, message: 'Please select shop');
        return;
      } else if (visitType == "N/A") {
        snackbar(context: context, message: 'Please Select Visit Type');
        return;
      } else if (visitImg.value.isEmpty) {
        snackbar(context: context, message: 'Please Select Image');
        return;
      } else {
        creatingVisit.value = true;
        /* 
          Below call will create visit in local database 
        */
        await _apiController.createVisitsFromLocal(
          instant: instantCreate.value,
          createVisit: CreateVisit(
            name: nameController.text,
            phone: phoneController.text,
            remarks: remarks,
            shop: shopId,
            type: visitType.value,
            shopUploaded: shopUploaded,
            image: visitImg.value,
            /* Reason is not required here */
            reason: 'Some Reason',
            time: DateTime.now().toLocal().toString(),
            withOutShop: withOutShop,
            /* 
              Below fields are not required here
              If user want to add reminder for their visit then they can add it from visit details screen
            */
            createReminder: reminder.value == true
                ? CreateReminder(
                    syncId:
                        '${_apiController.storageController.userModel.value.user!.sId}/reminder/${DateTime.now().millisecondsSinceEpoch.toString()}',
                    date: pickedDate.value,
                    remarks: remarkController.text.isEmpty
                        ? "Not Added"
                        : remarkController.text,
                    shop: shopId,
                  )
                : null,
          ),
          online: _cloudController.alive.value,
        );

        creatingVisit.value = false;

        /* 
          Below code will open a dialog box to show message that the visit is created successfully in local database
        */

        nameController.text = "";
        phoneController.text = "";
        remarkController.text = "";
        visitImg.value = [];
        visitType.value = "N/A";
        pickedDate.value = "N/A";
        Fluttertoast.showToast(msg: 'Visit Created Successfully');
        cb();
      }
    } on HttpException catch (e) {
      creatingVisit.value = false;
      _settingController.messageDialogue(
        context: context,
        errorMessage: e.message,
        callback: () {},
      );
    } catch (e) {
      creatingVisit.value = false;
      _settingController.messageDialogue(
        context: context,
        errorMessage: e.toString(),
        callback: () {},
      );
    }
  }

  getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1080,
    );

    if (image != null) {
      List img = visitImg.value;
      img.add(image.path);
      visitImg.value = [];
      visitImg.value = img;
    }
  }

  removeImage({required String img}) {
    List imgList = visitImg.value;
    imgList.remove(img);
    visitImg.value = [];
    visitImg.value = imgList;
  }

  snackbar({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red.withOpacity(0.7),
        content: Text(
          message,
          style: GoogleFonts.firaSans(color: Colors.white),
        ),
      ),
    );
  }

  Future<bool> changeView() async {
    isPostView.value = !isPostView.value;
    return isPostView.value;
  }
}

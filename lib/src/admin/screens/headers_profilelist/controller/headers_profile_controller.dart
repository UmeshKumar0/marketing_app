import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:marketing/src/admin/controller/admin_api.dart';
import 'package:marketing/src/admin/models/AppHeaders_model.dart';
import 'package:marketing/src/admin/models/moProfile.dart';

class HeadersProfileController extends GetxController {
  RxString title = 'HeadersProfile'.obs;
  RxList<SingleVisit> singleVisit = <SingleVisit>[].obs;
  RxBool isLoading = true.obs;

  late AdminApi adminApi;
  @override
  void onInit() {
    adminApi = Get.find<AdminApi>();
    title.value = Get.arguments['header'];
    singleVisit.value = Get.arguments['profiles'] ?? [];
    isLoading.value = false;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<MOProfile?> fetchProfile({required String userId}) async {
    try {
      List<MOProfile> profile =
          await adminApi.getmarketingofficers(single: true, userId: userId);
      return profile.isEmpty ? null : profile.first;
    } on HttpException catch (e) {
      Fluttertoast.showToast(msg: e.message);
      return null;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return null;
    }
  }
}

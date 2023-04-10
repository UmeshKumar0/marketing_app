import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:marketing/src/admin/controller/admin_api.dart';
import 'package:marketing/src/admin/models/AShopImage.dart';
import 'package:marketing/src/admin/models/AShopVisit.dart';
import 'package:marketing/src/admin/models/Ashop_model.dart';

class SpreviewController extends GetxController {
  /* used for render tabes on shop preview screen */
  RxList<String> tabes = [
    'Shop Details',
    'Shop Gallery',
    'Related Visits',
    'Related Reminders'
  ].obs;

  /* default selected tab */
  RxString selectedTab = 'Shop Details'.obs;
  AShop shop = Get.arguments;
  RxString uploadImage = 'N/A'.obs;
  RxBool uploading = false.obs;
  RxBool editingMode = false.obs;
  RxList<AShopVisit> visits = <AShopVisit>[].obs;
  RxBool visitsLoading = false.obs;
  RxBool isPostMode = false.obs;
  RxBool shopUpdating = false.obs;

  TextEditingController shopNameController = TextEditingController();
  TextEditingController cpCodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController productController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  /* This function is used to change selected tab */
  void changeSelectedTab(String tab) {
    selectedTab.value = tab;
    tabes.refresh();
  }

  void changeEditingMode() {
    editingMode.value = !editingMode.value;
  }

  late PagingController<int, AShopImage> pagingController;
  late AdminApi adminApi;
  RxInt pageSize = 15.obs;

  @override
  void onInit() {
    super.onInit();
    adminApi = Get.find<AdminApi>();
    shopNameController.text = shop.name!;
    phoneController.text = shop.phone!;
    addressController.text = shop.address!;
    productController.text = shop.products!;
    emailController.text = shop.email!;

    pagingController = PagingController(firstPageKey: 0);
    pagingController.addPageRequestListener((pageKey) {
      fetchImages(pageKey: pageKey);
    });
    fetchVisits();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
    shopNameController.dispose();
    cpCodeController.dispose();
    phoneController.dispose();
    addressController.dispose();
    productController.dispose();
    emailController.dispose();
  }

  fetchVisits() async {
    try {
      visitsLoading.value = true;
      List<AShopVisit> _visits = await adminApi.getVisitsOfShop(
        shopId: shop.sId as String,
      );
      visits.value = _visits;
      visitsLoading.value = false;
    } on HttpException catch (e) {
      visitsLoading.value = false;
      Get.snackbar('Error', e.message);
    } catch (e) {
      visitsLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  fetchImages({
    required int pageKey,
  }) async {
    try {
      List<AShopImage> images = await adminApi.getShopImages(
        skip: (pageKey / pageSize.value).toInt(),
        limit: pageSize.value,
        shopId: shop.sId,
      );

      if (images.length < pageSize.value) {
        pagingController.appendLastPage(images);
      } else {
        pagingController.appendPage(images, pageKey + pageSize.value);
      }
    } on HttpException catch (e) {
      pagingController.error = e.message;
    } catch (e) {
      pagingController.error = e.toString();
    }
  }

  pickImage() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        uploadImage.value = image.path;
      }
    } on HttpException catch (e) {
      Get.snackbar('Error', e.message);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  uploadShopImage() async {
    try {
      if (uploadImage.value != 'N/A') {
        uploading.value = true;
        await adminApi.uploadImage(
          shopId: shop.sId as String,
          imagePath: uploadImage.value,
        );
        uploadImage.value = 'N/A';
        pagingController.refresh();
        uploading.value = false;
      }
    } on HttpException catch (e) {
      uploading.value = false;
      Get.snackbar('Error', e.message);
    } catch (e) {
      uploading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  updateShopDetails() async {
    try {
      shopUpdating.value = true;
      await adminApi.shopUpdate(data: {
        "name": shopNameController.text,
        "phone": phoneController.text,
        "address": addressController.text,
        "products": productController.text,
        "email": emailController.text,
      }, shopId: shop.sId as String);
      Fluttertoast.showToast(msg: 'Shop details updated successfully');
      shopUpdating.value = false;
      editingMode.value = false;
    } on HttpException catch (e) {
      shopUpdating.value = false;
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      shopUpdating.value = false;
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}

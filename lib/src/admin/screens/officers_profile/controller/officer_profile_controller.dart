import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:marketing/src/admin/controller/admin_api.dart';
import 'package:marketing/src/admin/models/AShopVisit.dart';
import 'package:marketing/src/admin/models/Ashop_model.dart';
import 'package:marketing/src/admin/models/menu_item.dart';
import 'package:marketing/src/admin/models/moProfile.dart';

class OfficersProfileController extends GetxController {
  RxBool loading = true.obs;
  Rx<MOProfile> moProfile = MOProfile().obs;
  late AdminApi adminApi;
  
  RxBool reminderLoading = true.obs;

  late PagingController<int, AShop> shopPageController;
  late PagingController<int, AShopVisit> visitPageController;
  late PagingController reminderPageController;
  RxInt shopPageSize = 15.obs;
  RxInt visitPageSize = 15.obs;
  RxInt reminderPageSize = 15.obs;

  RxList<CustomMenuItem> items = [
    CustomMenuItem(title: 'Related Shops', value: 'RELATED_SHOPS'),
    CustomMenuItem(title: 'Related Visits', value: 'RELATED_VISITS'),
    CustomMenuItem(title: 'Related Reminders', value: 'RELATED_REMINDERS'),
  ].obs;

  Rx<CustomMenuItem> selected = CustomMenuItem(
    title: 'Related Shops',
    value: 'RELATED_SHOPS',
  ).obs;

  changeItem({required CustomMenuItem i}) {
    selected.value = i;
    items.refresh();
  }

  @override
  void onInit() {
    adminApi = Get.find<AdminApi>();
    shopPageController = PagingController(firstPageKey: 0);
    visitPageController = PagingController(firstPageKey: 0);
    reminderPageController = PagingController(firstPageKey: 0);
    moProfile.value = Get.arguments as MOProfile;
    loading.value = false;
    shopPageController.addPageRequestListener((pageKey) {
      fetchShops(pageSize: pageKey);
    });
    visitPageController.addPageRequestListener((pageKey) {
      fetchVisis(pageSize: pageKey);
    });
    reminderPageController.addPageRequestListener((pageKey) {
      fetchReminders(pageSize: pageKey);
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  fetchShops({required int pageSize}) async {
    try {
      List<AShop> shops = await adminApi.getShops(
        skip: (pageSize / shopPageSize.value).round(),
        limit: shopPageSize.value,
        userId: moProfile.value.sId,
      );

      if (shops.length < shopPageSize.value) {
        shopPageController.appendLastPage(shops);
      } else {
        shopPageController.appendPage(shops, pageSize + shopPageSize.value);
      }
    } on HttpException catch (e) {
      shopPageController.error = e.message;
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      shopPageController.error = e.toString();
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  fetchVisis({required int pageSize}) async {
    
    try {
      List<AShopVisit> visits = await adminApi.getVisitsOfShop(
        skip: (pageSize / visitPageSize.value).round(),
        limit: visitPageSize.value,
        userId: moProfile.value.sId,
      );
      if(visits.length < visitPageSize.value){
        visitPageController.appendLastPage(visits);
      }else{
        visitPageController.appendPage(visits, pageSize + visitPageSize.value);
      }
    } on HttpException catch (e) {
      visitPageController.error = e.message;
    } catch (e) {
      visitPageController.error = e.toString();
    }
  }

  fetchReminders({required int pageSize}) async {
    reminderLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    reminderLoading.value = false;
  }
}

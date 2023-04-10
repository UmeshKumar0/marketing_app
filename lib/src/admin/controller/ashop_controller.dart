import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:marketing/src/admin/controller/admin_api.dart';
import 'package:marketing/src/admin/models/Ashop_model.dart';

class AShopController extends GetxController {
  late AdminApi adminApi;
  RxInt pageSize = 15.obs;
  RxString name = ''.obs;
  RxString createdAt = ''.obs;
  RxBool dateFilter = false.obs;

  late PagingController<int, AShop> pagingController;
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    DateTime date = DateTime.now();
    createdAt = '${date.year}-${date.month}-${date.day}'.obs;
    pagingController = PagingController(firstPageKey: 0);
    adminApi = Get.find<AdminApi>();
    pagingController.addPageRequestListener((pageKey) {
      fetchShops(
        pageKey: pageKey,
      );
    });
  }

  increase() {
    if (pageSize.value < 100) {
      pageSize.value += 1;
      pagingController.refresh();
    } else {
      Fluttertoast.showToast(msg: 'Max page size is 100');
    }
  }

  decrease() {
    if (pageSize.value > 1) {
      pageSize.value -= 1;
      pagingController.refresh();
    } else {
      Fluttertoast.showToast(msg: 'Min page size is 1');
    }
  }

  changeDateFilter() {
    dateFilter.value = !dateFilter.value;
    pagingController.refresh();
  }

  changeName(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      name.value = value;
      pagingController.refresh();
    });
  }

  fetchShops({
    required int pageKey,
  }) async {
    List<AShop> shops = await adminApi.getShops(
      skip: (pageKey / pageSize.value).toInt(),
      limit: pageSize.value,
      name: name.value,
      createdAt: dateFilter.isTrue ? createdAt.value : null,
    );
    if (shops.length < pageSize.value) {
      pagingController.appendLastPage(shops);
    } else {
      pagingController.appendPage(shops, pageKey + pageSize.value);
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    pagingController.dispose();
  }

  cupertinoDate() {
    showCupertinoModalPopup(
      context: Get.overlayContext!,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 260,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime(
                    int.parse(createdAt.value.split('-')[0]),
                    int.parse(createdAt.value.split('-')[1]),
                    int.parse(createdAt.value.split('-')[2]),
                  ),
                  onDateTimeChanged: (value) {
                    createdAt.value =
                        '${value.year}-${value.month}-${value.day}';
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  pagingController.refresh();
                },
                child: const Text('Done'),
              )
            ],
          ),
        );
      },
    );
  }
}

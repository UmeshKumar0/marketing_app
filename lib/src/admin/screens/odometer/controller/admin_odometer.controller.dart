import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:marketing/src/admin/controller/admin_api.dart';
import 'package:marketing/src/admin/maps/views/amap_view.dart';
import 'package:marketing/src/admin/models/AOdometer.model.dart';
import 'package:marketing/src/admin/models/AShopVisit.dart';
import 'package:marketing/src/admin/models/drop_downitem.dart';
import 'package:marketing/src/admin/models/group_item.dart';

class AOdometerController extends GetxController {
  late AdminApi adminApi;

  late PagingController<int, AOdometer> pagingController;
  RxString createdAt = "N/A".obs;
  RxString afterCreatedAt = "N/A".obs;
  RxInt pageSize = 15.obs;
  Timer? _debounce;
  RxString name = "".obs;
  RxBool showPending = false.obs;
  RxBool locationNotFound = false.obs;
  RxList<CustomDropDownItem> dropDownItems = <CustomDropDownItem>[
    CustomDropDownItem(
      value: 'all',
      text: 'Select All Group',
    ),
  ].obs;

  RxString selectedGroupVlaue = 'all'.obs;

  RxMap<String, OdoVisit> visits = <String, OdoVisit>{}.obs;
  RxList<AOdometer> odometers = <AOdometer>[].obs;
  TextEditingController manualReading = TextEditingController();
  RxString readingImage = "N/A".obs;
  RxBool closingOdo = false.obs;
  Timer? _debounce2;

  @override
  void onInit() {
    adminApi = Get.find<AdminApi>();
    List<GroupItem> g = adminApi.getGroups();

    dropDownItems.value = [
      CustomDropDownItem(
        value: 'all',
        text: 'Select All Group',
      ),
    ];
    selectedGroupVlaue.value = 'all';
    for (GroupItem e in g) {
      dropDownItems.add(CustomDropDownItem(
        value: e.members!.map((e) => e.sId).toList().join(','),
        text: e.name as String,
      ));
    }

    dropDownItems.refresh();

    DateTime date = DateTime.now();
    DateTime nextDay = date.add(const Duration(days: 1));
    createdAt = '${date.year}-${date.month}-${date.day}'.obs;
    afterCreatedAt = '${nextDay.year}-${nextDay.month}-${nextDay.day}'.obs;
    pagingController = PagingController(firstPageKey: 0);
    pagingController.addPageRequestListener((pageKey) {
      fetchOdometers(pageKey: pageKey);
    });

    super.onInit();
  }

  changePending() {
    showPending.value = !showPending.value;
    pagingController.refresh();
  }

  changeLocation() async {
    locationNotFound.value = !locationNotFound.value;
    pagingController.refresh();
  }

  fetchOdometers({
    required int pageKey,
  }) async {
    try {
      Map<String, dynamic> res = await adminApi.getOdometers(
        skip: (pageKey / pageSize.value).toInt(),
        limit: pageSize.value,
        startDateQuery: createdAt.value,
        endDateQuery: afterCreatedAt.value,
        pending: showPending.value,
        search: name.value,
        group: selectedGroupVlaue.value == 'all'
            ? []
            : selectedGroupVlaue.value.split(',').toList(),
        visitsDetails: true,
      );
      odometers.value = res['odometers'];
      visits.value = res['visits'];
      if (odometers.length < pageSize.value) {
        pagingController.appendLastPage(odometers);
      } else {
        pagingController.appendPage(
          odometers,
          pageKey + pageSize.value,
        );
      }
    } on HttpException catch (e) {
      print(e.message);
      pagingController.error = e;
    } catch (e) {
      print(e.toString());
      pagingController.error = e;
    }
  }

  changeName(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      name.value = value;
      pagingController.refresh();
    });
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
                    afterCreatedAt.value =
                        '${value.add(const Duration(days: 1)).year}-${value.add(const Duration(days: 1)).month}-${value.add(const Duration(days: 1)).day}';
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

  getImage({required bool camera}) async {
    XFile? file = await ImagePicker().pickImage(
      source: camera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
    );

    if (file != null) {
      readingImage.value = file.path;
    }
  }

  closeOdometer({required String odoId}) async {
    try {
      if (manualReading.text.isEmpty) {
        Fluttertoast.showToast(msg: 'Please enter odometer reading');
        return;
      }
      if (readingImage.value == 'N/A') {
        Fluttertoast.showToast(msg: 'Please take odometer reading image');
        return;
      }
      closingOdo.value = true;
      await adminApi.closeOdometer(
        endReading: manualReading.text,
        imagePath: readingImage.value,
        odoId: odoId,
      );
      readingImage.value = "N/A";
      manualReading.text = '';
      closingOdo.value = false;
      Fluttertoast.showToast(msg: 'Odometer closed successfully');
      pagingController.refresh();
    } on HttpException catch (e) {
      closingOdo.value = false;
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      closingOdo.value = false;
      Fluttertoast.showToast(msg: 'Error closing odometer');
    }
  }

  registerRefresher() async {
    _debounce2 = Timer.periodic(Duration(minutes: 2), (timer) {
      pagingController.refresh();
    });
  }

  deleteodometer({required String id}) async {
    try {
      await adminApi.deleteOdometer(id: id);
      pagingController.refresh();
    } on HttpException catch (e) {
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error deleting odometer');
    }
  }

  loadVisits({
    required String userId,
  }) async {
    try {
      List<AShopVisit> visits = await adminApi.getVisitsOfShop(
        userId: userId,
        limit: 1000,
        skip: 0,
        startDateQuery: createdAt.value,
        endDateQuery: afterCreatedAt.value,
      );
      if (visits.isEmpty) {
        Fluttertoast.showToast(msg: 'No visits found');
        return;
      }
      Map<MarkerId, Marker> markers = {};
      List<LatLng> points = [];
      LatLng center = LatLng(0, 0);
      for (int i = 0; i < visits.length; i++) {
        markers[MarkerId(visits[i].sId as String)] = Marker(
          markerId: MarkerId(visits[i].sId as String),
          position: LatLng(
            visits[i].location!.latitude as double,
            visits[i].location!.longitude as double,
          ),
          infoWindow: InfoWindow(
            title: visits[i].name,
            snippet: visits[i].createdAt,
          ),
        );

        points.add(
          LatLng(
            visits[i].location!.latitude as double,
            visits[i].location!.longitude as double,
          ),
        );

        if (i == 0) {
          center = LatLng(
            visits[i].location!.latitude as double,
            visits[i].location!.longitude as double,
          );
        }
      }
      Get.toNamed(AdminMaps.routeName, arguments: {
        'markers': markers,
        'points': points,
        'center': center,
      });
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: 'Error loading visits');
    }
  }
}

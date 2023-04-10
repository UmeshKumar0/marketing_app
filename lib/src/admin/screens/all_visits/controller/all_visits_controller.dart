import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:marketing/src/admin/controller/admin_api.dart';
import 'package:marketing/src/admin/maps/views/amap_view.dart';
import 'package:marketing/src/admin/models/AShopVisit.dart';
import 'package:marketing/src/admin/models/drop_downitem.dart';
import 'package:marketing/src/admin/models/group_item.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/models/types.dart';

class AllVisitController extends GetxController {
  late AdminApi adminApi;

  late PagingController<int, AShopVisit> visitPageController;
  RxString startDate = ''.obs;
  RxString endDate = ''.obs;
  RxInt pageSize = 15.obs;
  RxString selectedVisitType = 'ALL_VISITS'.obs;
  RxList<VisitType> types =
      <VisitType>[VisitType(sId: 'ALL_VISITS', value: 'ALL_VISITS')].obs;
  RxList<CustomDropDownItem> groups = <CustomDropDownItem>[
    CustomDropDownItem(
      text: 'ALL_GROUPS',
      value: 'ALL_GROUPS',
    )
  ].obs;
  RxString selectedGroup = 'ALL_GROUPS'.obs;
  RxString search = 'N/A'.obs;
  Timer? _debounce2;

  RxBool loadingCoordinators = false.obs;

  @override
  void onInit() {
    super.onInit();
    adminApi = Get.find<AdminApi>();
    fetchVisitTypes();
    List<GroupItem> items = adminApi.getGroups();
    groups.value = [];
    for (var element in items) {
      groups.add(
        CustomDropDownItem(
          text: element.name as String,
          value: element.members!.map((e) => e.sId).toList().join(','),
        ),
      );
    }
    groups.add(CustomDropDownItem(
      text: 'ALL_GROUPS',
      value: 'ALL_GROUPS',
    ));
    groups.refresh();
    DateTime now = DateTime.now();
    DateTime nextDay = now.add(Duration(days: 1));
    startDate.value = '${now.year}-${now.month}-${now.day}';
    endDate.value = '${nextDay.year}-${nextDay.month}-${nextDay.day}';
    visitPageController = PagingController(firstPageKey: 0);
    visitPageController.addPageRequestListener((pageKey) {
      fetchVisits(pageKey: pageKey);
    });
  }

  searchWithQuery({required String value}) {
    search.value = value;
    visitPageController.refresh();
  }

  increase() {
    if (pageSize.value < 100) {
      pageSize.value += 5;
      visitPageController.refresh();
    } else {
      Get.snackbar('Error', 'Max page size is 100');
    }
  }

  decrease() {
    if (pageSize.value > 5) {
      pageSize.value -= 5;
      visitPageController.refresh();
    } else {
      Get.snackbar('Error', 'Min page size is 5');
    }
  }

  fetchVisits({required int pageKey}) async {
    try {
      print('Hello Here');
      List<AShopVisit> visits = await adminApi.getVisitsOfShop(
        startDateQuery: startDate.value,
        endDateQuery: endDate.value,
        limit: pageSize.value,
        skip: (pageKey / pageSize.value).round(),
        sortOrder: 1,
        visitType: selectedVisitType.value,
        groupId: selectedGroup.value,
        search: search.value,
      );

      if (visits.length < pageSize.value) {
        visitPageController.appendLastPage(visits);
      } else {
        visitPageController.appendPage(visits, pageKey + pageSize.value);
      }
    } on HttpException catch (e) {
      visitPageController.error = e.message;
    } catch (e) {
      visitPageController.error = e.toString();
    }
  }

  fetchVisitTypes() async {
    ApiController apiController = Get.find<ApiController>();
    List<VisitType> v = await apiController.getTypes(online: true);
    types.value = [];
    types.value = [VisitType(sId: 'ALL_VISITS', value: 'ALL_VISITS'), ...v];
    types.refresh();
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
                    int.parse(startDate.value.split('-')[0]),
                    int.parse(startDate.value.split('-')[1]),
                    int.parse(startDate.value.split('-')[2]),
                  ),
                  onDateTimeChanged: (value) {
                    startDate.value =
                        '${value.year}-${value.month}-${value.day}';
                    endDate.value =
                        '${value.add(const Duration(days: 1)).year}-${value.add(const Duration(days: 1)).month}-${value.add(const Duration(days: 1)).day}';
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  visitPageController.refresh();
                },
                child: const Text('Done'),
              )
            ],
          ),
        );
      },
    );
  }

  registerRefresher() async {
    _debounce2 = Timer.periodic(Duration(minutes: 2), (timer) {
      visitPageController.refresh();
    });
  }

  getcoordinates() async {
    loadingCoordinators.value = true;
    List<AShopVisit> visits = await adminApi.getVisitsOfShop(
      startDateQuery: startDate.value,
      endDateQuery: endDate.value,
      limit: 1000,
      skip: 0,
      sortOrder: 1,
    );
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    for (var element in visits) {
      if (element.location != null) {
        final MarkerId markerId = MarkerId(element.sId as String);
        final Marker marker = Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueCyan,
          ),
          markerId: markerId,
          position: LatLng(
            element.location!.latitude as double,
            element.location!.longitude as double,
          ),
          infoWindow: InfoWindow(
            title: element.name,
            snippet: element.type,
          ),
        );
        markers[markerId] = marker;
      }
    }
    loadingCoordinators.value = false;
    Get.toNamed(AdminMaps.routeName, arguments: {
      'markers': markers,
      "points": [LatLng(0, 0)],
      "center": markers.values.first.position,
    });
  }
}

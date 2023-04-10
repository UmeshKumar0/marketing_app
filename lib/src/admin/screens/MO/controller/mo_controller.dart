import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:marketing/src/admin/controller/admin_api.dart';
import 'package:marketing/src/admin/models/drop_downitem.dart';
import 'package:marketing/src/admin/models/group_item.dart';
import 'package:marketing/src/admin/models/moProfile.dart';

class MoController extends GetxController {
  late AdminApi adminApi;
  late PagingController<int, MOProfile> pagingController;
  RxInt pageSize = 15.obs;
  RxString name = "N/A".obs;
  RxString role = "all".obs;
  RxString status = "all".obs;
  RxList<GroupItem> groups = <GroupItem>[].obs;
  RxBool loading = false.obs;
  RxString selectedGroup = "Select".obs;
  RxList<CustomDropDownItem> items = <CustomDropDownItem>[
    CustomDropDownItem(
      text: 'All Groups Users',
      value: 'Select',
    )
  ].obs;

  RxBool deleting = false.obs;

  @override
  void onInit() {
    super.onInit();
    adminApi = Get.find<AdminApi>();
    List<GroupItem> groups = adminApi.getGroups();
    items.value = [
      CustomDropDownItem(
        text: 'All Groups Users',
        value: 'Select',
      )
    ];
    for (var element in groups) {
      CustomDropDownItem item = CustomDropDownItem(
        text: element.name as String,
        value: element.members!.map((e) => e.sId).toList().join(','),
      );
      items.add(item);
    }
    items.refresh();
    pagingController = PagingController(firstPageKey: 0);
    pagingController.addPageRequestListener((pageKey) {
      fetch(pageKey: pageKey);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  increase() {
    if (pageSize.value < 100) {
      pageSize.value += 5;
      pagingController.refresh();
    } else {
      Fluttertoast.showToast(msg: 'Maximum limit reached');
    }
  }

  changeSelectedGroup(String value) {
    selectedGroup.value = value;
    pagingController.refresh();
  }

  decrease() {
    if (pageSize.value > 5) {
      pageSize.value -= 5;
      pagingController.refresh();
    } else {
      Fluttertoast.showToast(msg: 'Minimum limit reached');
    }
  }

  changename(String value) {
    name.value = value;
    pagingController.refresh();
  }

  setRole(String value) {
    role.value = value;
    pagingController.refresh();
  }

  setStatus(String value) {
    status.value = value;
    pagingController.refresh();
  }

  fetch({required int pageKey}) async {
    try {
      List<MOProfile> moProfiles = await adminApi.getmarketingofficers(
        single: false,
        skip: (pageKey / pageSize.value).toInt(),
        limit: pageSize.value,
        blocked: status.value,
        name: name.value,
        role: role.value,
        group: selectedGroup.value,
      );

      final isLastPage = moProfiles.length < pageSize.value;
      if (isLastPage) {
        pagingController.appendLastPage(moProfiles);
      } else {
        final nextPageKey = pageKey + pageSize.value;
        pagingController.appendPage(moProfiles, nextPageKey);
      }
    } on HttpException catch (e) {
      pagingController.error = e.message;
    } catch (e) {
      pagingController.error = e.toString();
    }
  }

  @override
  void onClose() {}

  deleteUser({required String userId}) async {
    try {
      loading.value = true;
      await adminApi.deleteUserAccount(id: userId);
      loading.value = false;
      pagingController.refresh();
    } on HttpException catch (e) {
      loading.value = false;
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      loading.value = false;
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}

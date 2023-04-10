import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:marketing/src/admin/controller/admin_api.dart';
import 'package:marketing/src/admin/models/moProfile.dart';

class SponsorController extends GetxController {
  late PagingController<int, MOProfile> pagingController;
  late AdminApi api;
  RxInt pageSize = 15.obs;
  RxString name = 'N/A'.obs;
  Timer? debounce;
  @override
  void onInit() {
    api = Get.find<AdminApi>();
    pagingController = PagingController(firstPageKey: 0);
    pagingController.addPageRequestListener((pageKey) {
      fetch(pageKey: pageKey);
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  fetch({required int pageKey}) async {
    try {
      List<MOProfile> moProfiles = await api.getmarketingofficers(
        single: false,
        skip: (pageKey / pageSize.value).toInt(),
        limit: pageSize.value,
        name: name.value,
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
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }
}

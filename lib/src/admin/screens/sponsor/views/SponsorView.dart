import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/models/moProfile.dart';
import '../controller/SponsorController.dart';

class SponsorViews extends GetView<SponsorController> {
  const SponsorViews({super.key});
  static String routeName = '/admin/sponsor';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Select Sponsor',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (controller.pageSize.value > 15) {
                controller.pageSize.value -= 15;
                controller.pagingController.refresh();
              } else {
                Fluttertoast.showToast(msg: 'Minimum page size is 15');
              }
            },
            icon: const Icon(
              Icons.remove,
              color: Colors.black,
            ),
          ),
          Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppConfig.primaryColor5,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  controller.pageSize.value.toString(),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }),
          IconButton(
            onPressed: () {
              if (controller.pageSize.value < 100) {
                controller.pageSize.value += 15;
                controller.pagingController.refresh();
              } else {
                Fluttertoast.showToast(msg: 'Maximum page size is 100');
              }
            },
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                onChanged: (value) {
                  if (controller.debounce?.isActive ?? false) {
                    controller.debounce?.cancel();
                  }
                  controller.debounce = Timer(
                    const Duration(milliseconds: 500),
                    () {
                      controller.name.value = value;
                      controller.pagingController.refresh();
                    },
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => Future.sync(
                () => controller.pagingController.refresh(),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: PagedListView(
                  pagingController: controller.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<MOProfile>(
                    itemBuilder: (context, item, index) {
                      return Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back(result: item);
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: item.profile != null
                                          ? item.profile!.thumbnailUrl !=
                                                      null &&
                                                  item.profile!.thumbnailUrl!
                                                      .isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: Image.network(
                                                    '${AppConfig.SERVER_IP}/${item.profile!.thumbnailUrl!}',
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Center(
                                                  child: Text(
                                                    item.name
                                                        .toString()
                                                        .substring(0, 1)
                                                        .toUpperCase(),
                                                    style: GoogleFonts.firaSans(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                )
                                          : Center(
                                              child: Text(
                                                item.name
                                                    .toString()
                                                    .substring(0, 1)
                                                    .toUpperCase(),
                                                style: GoogleFonts.firaSans(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name == null
                                              ? ''
                                              : item.name.toString().length > 15
                                                  ? '${item.name.toString().substring(0, 15)}...'
                                                  : item.name.toString(),
                                          style: GoogleFonts.firaSans(
                                            color: AppConfig.primaryColor5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          item.email != null
                                              ? item.email.toString().length >
                                                      18
                                                  ? '${item.email.toString().substring(0, 18)}...'
                                                  : item.email.toString()
                                              : '',
                                          style: GoogleFonts.firaSans(
                                            color: AppConfig.primaryColor5,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/models/AShopVisit.dart';
import 'package:marketing/src/admin/screens/all_visits/controller/all_visits_controller.dart';
import 'package:marketing/src/admin/widgets/ashop_postvisit.dart';

class AllVisitsViews extends GetView<AllVisitController> {
  const AllVisitsViews({super.key});
  static String routeName = '/admin/all_views';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Visits',
          style: GoogleFonts.firaSans(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        titleSpacing: 0,
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppConfig.primaryColor5,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: controller.cupertinoDate,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              alignment: Alignment.center,
                              child: Obx(
                                () {
                                  return Text(
                                    controller.startDate.value,
                                    style: GoogleFonts.firaSans(
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Obx(() {
                            return controller.loadingCoordinators.isTrue
                                ? Container(
                                  height: 20,
                                  width: 20,
                                  alignment: Alignment.center,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 1,
                                  ),
                                ) 
                                : IconButton(
                                    onPressed: () {
                                      controller.getcoordinates();
                                    },
                                    icon: const Icon(
                                      Icons.map,
                                      color: Colors.white,
                                    ),
                                  );
                          })
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: controller.decrease,
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                          Obx(() {
                            return Container(
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                controller.pageSize.value.toString(),
                                style: GoogleFonts.firaSans(
                                  color: AppConfig.primaryColor5,
                                ),
                              ),
                            );
                          }),
                          IconButton(
                            onPressed: controller.increase,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Obx(() {
                              return DropdownButton(
                                isExpanded: true,
                                value: controller.selectedVisitType.value,
                                items: controller.types.value
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e.value,
                                        child: Text(
                                          e.value as String,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  controller.selectedVisitType.value =
                                      value.toString();
                                  controller.visitPageController.refresh();
                                },
                                underline: Container(),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Obx(
                              () {
                                return DropdownButton(
                                  isExpanded: true,
                                  value: controller.selectedGroup.value,
                                  items: controller.groups.value
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e.value,
                                          child: Text(
                                            e.text,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    controller.selectedGroup.value =
                                        value.toString();
                                    controller.visitPageController.refresh();
                                  },
                                  underline: Container(),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextField(
                    onChanged: (value) {
                      controller.searchWithQuery(value: value);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Seach Visit....',
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
              child: RefreshIndicator(
            child: PagedListView(
              pagingController: controller.visitPageController,
              builderDelegate: PagedChildBuilderDelegate<AShopVisit>(
                itemBuilder: (context, item, index) {
                  return AShopVisitPostWidget(
                    visit: item,
                  );
                },
              ),
            ),
            onRefresh: () => Future.sync(
              () => controller.visitPageController.refresh(),
            ),
          ))
        ],
      ),
    );
  }
}

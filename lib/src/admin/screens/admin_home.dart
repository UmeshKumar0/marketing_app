// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/controller/admin_controller.dart';
import 'package:marketing/src/admin/screens/MO/views/mo_view.dart';
import 'package:marketing/src/admin/screens/admin_shops_screen.dart';
import 'package:marketing/src/admin/screens/all_visits/views/all_visits_views.dart';
import 'package:marketing/src/admin/screens/chat_module/views/ChatModuleView.dart';
import 'package:marketing/src/admin/screens/headers_profilelist/views/headers_profilelist_view.dart';
import 'package:marketing/src/admin/screens/odometer/views/odometer_screen.dart';
import 'package:marketing/src/admin/widgets/admin_appbar.dart';
import 'package:marketing/src/admin/widgets/admin_drawer.dart';
import 'package:marketing/src/admin/widgets/attendance_graph.dart';
import 'package:marketing/src/admin/widgets/home_graph.dart';
import 'package:marketing/src/admin/widgets/quick_actions.dart';
import 'package:marketing/src/admin/widgets/today_update_item.dart';
import 'package:marketing/src/user/widgets/connection_status.dart';

class AdminHome extends GetView<AdminController> {
  AdminHome({
    super.key,
  });
  static String adminHomeRoute = '/adminHome';
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: const AdminDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        leading: InkWell(
          onTap: () {
            _key.currentState!.openDrawer();
          },
          child: AdminAppBarButton(
            storageController: controller.apiController.storageController,
          ),
        ),
        title: Text(
          'Dashboard',
          style: GoogleFonts.firaSans(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(ChatModuleViews.routeName);
            },
            icon: Icon(
              Icons.telegram,
              color: AppConfig.primaryColor5,
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const ConnectionStatus(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.fetchHeaders();
              },
              child: SingleChildScrollView(
                physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Today\'s Update',
                          style: GoogleFonts.firaSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      HomeGraph(
                        controller: controller,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const ScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 5),
                              child: InkWell(
                                onTap: () {},
                                child: TodayUpdateItem(
                                  adminController: controller,
                                  count: Obx(() {
                                    return Container(
                                      alignment: Alignment.topLeft,
                                      child: controller.loadingHeaders.isTrue
                                          ? const SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1,
                                              ),
                                            )
                                          : Text(
                                              controller.appHeaders.value
                                                  .attendanceStats!.present
                                                  .toString(),
                                              style: GoogleFonts.firaSans(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 17,
                                              ),
                                            ),
                                    );
                                  }),
                                  title: "Present MO",
                                  icon: Icons.person_pin_circle_rounded,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  if (controller.loadingHeaders.isTrue) {
                                    Fluttertoast.showToast(
                                        msg: 'Loading data please wait');
                                  } else {
                                    Get.toNamed(
                                      HeaderProfileList.routeName,
                                      arguments: {
                                        'header': 'Absent MO',
                                        'profiles': controller
                                            .appHeaders.value.absentUser
                                      },
                                    );
                                  }
                                },
                                child: TodayUpdateItem(
                                  adminController: controller,
                                  count: Obx(() {
                                    return Container(
                                      alignment: Alignment.topLeft,
                                      child: controller.loadingHeaders.isTrue
                                          ? const SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1,
                                              ),
                                            )
                                          : Text(
                                              controller.appHeaders.value
                                                  .attendanceStats!.absent
                                                  .toString(),
                                              style: GoogleFonts.firaSans(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 17,
                                              ),
                                            ),
                                    );
                                  }),
                                  title: "Absent MO",
                                  icon: Icons.person_off,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  if (controller.loadingHeaders.isTrue) {
                                    Fluttertoast.showToast(
                                        msg: 'Loading data please wait');
                                  } else {
                                    Get.toNamed(
                                      HeaderProfileList.routeName,
                                      arguments: {
                                        'header': 'Not Visiting',
                                        'profiles': controller
                                            .appHeaders.value.notVisiting
                                      },
                                    );
                                  }
                                },
                                child: TodayUpdateItem(
                                  adminController: controller,
                                  count: Obx(() {
                                    return Container(
                                      alignment: Alignment.topLeft,
                                      child: controller.loadingHeaders.isTrue
                                          ? const SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1,
                                              ),
                                            )
                                          : Text(
                                              controller.appHeaders.value
                                                  .notVisiting!.length
                                                  .toString(),
                                              style: GoogleFonts.firaSans(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 17,
                                              ),
                                            ),
                                    );
                                  }),
                                  title: "Not Visiting",
                                  icon: Icons.content_paste_off_outlined,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  if (controller.loadingHeaders.isTrue) {
                                    Fluttertoast.showToast(
                                        msg: 'Loading data please wait');
                                  } else {
                                    Get.toNamed(
                                      HeaderProfileList.routeName,
                                      arguments: {
                                        'header': 'Multiple Visits',
                                        'profiles': controller
                                            .appHeaders.value.multiVisit
                                      },
                                    );
                                  }
                                },
                                child: TodayUpdateItem(
                                  adminController: controller,
                                  height150: true,
                                  count: Obx(() {
                                    return Container(
                                      alignment: Alignment.topLeft,
                                      child: controller.loadingHeaders.isTrue
                                          ? const SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1,
                                              ),
                                            )
                                          : Text(
                                              controller.appHeaders.value
                                                  .multiVisit!.length
                                                  .toString(),
                                              style: GoogleFonts.firaSans(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 17,
                                              ),
                                            ),
                                    );
                                  }),
                                  title: "Multiple Visits",
                                  icon: Icons.content_paste_go_outlined,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  if (controller.loadingHeaders.isTrue) {
                                    Fluttertoast.showToast(
                                        msg: 'Loading data please wait');
                                  } else {
                                    Get.toNamed(
                                      HeaderProfileList.routeName,
                                      arguments: {
                                        'header': 'Single Visits',
                                        'profiles': controller
                                            .appHeaders.value.singleVisit
                                      },
                                    );
                                  }
                                },
                                child: TodayUpdateItem(
                                  adminController: controller,
                                  height150: true,
                                  count: Obx(() {
                                    return Container(
                                      alignment: Alignment.topLeft,
                                      child: controller.loadingHeaders.isTrue
                                          ? const SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1,
                                              ),
                                            )
                                          : Text(
                                              controller.appHeaders.value
                                                  .singleVisit!.length
                                                  .toString(),
                                              style: GoogleFonts.firaSans(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 17,
                                              ),
                                            ),
                                    );
                                  }),
                                  title: "Single Visits",
                                  icon: Icons.signal_cellular_0_bar_outlined,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const ScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed(MoViews.route);
                                },
                                child: TodayUpdateItem(
                                  adminController: controller,
                                  count: Obx(() {
                                    return Container(
                                      alignment: Alignment.topLeft,
                                      child: controller.loadingHeaders.isTrue
                                          ? const SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1,
                                              ),
                                            )
                                          : Text(
                                              controller.marketingOfficers.value
                                                  .toString(),
                                              style: GoogleFonts.firaSans(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 17,
                                              ),
                                            ),
                                    );
                                  }),
                                  title: "MO",
                                  icon: Icons.group,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed(AOdometerScreen.routeName);
                                },
                                child: TodayUpdateItem(
                                  adminController: controller,
                                  count: Obx(() {
                                    return Container(
                                      alignment: Alignment.topLeft,
                                      child: controller.loadingHeaders.isTrue
                                          ? const SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1,
                                              ),
                                            )
                                          : Text(
                                              controller.odometers.value
                                                  .toString(),
                                              style: GoogleFonts.firaSans(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 17,
                                              ),
                                            ),
                                    );
                                  }),
                                  title: "Odometers",
                                  icon: Icons.directions_car,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed(AdminShopsScreen.route);
                                },
                                child: TodayUpdateItem(
                                  adminController: controller,
                                  count: Obx(() {
                                    return Container(
                                      alignment: Alignment.topLeft,
                                      child: controller.loadingHeaders.isTrue
                                          ? const SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1,
                                              ),
                                            )
                                          : Text(
                                              controller.shops.value.toString(),
                                              style: GoogleFonts.firaSans(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 17,
                                              ),
                                            ),
                                    );
                                  }),
                                  title: "Shops",
                                  icon: Icons.factory_rounded,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed(AllVisitsViews.routeName);
                                },
                                child: TodayUpdateItem(
                                  adminController: controller,
                                  title: "Visits",
                                  icon: Icons.paste_outlined,
                                  count: Obx(() {
                                    return Container(
                                      alignment: Alignment.topLeft,
                                      child: controller.loadingHeaders.isTrue
                                          ? const SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1,
                                              ),
                                            )
                                          : Text(
                                              controller.visits.value
                                                  .toString(),
                                              style: GoogleFonts.firaSans(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 17,
                                              ),
                                            ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      AttendanceBar(adminController: controller),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Services',
                          style: GoogleFonts.firaSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      QuickAction(),
// Dealership Requests start ------------------------------------------------------------------------->
                      Container(
                        padding: const EdgeInsets.only(
                          left: 10,
                          top: 10,
                          right: 10,
                        ),
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Dealership Requests',
                              style: GoogleFonts.firaSans(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                              ),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.indigo.shade100,
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                "See All",
                                style: GoogleFonts.firaSans(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 300,
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.grey.shade300,
                          ),
                          textDirection: TextDirection.ltr,
                          children: [
                            TableRow(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "Magadh Industries",
                                    style: GoogleFonts.firaSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "Patna Bihar 801111",
                                    style: GoogleFonts.firaSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        AppConfig.primaryColor7,
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      "View",
                                      style: GoogleFonts.firaSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "Maa Ifco chowk wali delhi",
                                    style: GoogleFonts.firaSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "hariyana Delhi India 8923893389238",
                                    style: GoogleFonts.firaSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        AppConfig.primaryColor7,
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      "View",
                                      style: GoogleFonts.firaSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "Maa Ifco chowk wali delhi",
                                    style: GoogleFonts.firaSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "hariyana Delhi India 8923893389238",
                                    style: GoogleFonts.firaSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        AppConfig.primaryColor7,
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      "View",
                                      style: GoogleFonts.firaSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
// Dealership requests end ----------------------------------------------------------------------------------->

// Meetings open --------------------------------------------------------------------------------------------->

                      Container(
                        padding: const EdgeInsets.only(
                          left: 10,
                          top: 10,
                          right: 10,
                        ),
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Meeting Requests',
                              style: GoogleFonts.firaSans(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                              ),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.indigo.shade100,
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                "See All",
                                style: GoogleFonts.firaSans(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 300,
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.grey.shade300,
                          ),
                          textDirection: TextDirection.ltr,
                          children: [
                            TableRow(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "Magadh Industries",
                                    style: GoogleFonts.firaSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "Patna Bihar 801111",
                                    style: GoogleFonts.firaSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        AppConfig.primaryColor7,
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      "View",
                                      style: GoogleFonts.firaSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "Maa Ifco chowk wali delhi",
                                    style: GoogleFonts.firaSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "hariyana Delhi India 8923893389238",
                                    style: GoogleFonts.firaSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        AppConfig.primaryColor7,
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      "View",
                                      style: GoogleFonts.firaSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "Maa Ifco chowk wali delhi",
                                    style: GoogleFonts.firaSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "hariyana Delhi India 8923893389238",
                                    style: GoogleFonts.firaSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        AppConfig.primaryColor7,
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      "View",
                                      style: GoogleFonts.firaSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

// Meetings done ---------------------------------------------------------------------------->
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

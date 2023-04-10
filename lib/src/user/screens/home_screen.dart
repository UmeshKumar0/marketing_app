import 'dart:async';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/controller/home_controller.dart';
import 'package:marketing/src/user/controller/maps_controller.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:marketing/src/user/screens/pages/index.dart';
import 'package:marketing/src/user/widgets/action_icons/maps_action_button.dart';
import 'package:marketing/src/user/widgets/action_icons/visit_action_icon.dart';
import 'package:marketing/src/user/widgets/bottom_sheet.dart';
import 'package:marketing/src/user/widgets/filterBottom_sheet.dart';
import 'package:workmanager/workmanager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // listenToNotification();
    Workmanager().registerPeriodicTask(
      "1",
      "PERODIC_TASK",
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
    Workmanager().registerOneOffTask(
      'SYNC_ONE',
      "SYNC_ONE",
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(builder: (home) {
      return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          leading: Image.asset(
            "assets/logov2.png",
            height: 60,
            width: 60,
          ),
          titleSpacing: 2,
          title: AppConfig.appTitles[home.currentIndex.value],
          actions: home.currentIndex.value == 0
              ? [
                  home.loadingAttendance.isTrue
                      ? Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            home.getAttendance(
                              months: DateTime.now().month.toString(),
                              years: DateTime.now().year.toString(),
                            );
                          },
                          icon: Icon(
                            Icons.refresh,
                            color: AppConfig.primaryColor7,
                          ),
                        )
                ]
              : home.currentIndex.value == 3
                  ? [
                      IconButton(
                        onPressed: () async {
                          await home.changeVisitView();
                        },
                        icon: Icon(
                          home.isPostView.isTrue
                              ? Icons.line_style_rounded
                              : Icons.view_sidebar,
                          color: AppConfig.primaryColor7,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                          icon: Icon(
                            Icons.filter_alt_outlined,
                            color: AppConfig.primaryColor7,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              enableDrag: true,
                              context: context,
                              builder: (context) => BottomSheet(
                                builder: (context) {
                                  return FilterVisitBottomSheet(
                                    visitController: home.visitController,
                                  );
                                },
                                onClosing: () {},
                              ),
                            );
                          },
                        ),
                      )
                    ]
                  : home.currentIndex.value == 1
                      ? [
                          IconButton(
                            onPressed: () {
                              Get.toNamed(AppConfig.SEARCH_SCREEN);
                            },
                            icon: Icon(
                              Icons.search,
                              size: 30,
                              color: AppConfig.primaryColor7,
                            ),
                          ),
                        ]
                      : home.currentIndex.value == 2
                          ? [
                              GetX<MapsController>(builder: (map) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: map.speed.value != 0.00
                                      ? Row(
                                          children: [
                                            Text(
                                              '${map.speed.value.toInt()}',
                                              style: GoogleFonts.firaSans(
                                                color: Colors.green,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              ' m/s',
                                              style: GoogleFonts.firaSans(
                                                fontSize: 11,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        )
                                      : Container(),
                                );
                              }),
                              const MapsActionButtons(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Get.toNamed(AppConfig.CHAT_SCREEN);
                                  },
                                  child: Icon(
                                    Icons.message,
                                    color: AppConfig.primaryColor5,
                                  ),
                                ),
                              )
                            ]
                          : home.currentIndex.value == 4
                              ? [
                                  VisitActionIcon(
                                    reminderController: home.reminderController,
                                  )
                                ]
                              : [],
        ),
        bottomSheet: home.currentIndex.value == 0
            ? GetX<StorageController>(builder: (storage) {
                return storage.odoMeter.value == AppConfig.COMPLETE ||
                        storage.odoMeter.value == AppConfig.ABSENT
                    ? const CustomBottomSheet()
                    : Container(
                        height: 60,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          child: TextButton.icon(
                            onPressed: () {
                              if (storage.userModel.value.user!.role ==
                                  "ADMIN") {
                                Fluttertoast.showToast(
                                    msg:
                                        "You are not allowed to do this action because you are an admin");
                              } else {
                                Get.toNamed(AppConfig.CREATE_ODOMETER_SCREEN);
                              }
                            },
                            icon: Icon(
                              Icons.calendar_month,
                              color: AppConfig.primaryColor7,
                            ),
                            label: Text(
                              storage.userModel.value.user!.role == "ADMIN"
                                  ? "Welcome"
                                  : storage.odoMeter.value == AppConfig.COMPLETE
                                      ? 'Attendance Completed For Today'
                                      : storage.odoMeter.value ==
                                              AppConfig.PRESENT
                                          ? "Complete Your Attendance"
                                          : storage.odoMeter.value ==
                                                  AppConfig.ABSENT
                                              ? "You Are Absent For Today"
                                              : storage.odoMeter.value ==
                                                      AppConfig.HALFDAY
                                                  ? "Marked As Half Day By Admin"
                                                  : 'Tap Here Mark Your Attendance',
                              style: TextStyle(
                                color: AppConfig.primaryColor7,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
              })
            : const CustomBottomSheet(),
        body: WillPopScope(
          onWillPop: () {
            if (Get.find<CloudController>().syncMessage.value == 'SYNCING..') {
              Fluttertoast.showToast(msg: 'Please Wait We are Syncing Data');
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            allowImplicitScrolling: false,
            controller: home.pageController,
            onPageChanged: (value) {},
            children: [
              home.targetIndex.value == 0
                  ? AttendancePage(
                      home: home,
                    )
                  : Container(),
              home.targetIndex.value == 1
                  ? ShopPage(
                      shopController: home.shopController,
                    )
                  : Container(),
              home.targetIndex.value == 2
                  ? HomePage(
                      mapsController: home.mapsController,
                    )
                  : Container(),
              home.targetIndex.value == 3
                  ? HistoryPage(
                      visitController: home.visitController,
                    )
                  : Container(),
              home.targetIndex.value == 4
                  ? MorePage(
                      reminderController: home.reminderController,
                    )
                  : Container()
            ],
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          showElevation: true,
          selectedIndex: home.currentIndex.value,
          onItemSelected: (index) {
            home.changetargetIndex(value: index);
          },
          items: AppConfig.navi,
        ),
      );
    });
  }

  // void listenToNotification() => _notificationService.onNotificationClick.stream
  //     .listen(onNotificationListner);

  // void onNotificationListner(String? event) async {
  //   if (event != null && event.isNotEmpty) {
  //     // Navigator.of(context).pushNamed(event);
  //     try {
  //       print(
  //           '=================================+++++++++++++++++++=======++++++++');
  //       // await MyApp.navigatorKey.currentState!.pushNamed(event);
  //     } catch (e) {
  //       print(e.toString());
  //     }
  //   }
  // }
}

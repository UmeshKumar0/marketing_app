import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/admin/controller/admin_api.dart';
import 'package:marketing/src/admin/models/AppHeaders_model.dart';
import 'package:marketing/src/admin/models/ReportGraph.dart';
import 'package:marketing/src/admin/models/attendance_reportitem.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/settings_controller.dart';

class AdminController extends GetxController {
  late AdminApi apiController;
  late SettingController settingController;
  RxBool loadingHeaders = true.obs;
  RxInt marketingOfficers = 0.obs;
  RxInt odometers = 0.obs;
  RxInt shops = 0.obs;
  RxInt visits = 0.obs;
  RxInt reminders = 0.obs;
  RxInt meetings = 0.obs;
  RxInt leaves = 0.obs;
  RxInt attendance = 0.obs;
  RxList<AttendanceReportItem> attendanceReport = <AttendanceReportItem>[].obs;

  RxList<BarChartGroupData> rawBarGroups = <BarChartGroupData>[].obs;
  RxList<BarChartGroupData> showingBarGroups = <BarChartGroupData>[].obs;
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color midBarColor = const Color(0xffff5182);
  final Color rightBarColor = const Color(0xff24b6f3);
  Rx<ReportGraph> reportGraph = ReportGraph.fromJson({
    'today': [
      {"_id": "CONSTRUCTION_SITE", "count": 4},
      {"_id": "CONTRACTOR/MASON_VISIT", "count": 1},
      {"_id": "OTHERS", "count": 2},
      {"_id": "SHOP_VISIT", "count": 86}
    ],
    'week': [
      {"_id": "CONSTRUCTION_SITE", "count": 4},
      {"_id": "CONTRACTOR/MASON_VISIT", "count": 1},
      {"_id": "OTHERS", "count": 2},
      {"_id": "SHOP_VISIT", "count": 86}
    ],
    'month': [
      {"_id": "CONSTRUCTION_SITE", "count": 4},
      {"_id": "CONTRACTOR/MASON_VISIT", "count": 1},
      {"_id": "OTHERS", "count": 2},
      {"_id": "SHOP_VISIT", "count": 86}
    ],
    'year': [
      {"_id": "CONSTRUCTION_SITE", "count": 4},
      {"_id": "CONTRACTOR/MASON_VISIT", "count": 1},
      {"_id": "OTHERS", "count": 2},
      {"_id": "SHOP_VISIT", "count": 86}
    ],
  }).obs;
  RxBool loadingReport = true.obs;
  // final double width = 7;

  Rx<AppHeaders> appHeaders = AppHeaders(
    absentUser: [],
    attendanceStats: AttendanceStats(absent: 0, present: 0),
    multiVisit: [],
    notVisiting: [],
    singleVisit: [],
  ).obs;

  @override
  void onInit() {
    super.onInit();

    apiController = Get.find<AdminApi>();
    settingController = Get.find<SettingController>();
  }

  @override
  void onReady() {
    super.onReady();
    fetchHeaders();
  }

  fetchHeaders() async {
    try {
      await getAttendanceReport();
      await syncUserProfile();
      appHeaders.value = await apiController.getAppHeaders();
      marketingOfficers.value = appHeaders.value.attendanceStats!.absent! +
          appHeaders.value.attendanceStats!.present!;
      odometers.value = appHeaders.value.attendanceStats!.present!;
      DateTime date = DateTime.now();
      String today = '${date.year}-${date.month}-${date.day}';
      date = date.add(const Duration(days: 1));
      String tomorrow = '${date.year}-${date.month}-${date.day}';
      Map<String, dynamic> visit = await apiController.getAdminVisits(
        skip: 0,
        limit: 1,
        startDate: today,
        endDate: tomorrow,
      );
      visits.value = visit['total'];
      Map<String, dynamic> shops = await apiController.getAdminShops(
        skip: 0,
        limit: 1,
      );
      await apiController.fetchGroup();
      this.shops.value = shops['total'];
      loadingHeaders.value = false;
      await getReportGraph();
    } on HttpException catch (e) {
      if (e.message == "TOKEN_EXPIRED") {}
      loadingHeaders.value = false;
      settingController.messageDialogue(
        context: Get.context as BuildContext,
        errorMessage: e.message,
        callback: () {},
      );
    } catch (e) {
      // loadingHeaders.value = false;
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  fetchUsers() async {
    try {
      loadingHeaders.value = true;
      Map<String, dynamic> data =
          await apiController.getUsers(skip: 0, limit: 1);
      marketingOfficers.value = data['total'];
      loadingHeaders.value = false;
    } on HttpException catch (e) {
      loadingHeaders.value = false;
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      loadingHeaders.value = false;
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  getAttendanceReport() async {
    try {
      attendanceReport.value = await apiController.getattendanceReport();
      rawBarGroups.value = [];
      showingBarGroups.value = [];
      int index = 0;
      for (AttendanceReportItem item in attendanceReport) {
        final data = makeGroupData(
          index,
          item.present != null ? item.present!.toDouble() : 0,
          item.halfDay != null ? item.halfDay!.toDouble() : 0,
          item.absent != null ? item.absent!.toDouble() : 0,
        );
        index += 1;
        rawBarGroups.add(data);
      }
      showingBarGroups.value = rawBarGroups;
      rawBarGroups.refresh();
      showingBarGroups.refresh();
      attendanceReport.refresh();
    } on HttpException catch (e) {
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  syncUserProfile() async {
    try {
      ApiController apiController = Get.find<ApiController>();
      await apiController.userprofile();
      Fluttertoast.showToast(msg: 'Synced Successfully');
    } on HttpException catch (e) {
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final List<String> title = [
      'MO',
      'TU',
      'WE',
      'TH',
      'FR',
      'SA',
      'SU',
    ];
    AttendanceReportItem item = attendanceReport.value[value.toInt()];

    DateTime date = DateTime.fromMillisecondsSinceEpoch(item.date!);
    int day = date.weekday;
    final Widget text = Text(
      title.elementAt(day - 1),
      style: GoogleFonts.firaSans(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 20) {
      text = '20';
    } else if (value == 40) {
      text = '40';
    } else if (value == 60) {
      text = '60';
    } else if (value == 80) {
      text = '80';
    } else if (value == 100) {
      text = '100';
    } else if (value == 120) {
      text = '120';
    } else if (value == 150) {
      text = '150';
    } else if (value == marketingOfficers.value) {
      text = marketingOfficers.value.toString();
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2, double y3) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: leftBarColor,
          width: attendanceReport.length.toDouble(),
        ),
        BarChartRodData(
          toY: y3,
          color: midBarColor,
          width: attendanceReport.length.toDouble(),
        ),
        BarChartRodData(
          toY: y2,
          color: rightBarColor,
          width: attendanceReport.length.toDouble(),
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }

  getReportGraph() async {
    try {
      loadingReport.value = true;
      reportGraph.value = await apiController.getReportGraph();
      print(reportGraph.value.year!.length);
      loadingReport.value = false;
    } on HttpException catch (e) {
      loadingReport.value = false;
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      loadingReport.value = false;
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}

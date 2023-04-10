// ignore_for_file: invalid_use_of_protected_member, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/home_controller.dart';
import 'package:marketing/src/user/widgets/attendanceItem.dart';
import 'package:marketing/src/user/widgets/attendance_infoItem.dart';
import 'package:marketing/src/user/widgets/connection_status.dart';
import 'package:marketing/src/user/widgets/profile_card.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class AttendancePage extends StatelessWidget {
  AttendancePage({
    super.key,
    required this.home,
  });
  HomeController home;

  Future<void> refresh() async {
    home.getAttendance(
      months: DateTime.now().month.toString(),
      years: DateTime.now().year.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: SingleChildScrollView(
        physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const ConnectionStatus(),
            InkWell(
              onTap: () {
                Get.toNamed(AppConfig.PROFILE);
              },
              child: const ProfileCard(),
            ),
            Obx(
              () => SfCalendar(
                blackoutDates: home.blackoutDates.value,
                view: CalendarView.month,
                cellBorderColor: AppConfig.primaryColor7,

                monthCellBuilder: (context, details) {
                  String? status = home.attendance[
                          '${details.date.year}-${details.date.month}-${details.date.day}']
                      .toString();

                  return Obx(
                    () => home.loadingAttendance.isTrue
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: status == '1'
                                    ? Colors.green.withOpacity(0.7)
                                    : status == '0'
                                        ? Colors.red.withOpacity(0.7)
                                        : status == "0.5"
                                            ? Colors.orange.withOpacity(0.7)
                                            : Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Text(
                                      details.date.day.toString(),
                                      style: GoogleFonts.firaSans(
                                        fontSize: 12,
                                        color: status == '1'
                                            ? Colors.white
                                            : status == '0'
                                                ? Colors.white
                                                : status == "0.5"
                                                    ? Colors.white
                                                    : Colors.black,
                                      ),
                                    ),
                                  ),
                                  details.date.weekday != 7
                                      ? Container()
                                      : Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            '---',
                                            style: TextStyle(
                                              color:
                                                  Colors.red.withOpacity(0.7),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            ),
                          ),
                  );
                },

                onViewChanged: (viewChangedDetails) async {
                  print("New : ${viewChangedDetails.visibleDates[14].year}");
                  print(viewChangedDetails.visibleDates[14].month);
                  await home.getAttendance(
                    months:
                        viewChangedDetails.visibleDates[14].month.toString(),
                    years: viewChangedDetails.visibleDates[14].year.toString(),
                  );
                  print("New Attendance :${home.attendance}");
                },
                // viewNavigationMode: ViewNavigationMode.none,
                // allowViewNavigation: false,
                onTap: (calendarTapDetails) {
                  Get.bottomSheet(
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: Colors.white,
                      ),
                      child: AttendanceItem(
                        date:
                            '${calendarTapDetails.date!.year}-${calendarTapDetails.date!.month}-${calendarTapDetails.date!.day}',
                        homeController: home,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AttendanceInfoItem(color: Colors.green, value: "Present"),
                  AttendanceInfoItem(color: Colors.red, value: "Absent"),
                  AttendanceInfoItem(color: Colors.orange, value: "Half Day"),
                ],
              ),
            ),
            Obx(() {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Total Distance: ',
                      style: GoogleFonts.firaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      home.distance.toString(),
                      style: GoogleFonts.firaSans(
                        fontSize: 20,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

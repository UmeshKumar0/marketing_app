import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/my_meeting_controller.dart';

class CreatedMeetings extends StatelessWidget {
  CreatedMeetings({
    super.key,
    required this.controller,
  });
  MyMeetingController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppConfig.primaryColor5,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(() {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: controller.today.value == 0
                        ? Text(
                            'Loading...',
                            style: GoogleFonts.firaSans(
                              color: AppConfig.primaryColor5,
                              fontSize: 15,
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              controller.cupertinoDatePicker(
                                current: true,
                              );
                            },
                            child: Text(
                              DateTime.fromMillisecondsSinceEpoch(
                                      controller.today.value)
                                  .toString()
                                  .split(' ')
                                  .first,
                              style: GoogleFonts.poppins(
                                color: AppConfig.primaryColor5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                  );
                }),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'TO',
                    style: GoogleFonts.firaSans(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Obx(() {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: controller.today.value == 0
                        ? Text(
                            'Loading...',
                            style: GoogleFonts.firaSans(
                              color: AppConfig.primaryColor5,
                              fontSize: 15,
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              controller.cupertinoDatePicker(current: false);
                            },
                            child: Text(
                              DateTime.fromMillisecondsSinceEpoch(
                                      controller.tomorrow.value)
                                  .toString()
                                  .split(' ')
                                  .first,
                              style: GoogleFonts.poppins(
                                color: AppConfig.primaryColor5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                  );
                }),
              ],
            ),
          ),
        ),
        Expanded(
          child: Obx(
            () {
              return controller.isLoading.isTrue
                  ? Image.asset(
                      'assets/preloader.gif',
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    )
                  : controller.isError.isTrue
                      ? Container(
                          alignment: Alignment.center,
                          child: Text(
                            controller.errorMessage.value,
                            style: GoogleFonts.firaSans(
                              color: Colors.red,
                            ),
                          ),
                        )
                      : controller.createdMeetingList.isEmpty
                          ? Container(
                              alignment: Alignment.center,
                              child: Text(
                                'No Meeting created by you',
                                style: GoogleFonts.firaSans(
                                  color: Colors.red,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemBuilder: (context, index) {
                                return controller
                                            .createdMeetingList[index].shop ==
                                        null
                                    ? ListTile(
                                        leading: Icon(
                                          Icons.meeting_room,
                                          color: AppConfig.primaryColor5,
                                        ),
                                        title: Text(
                                          'No Shop',
                                          style: GoogleFonts.firaSans(
                                            color: Colors.red,
                                          ),
                                        ),
                                        subtitle: Text(controller
                                            .createdMeetingList[index].date!
                                            .toString()
                                            .split(' ')
                                            .first),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        child: ListTile(
                                          tileColor: Colors.white,
                                          onTap: () {},
                                          leading: Icon(
                                            Icons.meeting_room,
                                            color: AppConfig.primaryColor5,
                                          ),
                                          title: Text(
                                            '${controller.createdMeetingList[index].shop!.name}',
                                            style: GoogleFonts.firaSans(
                                              color: Colors.green,
                                            ),
                                          ),
                                          subtitle: Text(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                    controller
                                                        .createdMeetingList[
                                                            index]
                                                        .date!)
                                                .toLocal()
                                                .toString().split(' ').first,
                                          ),
                                        ),
                                      );
                              },
                              itemCount: controller.createdMeetingList.length,
                            );
            },
          ),
        )
      ],
    );
  }
}

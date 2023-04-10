import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/my_meeting_controller.dart';
import 'package:marketing/src/user/widgets/meetings/meeting_details.dart';
import 'package:marketing/src/user/widgets/meetings/meeting_header.dart';
import 'package:marketing/src/user/widgets/meetings/meeting_images.dart';
import 'package:marketing/src/user/widgets/meetings/meeting_location.dart';
import 'package:marketing/src/user/widgets/stylish_button.dart';

class AssignedMeetings extends StatelessWidget {
  AssignedMeetings({
    super.key,
    required this.controller,
  });
  MyMeetingController controller;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.isLoading.isTrue
          ? Image.asset(
              "assets/preloader.gif",
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            )
          : controller.isError.isTrue
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        controller.errorMessage.value,
                        style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        controller.fetchMeetings();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await controller.fetchMeetings();
                  },
                  child: controller.myMeetingList.isEmpty
                      ? Center(
                          child: Text(
                            'No Meetings Found for you',
                            style: GoogleFonts.firaSans(),
                          ),
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white),
                              child: Card(
                                elevation: 2,
                                child: Column(
                                  children: [
                                    MeetingHeader(
                                      name:
                                          '${controller.myMeetingList.value[index].shop == null ? 'SHOP NAME' : controller.myMeetingList.value[index].shop!.name}',
                                      number:
                                          '${controller.myMeetingList.value[index].shop == null ? '9508649243' : controller.myMeetingList.value[index].shop!.phone}',
                                      status:
                                          '${controller.myMeetingList.value[index].shop == null ? 'ACTIVE' : controller.myMeetingList.value[index].status}',
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                    MeetingDetails(
                                      strength: controller
                                          .myMeetingList.value[index].strength
                                          .toString(),
                                      images: controller.myMeetingList
                                          .value[index].gallery!.length
                                          .toString(),
                                      meeting:
                                          controller.myMeetingList.value[index],
                                    ),
                                    MeetingLocation(
                                      controller: controller,
                                      meeting:
                                          controller.myMeetingList.value[index],
                                    ),
                                    controller.myMeetingList.value[index]
                                                .status ==
                                            'PENDING'
                                        ? Obx(() {
                                            return InkWell(
                                              onTap: () {
                                                if (controller
                                                    .updatingMeeting.isTrue) {
                                                  Fluttertoast.showToast(
                                                      msg: 'Please wait...');
                                                } else {
                                                  controller.updateMeeting(
                                                    status: 'APPROVED',
                                                    meetingId: controller
                                                        .myMeetingList
                                                        .value[index]
                                                        .sId
                                                        .toString(),
                                                  );
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                    vertical: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.lightGreen,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: controller
                                                          .updatingMeeting
                                                          .isTrue
                                                      ? const CircularProgressIndicator()
                                                      : Text(
                                                          'Accept Meeting',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            );
                                          })
                                        : controller.myMeetingList.value[index]
                                                    .status ==
                                                'REJECTED'
                                            ? Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Meeting is Rejected by Admin',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.red,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            : controller.myMeetingList
                                                        .value[index].status ==
                                                    "COMPLETED"
                                                ? Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'This meeting is completed',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  )
                                                : Obx(() {
                                                    return controller.images
                                                                    .value[
                                                                controller
                                                                    .myMeetingList
                                                                    .value[
                                                                        index]
                                                                    .sId] ==
                                                            null
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: Row(
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    Get.bottomSheet(
                                                                      Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Container(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                    'Action',
                                                                                    style: GoogleFonts.poppins(
                                                                                      color: Colors.black,
                                                                                      fontSize: 18,
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      Get.back();
                                                                                    },
                                                                                    child: const Icon(
                                                                                      Icons.close,
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 20,
                                                                                ),
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    controller.getImages(
                                                                                      meetingId: controller.myMeetingList.value[index].sId.toString(),
                                                                                      isCamera: false,
                                                                                      callback: () {
                                                                                        Fluttertoast.showToast(
                                                                                          msg: 'Image added',
                                                                                        );
                                                                                        Get.back();
                                                                                      },
                                                                                    );
                                                                                  },
                                                                                  child: StylishIconButton(
                                                                                    iconData: Icons.upload,
                                                                                    text: "Upload",
                                                                                  ),
                                                                                ),
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    controller.getImages(
                                                                                      meetingId: controller.myMeetingList.value[index].sId.toString(),
                                                                                      isCamera: true,
                                                                                      callback: () {
                                                                                        Fluttertoast.showToast(
                                                                                          msg: 'Image added',
                                                                                        );
                                                                                        Get.back();
                                                                                      },
                                                                                    );
                                                                                  },
                                                                                  child: StylishIconButton(
                                                                                    iconData: Icons.camera,
                                                                                    text: "Camera",
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          10,
                                                                    ),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: AppConfig
                                                                          .primaryColor5,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .upload,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          'Add Images',
                                                                          style:
                                                                              GoogleFonts.poppins(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        Container()),
                                                                InkWell(
                                                                  onTap: () {
                                                                    Get.toNamed(
                                                                      AppConfig
                                                                          .MEETING_RESPONSE,
                                                                      arguments:
                                                                          controller
                                                                              .myMeetingList[index],
                                                                    );
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          10,
                                                                    ),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: AppConfig
                                                                          .primaryColor5,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .done,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          'Close Meeting',
                                                                          style:
                                                                              GoogleFonts.poppins(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        : MeetingImages(
                                                            meetingController:
                                                                controller,
                                                            meetingId: controller
                                                                .myMeetingList
                                                                .value[index]
                                                                .sId
                                                                .toString(),
                                                            shopId: controller
                                                                .myMeetingList
                                                                .value[index]
                                                                .shop!
                                                                .sId
                                                                .toString(),
                                                          );
                                                  }),
                                    Divider(
                                      color: Colors.grey.shade300,
                                      thickness: 1,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color:
                                                      AppConfig.primaryColor5,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    controller.myMeetingList
                                                        .value[index].user!.name
                                                        .toString()
                                                        .substring(0, 1),
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                controller
                                                            .myMeetingList
                                                            .value[index]
                                                            .user!
                                                            .name
                                                            .toString()
                                                            .length >
                                                        30
                                                    ? "${controller.myMeetingList[index].user!.name.toString().substring(0, 30)}..."
                                                    : controller
                                                        .myMeetingList[index]
                                                        .user!
                                                        .name
                                                        .toString(),
                                                style: GoogleFonts.poppins(
                                                  color:
                                                      AppConfig.primaryColor5,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons.calendar_month,
                                                color: AppConfig.primaryColor5,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                DateTime.fromMillisecondsSinceEpoch(
                                                        controller
                                                            .myMeetingList
                                                            .value[index]
                                                            .date as int)
                                                    .toString()
                                                    .split(' ')
                                                    .first,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: controller.myMeetingList.value.length,
                        ),
                );
    });
  }
}

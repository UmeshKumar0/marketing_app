import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/meetings_controller.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:marketing/src/user/models/meetings/meeting_model.dart';
import 'package:marketing/src/user/models/meetings/meeting_user.dart';

class MeetingUserItem extends StatefulWidget {
  MeetingUserItem({
    super.key,
    required this.meetingUser,
  });
  MeetingUser? meetingUser;

  @override
  State<MeetingUserItem> createState() => _MeetingUserItemState();
}

class _MeetingUserItemState extends State<MeetingUserItem> {
  bool showDate = true;
  changeDate() {
    setState(() {
      showDate = !showDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(
                  0.3,
                ),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                widget.meetingUser == null
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        child: InkWell(
                          onTap: changeDate,
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  alignment: Alignment.center,
                                  child: widget.meetingUser!.profile != null &&
                                          widget.meetingUser!.profile!
                                                  .thumbnailUrl !=
                                              null
                                      ? Image.network(
                                          '${AppConfig.SERVER_IP}${widget.meetingUser!.profile!.thumbnailUrl}',
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(Icons.person);
                                          },
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            return loadingProgress == null
                                                ? child
                                                : const CircularProgressIndicator();
                                          },
                                        )
                                      : Icon(
                                          Icons.person,
                                          color: AppConfig.primaryColor7,
                                        ),
                                ),
                                Text(
                                  widget.meetingUser!.name!.length > 20
                                      ? '${widget.meetingUser!.name!.substring(0, 20)}...'
                                      : widget.meetingUser!.name.toString(),
                                  style: GoogleFonts.firaSans(
                                    color: AppConfig.primaryColor7,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: changeDate,
                                        icon: Icon(
                                          showDate
                                              ? Icons.keyboard_double_arrow_up
                                              : Icons
                                                  .keyboard_double_arrow_down,
                                          color: AppConfig.primaryColor7,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                showDate
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Text(
                              "Meeting status of 7 days",
                              style: GoogleFonts.firaSans(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 10,
                                height: 5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Exist',
                                style: GoogleFonts.firaSans(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 10,
                                height: 5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Not Exist',
                                style: GoogleFonts.firaSans(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(),
                showDate
                    ? SizedBox(
                        height: MediaQuery.of(context).size.width / 7 + 10,
                        child: GetX<MeetingsController>(builder: (controler) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GetX<StorageController>(
                                builder: (storage) {
                                  return DateItem(
                                    onTap: (value) {
                                      MeetingModel? meeting =
                                          storage.meetingModelBox.get(
                                              '${controler.days.value[index]}-${widget.meetingUser!.sId}');
                                      if (meeting != null) {
                                        Get.bottomSheet(
                                          Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Meetings Details",
                                                        style: GoogleFonts
                                                            .firaSans(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 18),
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        icon: const Icon(
                                                            Icons.clear),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                ListTile(
                                                  leading: Icon(Icons.person),
                                                  title: Text(
                                                    "Shop",
                                                    style: GoogleFonts.firaSans(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    meeting.shop!.name
                                                        .toString(),
                                                    style:
                                                        GoogleFonts.firaSans(),
                                                  ),
                                                ),
                                                ListTile(
                                                  leading: Icon(Icons.person),
                                                  title: Text(
                                                    "For Officer",
                                                    style: GoogleFonts.firaSans(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    widget.meetingUser!.name
                                                        .toString(),
                                                    style:
                                                        GoogleFonts.firaSans(),
                                                  ),
                                                ),
                                                ListTile(
                                                  leading: const Icon(
                                                      Icons.lock_clock),
                                                  title: Text(
                                                    "Date",
                                                    style: GoogleFonts.firaSans(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    DateTime.fromMillisecondsSinceEpoch(
                                                            meeting.date as int)
                                                        .toString()
                                                        .split(' ')
                                                        .first,
                                                    style:
                                                        GoogleFonts.firaSans(),
                                                  ),
                                                ),
                                                ListTile(
                                                  leading:
                                                      const Icon(Icons.group),
                                                  title: Text(
                                                    "Others",
                                                    style: GoogleFonts.firaSans(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  subtitle: InkWell(
                                                    onTap: () {},
                                                    child: Text(
                                                      'Tap to see more',
                                                      style:
                                                          GoogleFonts.firaSans(
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                ListTile(
                                                  leading:
                                                      const Icon(Icons.group),
                                                  title: Text(
                                                    "Status",
                                                    style: GoogleFonts.firaSans(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    meeting.status.toString(),
                                                    style: GoogleFonts.firaSans(
                                                      color: meeting.status ==
                                                              "APPROVED"
                                                          ? Colors.green
                                                          : meeting.status ==
                                                                  "REJECTED"
                                                              ? Colors.red
                                                              : meeting.status ==
                                                                      "PENDING"
                                                                  ? Colors
                                                                      .orange
                                                                  : Colors
                                                                      .black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          isDismissible: true,
                                        );
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: "No meeting found for this date",
                                        );
                                      }
                                    },
                                    color: storage.meetingModelBox.get(
                                                '${controler.days.value[index]}-${widget.meetingUser!.sId}') !=
                                            null
                                        ? Colors.blue
                                        : AppConfig.lightBG,
                                    date: controler.days.value[index],
                                    textColor: storage.meetingModelBox.get(
                                                '${controler.days.value[index]}-${widget.meetingUser!.sId}') !=
                                            null
                                        ? Colors.white
                                        : Colors.blue,
                                  );
                                },
                              );
                            },
                            itemCount: controler.days.length,
                          );
                        }),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateItem extends StatelessWidget {
  DateItem({
    super.key,
    required this.color,
    required this.textColor,
    required this.date,
    required this.onTap,
  });
  Color color;
  Color textColor;
  String date;
  Function onTap;
  MeetingModel? meeting;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 7;
    double height = width;
    return InkWell(
      onTap: () {
        onTap(date);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 3,
          vertical: 5,
        ),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            date.split('-')[2],
            style: GoogleFonts.firaSans(color: textColor),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/my_meeting_controller.dart';
import 'package:marketing/src/user/models/mymeeting_model.dart';

class MeetingLocation extends StatelessWidget {
  MeetingLocation({
    super.key,
    required this.controller,
    required this.meeting,
  });

  MyMeetingController controller;
  MyMeetingModel meeting;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on,
                color: Colors.grey.shade500,
                size: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                meeting.shop == null
                    ? "NOT FOUND"
                    : meeting.shop!.mapAddress.toString().length > 18
                        ? "${meeting.shop!.mapAddress.toString().substring(0, 18)}..."
                        : meeting.shop!.mapAddress.toString(),
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade500,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              controller.openMap(
                meeting: meeting,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppConfig.primaryColor5,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'View Map',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

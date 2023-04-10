import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/models/mymeeting_model.dart';

class MeetingDetails extends StatelessWidget {
  MeetingDetails({
    super.key,
    required this.strength,
    required this.images,
    required this.meeting,
  });
  String strength;
  String images;
  MyMeetingModel meeting;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.group,
                color: Colors.grey.shade500,
                size: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                strength,
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade500,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.image,
                color: Colors.grey.shade500,
                size: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                images,
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
              Get.dialog(
                AlertDialog(
                  title: Text(
                    'Image Preview',
                    style: GoogleFonts.firaSans(
                      color: Colors.black,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 300,
                        child: meeting.gallery!.isEmpty
                            ? Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Images not uploaded yet',
                                  style: GoogleFonts.firaSans(
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            : PageView.builder(
                                itemBuilder: (context, index) {
                                  return ClipRRect(
                                    child: Image.network(
                                      '${AppConfig.SERVER_IP}/${meeting.gallery![index]['url']}',
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                                itemCount: meeting.gallery!.length,
                              ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Swip left and right to see more images',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('Back'),
                    )
                  ],
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppConfig.primaryColor5,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'View Gallery',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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

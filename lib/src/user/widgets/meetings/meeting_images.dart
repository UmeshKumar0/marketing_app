import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/my_meeting_controller.dart';
import 'package:marketing/src/user/widgets/stylish_button.dart';

class MeetingImages extends StatefulWidget {
  MeetingImages({
    super.key,
    required this.meetingController,
    required this.meetingId,
    required this.shopId,
  });

  MyMeetingController meetingController;
  String meetingId;
  String shopId;

  @override
  State<MeetingImages> createState() => _MeetingImagesState();
}

class _MeetingImagesState extends State<MeetingImages> {
  int imgCount = 0;
  bool uploadingImage = false;
  uploadImages() async {
    widget.meetingController.changeState(value: true);
    try {
      uploadingImage = true;
      imgCount = 0;
      setState(() {});
      List<String> images = widget.meetingController.images[widget.meetingId]!;
      if (images.isNotEmpty) {
        for (String img in images) {
          bool status = await widget.meetingController.uploadMeetingImage(
            meetingId: widget.meetingId,
            imgpath: img,
            shopId: widget.shopId,
          );
          if (status) {
            imgCount++;
            setState(() {});
          }
        }
        uploadingImage = false;
        widget.meetingController.images.remove(widget.meetingId);
        widget.meetingController.fetchMeetings();
        setState(() {});
      } else {
        uploadingImage = false;
        setState(() {});
        Fluttertoast.showToast(msg: 'Image not found for this images');
      }
    } catch (e) {
      uploadingImage = false;
      setState(() {});
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      uploadingImage = false;
      setState(() {});
    }
    widget.meetingController.changeState(value: false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          uploadingImage
              ? Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppConfig.lightBG,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Uploading.. $imgCount/${widget.meetingController.images[widget.meetingId]!.length}',
                    style: GoogleFonts.poppins(
                      color: AppConfig.primaryColor5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : Container(),
          uploadingImage
              ? Container()
              : Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppConfig.lightBG,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Get.dialog(
                                  AlertDialog(
                                    title: Text(
                                      'Image Preview',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.file(
                                          File(
                                            widget.meetingController.images[
                                                widget.meetingId]![index],
                                          ),
                                          fit: BoxFit.cover,
                                          height: 300,
                                          width: 300,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          widget.meetingController
                                              .images[widget.meetingId]!
                                              .removeAt(index);
                                          Map<String, List<String>> images =
                                              widget.meetingController.images
                                                  .value;
                                          widget.meetingController.images
                                              .value = {};
                                          widget.meetingController.images
                                              .value = images;
                                          if (widget
                                              .meetingController
                                              .images[widget.meetingId]!
                                              .isEmpty) {
                                            widget.meetingController.images
                                                .remove(widget.meetingId);
                                          }
                                          Fluttertoast.showToast(
                                            msg: 'Image removed',
                                          );
                                          Get.back();
                                        },
                                        child: Text(
                                          'Remove',
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.file(
                                      File(
                                        widget.meetingController
                                            .images[widget.meetingId]![index],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: widget.meetingController.images
                              .value[widget.meetingId]!.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          widget.meetingController.images
                              .remove(widget.meetingId);
                        },
                        child: Container(
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                            color: AppConfig.primaryColor5,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
          const SizedBox(
            height: 10,
          ),
          uploadingImage
              ? Container()
              : Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.bottomSheet(
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                        widget.meetingController.getImages(
                                          meetingId:
                                              widget.meetingId.toString(),
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
                                        widget.meetingController.getImages(
                                          meetingId:
                                              widget.meetingId.toString(),
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
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppConfig.primaryColor5,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.image,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Add Another',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: uploadImages,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppConfig.primaryColor5,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.image,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Start Upload',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
        ],
      ),
    );
  }
}

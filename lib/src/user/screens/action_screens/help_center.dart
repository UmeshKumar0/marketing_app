import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/help_controller.dart';

class HelpCenterScreen extends GetView<HelpScreenController> {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (controller.creating.isTrue) {
          Fluttertoast.showToast(
              msg: 'Please wait while we create your ticket');
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          titleSpacing: 0,
          title: Text(
            'Help Center',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.title,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        expands: true,
                        enabled: !controller.creating.value,
                        controller: controller.titleController,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Please Enter Your Query Title',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: TextField(
                    enabled: !controller.creating.value,
                    controller: controller.descriptionController,
                    expands: true,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Please Enter Your Query',
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(() {
                return Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: controller.images.value[index] ==
                                controller.ADD_IMAGE_WIDGET
                            ? InkWell(
                                onTap: () {
                                  if (controller.creating.isTrue) {
                                    Fluttertoast.showToast(
                                        msg:
                                            'We are creating your ticket you can\'t add more images.');
                                  } else {
                                    controller.getImages();
                                  }
                                },
                                child: Container(
                                  height: 120,
                                  width: 80,
                                  color: AppConfig.lightBG,
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/add_images.png",
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  Get.dialog(
                                    AlertDialog(
                                      title: Text('Image Preview'),
                                      content: SizedBox(
                                        height: 300,
                                        width: 300,
                                        child: Image.file(
                                          File(controller.images.value[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text('Close'),
                                        ),
                                        controller.creating.isTrue
                                            ? Container()
                                            : TextButton(
                                                onPressed: () {
                                                  controller.images.value
                                                      .removeAt(index);
                                                  List<String> d =
                                                      controller.images.value;
                                                  controller.images.value = [];
                                                  controller.images.value = d;
                                                  Get.back();
                                                },
                                                child: Text('Remove'),
                                              ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 120,
                                  width: 80,
                                  color: AppConfig.lightBG,
                                  child: Image.file(
                                    File(
                                      controller.images.value[index],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      );
                    },
                    itemCount: controller.images.length,
                  ),
                );
              }),
              const SizedBox(
                height: 10,
              ),
              Obx(
                () {
                  return controller.recordingPath.value == "N/A"
                      ? Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(
                                    0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: controller.isRecording.isTrue
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Icon(
                                      Icons.mic,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Recording...',
                                      style: GoogleFonts.poppins(
                                        color: AppConfig.primaryColor5,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '=> ${controller.timer.value.split('.').first} <=',
                                      style: GoogleFonts.poppins(
                                        color: AppConfig.primaryColor8,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                          onPressed: () {
                                            controller.stopRecording();
                                          },
                                          icon: const Icon(
                                            Icons.stop,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Icon(
                                      Icons.mic,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.startRecording();
                                      },
                                      child: Text(
                                        'Tap here to record your problem.',
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                        )
                      : Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(
                                    0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                Icons.music_note,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "=> ${controller.timer.value.split('.').first} / ",
                                style: GoogleFonts.poppins(
                                  color: AppConfig.primaryColor8,
                                ),
                              ),
                              Text(
                                '${controller.endTimer.value.split('.').first} <=',
                                style: GoogleFonts.poppins(
                                  color: AppConfig.primaryColor8,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        onPressed: () {
                                          if (controller.playingMusic.isTrue) {
                                            controller.stopAudio();
                                          } else {
                                            controller.playAudio();
                                          }
                                        },
                                        icon: controller.playingMusic.isTrue
                                            ? Icon(
                                                Icons.stop,
                                                color: AppConfig.primaryColor5,
                                              )
                                            : const Icon(
                                                Icons.play_arrow,
                                                color: Colors.green,
                                              ),
                                      ),
                                    ),
                                    controller.creating.isTrue
                                        ? Container()
                                        : IconButton(
                                            onPressed: () {
                                              controller.removeEntity();
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(() {
                return InkWell(
                  onTap: () {
                    if (controller.creating.isFalse) {
                      controller.submitForm();
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              'Please wait while we are creating your problem.');
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppConfig.primaryColor5,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset:
                              const Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: controller.creating.isTrue
                        ? CircularProgressIndicator()
                        : Text(
                            'Submit',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 20),
                          ),
                  ),
                );
              }),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(() {
                return controller.creating.isTrue
                    ? Container()
                    : TextButton(
                        onPressed: () {},
                        child: Text(
                          'View My Tickets',
                          style: GoogleFonts.poppins(
                            color: AppConfig.primaryColor5,
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                      );
              })
            ],
          ),
        ),
      ),
    );
  }
}

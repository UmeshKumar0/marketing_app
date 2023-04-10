// ignore_for_file: must_be_immutable, invalid_use_of_protected_member

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/shop_create_controller.dart';
import 'package:marketing/src/user/widgets/cool_button.dart';
import 'package:marketing/src/user/widgets/customButton.dart';

class ShopImages extends StatelessWidget {
  ShopImages({
    Key? key,
    required this.shopController,
  }) : super(key: key);
  ShopCreateController shopController;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: shopController.imagePath.isEmpty
          ? InkWell(
              onTap: () async {
                SystemChannels.textInput.invokeMethod('TextInput.hide');

                Get.bottomSheet(
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          spreadRadius: -10,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Select Image',
                                style: GoogleFonts.firaSans(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: AppConfig.primaryColor7,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: AppConfig.primaryColor7,
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CoolButton(
                                icon: Icons.camera,
                                onTap: () async {
                                  print('Calling this one');
                                  final String image = await Get.toNamed(
                                      AppConfig.CAMERA_SCREEN);
                                  if (image != "N/A" ) {
                                    shopController.pushImage(img: image);
                                    Get.back();
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'No image selected');
                                  }
                                },
                                text: "Camera 1",
                                backgroundColor: AppConfig.primaryColor5,
                                iconColor: Colors.white,
                                textColor: AppConfig.primaryColor5,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              CoolButton(
                                icon: Icons.camera_alt,
                                onTap: () async {
                                  ImagePicker picker = ImagePicker();
                                  final XFile? image = await picker.pickImage(
                                    source: ImageSource.camera,
                                    preferredCameraDevice: CameraDevice.rear,
                                    imageQuality: 50,
                                    maxHeight: 640,
                                    maxWidth: 480,
                                  );

                                  if (image != null) {
                                    shopController.pushImage(img: image.path);
                                    Get.back();
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'No image selected');
                                  }
                                },
                                text: "Camera 2",
                                backgroundColor: AppConfig.primaryColor5,
                                iconColor: Colors.white,
                                textColor: AppConfig.primaryColor5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  isDismissible: false,
                );
              },
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Click to add shop image',
                  style: GoogleFonts.firaSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          : SizedBox(
              height: 65,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.only(left: 2),
                      height: 60,
                      width: 60,
                      child: InkWell(
                        onTap: () {
                          Get.bottomSheet(
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Choose an action',
                                          style: GoogleFonts.firaSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          icon: const Icon(Icons.clear),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    // height: 300,
                                    // width: 300,
                                    child: ClipRRect(
                                      child: Image.file(
                                        File(shopController.imagePath[index]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomButton(
                                    onTap: () {
                                      shopController.removeImage(
                                        path: shopController.imagePath[index],
                                      );
                                      Get.back();
                                    },
                                    text: "Remove Image From List",
                                    color: AppConfig.primaryColor7,
                                  ),
                                ],
                              ),
                            ),
                            isDismissible: false,
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.file(
                            File(shopController.imagePath.value[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: shopController.imagePath.length,
                ),
              ),
            ),
    );
  }
}

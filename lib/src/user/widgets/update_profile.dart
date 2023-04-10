import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/shop_controller.dart';

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ShopController>(builder: (shop) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Update Profile Image',
              style: GoogleFonts.firaSans(
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
            shop.imageUploading.isTrue
                ? Container()
                : IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Get.back();
                    },
                  ),
          ],
        ),
        content: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: shop.profileUrl.value != "N/A"
                ? [
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: ClipRRect(
                        child: Image.file(
                          File(shop.profileUrl.value),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ]
                : [
                    Text(
                      'Select an image ',
                      style: GoogleFonts.firaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
          ),
        ),
        actions: shop.profileUrl.value != "N/A"
            ? [
                shop.imageUploading.isTrue
                    ? Container()
                    : OutlinedButton(
                        onPressed: shop.clearProfileImage,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.blue.withOpacity(0.7)),
                          elevation: MaterialStateProperty.all(3),
                        ),
                        child: Text(
                          'Pick another image',
                          style: GoogleFonts.firaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                shop.imageUploading.isTrue
                    ? const CircularProgressIndicator()
                    : OutlinedButton(
                        onPressed: () async {
                          try {
                            await shop.uploadImage();
                            shop.clearProfileImage();
                            Fluttertoast.showToast(
                                msg: 'Profile Image uploaded');
                            Get.back();
                          } on HttpException catch (e) {
                            Fluttertoast.showToast(msg: e.message);
                          } catch (e) {
                            Fluttertoast.showToast(msg: e.toString());
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              AppConfig.primaryColor7),
                          elevation: MaterialStateProperty.all(3),
                        ),
                        child: Text(
                          'Upload',
                          style: GoogleFonts.firaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
              ]
            : [
                OutlinedButton(
                  onPressed: shop.pickProfileImageFromGallary,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue.withOpacity(0.7)),
                    elevation: MaterialStateProperty.all(3),
                  ),
                  child: Text(
                    'From Gallary',
                    style: GoogleFonts.firaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: shop.pickProfileImageFromCamera,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(AppConfig.primaryColor7),
                    elevation: MaterialStateProperty.all(3),
                  ),
                  child: Text(
                    'From Camera',
                    style: GoogleFonts.firaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
      );
    });
  }
}

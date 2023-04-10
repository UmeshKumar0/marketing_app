// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/dealership_controller.dart';

class ImageSignWidget extends StatelessWidget {
  ImageSignWidget({
    super.key,
    required this.dealerShipController,
  });
  DealerShipController dealerShipController;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(
          left: 50,
          right: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Card(
              elevation: 2,
              child: Container(
                width: 120,
                height: 150,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: dealerShipController.image.value == "N/A"
                    ? InkWell(
                        onTap: () {
                          dealerShipController.getImages(image: true);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_a_photo,
                              size: 30,
                              color: Colors.green,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Text(
                                'Tap Here To Add Image',
                                style: GoogleFonts.firaSans(
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            child: dealerShipController.image.value
                                    .contains('http')
                                ? Image.network(
                                    dealerShipController.image.value,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(dealerShipController.image.value),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                dealerShipController.resetImage(isImage: true);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppConfig.primaryColor7,
                                ),
                                child: const Icon(
                                  Icons.clear,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
              ),
            ),
            Card(
              elevation: 2,
              child: Container(
                width: 120,
                height: 150,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: dealerShipController.signature.value == "N/A"
                    ? InkWell(
                        onTap: () {
                          dealerShipController.getImages(
                            image: false,
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_a_photo,
                              size: 30,
                              color: Colors.green,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Text(
                                'Tap Here To Add Signature',
                                style: GoogleFonts.firaSans(
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            child: dealerShipController.signature.value
                                    .contains('http')
                                ? Image.network(
                                    dealerShipController.signature.value,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(dealerShipController.signature.value),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                dealerShipController.resetImage(isImage: false);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppConfig.primaryColor7,
                                ),
                                child: const Icon(
                                  Icons.clear,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

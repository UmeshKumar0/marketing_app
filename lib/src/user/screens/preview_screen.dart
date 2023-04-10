// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/user/controller/shop_create_controller.dart';
import 'package:marketing/src/user/widgets/stylish_preview.dart';

class ShopPreviewScreen extends StatelessWidget {
  ShopPreviewScreen({
    Key? key,
    required this.shopCreateController,
  }) : super(key: key);
  ShopCreateController shopCreateController;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StylishPreviewItem(
            iconData: Icons.home_work,
            name: shopCreateController.shopCreateData.value.name == Null
                ? "N/A"
                : shopCreateController.shopCreateData.value.name.toString(),
          ),
          StylishPreviewItem(
            iconData: Icons.person,
            name: shopCreateController.shopCreateData.value.shopOwner == Null
                ? "N/A"
                : shopCreateController.shopCreateData.value.shopOwner
                    .toString(),
          ),
          StylishPreviewItem(
            iconData: Icons.email,
            name: shopCreateController.shopCreateData.value.shopEmail == Null ||
                    shopCreateController.shopCreateData.value.shopEmail == ""
                ? "N/A"
                : shopCreateController.shopCreateData.value.shopEmail
                    .toString(),
          ),
          StylishPreviewItem(
            iconData: Icons.phone,
            name: shopCreateController.shopCreateData.value.shopPhone == Null ||
                    shopCreateController.shopCreateData.value.shopPhone == ""
                ? "N/A"
                : shopCreateController.shopCreateData.value.shopPhone
                    .toString(),
          ),
          StylishPreviewItem(
            iconData: Icons.branding_watermark_outlined,
            name: shopCreateController.shopCreateData.value.shopBrand == Null ||
                    shopCreateController.shopCreateData.value.shopBrand == ""
                ? "N/A"
                : shopCreateController.shopCreateData.value.shopBrand
                    .toString(),
          ),
          StylishPreviewItem(
            iconData: Icons.pix_rounded,
            name: shopCreateController.shopCreateData.value.shopProducts == Null
                ? "N/A"
                : shopCreateController.shopCreateData.value.shopProducts
                    .toString(),
          ),
          StylishPreviewItem(
            iconData: Icons.location_city,
            name: shopCreateController.shopCreateData.value.shopAddress ==
                        Null ||
                    shopCreateController.shopCreateData.value.shopAddress == ""
                ? "N/A"
                : shopCreateController.shopCreateData.value.shopAddress
                    .toString(),
          ),
          StylishPreviewItem(
            iconData: Icons.commit_rounded,
            name: shopCreateController.shopCreateData.value.shopPincode ==
                        Null ||
                    shopCreateController.shopCreateData.value.shopPincode == ""
                ? "N/A"
                : shopCreateController.shopCreateData.value.shopPincode
                    .toString(),
          ),
          StylishPreviewItem(
            iconData: Icons.map_outlined,
            name: shopCreateController.shopCreateData.value.shopAddress ==
                        Null ||
                    shopCreateController.shopCreateData.value.shopAddress == ""
                ? "N/A"
                : shopCreateController.shopCreateData.value.shopAddress
                    .toString(),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Colors.white,
            ),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: const Icon(Icons.image, color: Colors.white),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${shopCreateController.imagePath.length} images selected',
                    style: GoogleFonts.firaSans(),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    });
  }
}

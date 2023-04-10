import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/controller/spreview_controller.dart';
import 'package:marketing/src/admin/models/Ashop_model.dart';
import 'package:marketing/src/admin/screens/shop_preview/basic_details.dart';
import 'package:marketing/src/admin/screens/shop_preview/gallery.dart';
import 'package:marketing/src/admin/screens/shop_preview/related_reminder.dart';
import 'package:marketing/src/admin/screens/shop_preview/related_visits.dart';
import 'package:marketing/src/admin/widgets/shop_tabs.dart';
import 'package:get/get.dart';

class AShopPreview extends GetView<SpreviewController> {
  AShopPreview({super.key});
  static String route = '/admin/shop/preview';

  @override
  Widget build(BuildContext context) {
    AShop shop = ModalRoute.of(context)!.settings.arguments as AShop;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        titleSpacing: 0,
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: shop.profile == null
                    ? const Icon(Icons.factory_outlined)
                    : Image.network(
                        '${AppConfig.SERVER_IP}/${shop.profile!.thumbnail}',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.factory_outlined,
                              color: AppConfig.primaryColor5,
                            ),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                shop.name!,
                style: GoogleFonts.firaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
        actions: [
          Obx(() {
            return controller.tabes.indexOf(controller.selectedTab.value) == 2
                ? Switch(
                    value: controller.isPostMode.value,
                    onChanged: (value) {
                      controller.isPostMode.value = value;
                    },
                  )
                : controller.tabes.indexOf(controller.selectedTab.value) == 0
                    ? controller.editingMode.isTrue
                        ? IconButton(
                            onPressed: () {
                              controller.editingMode.value =
                                  !controller.editingMode.value;
                            },
                            icon: Icon(
                              Icons.clear,
                              color: AppConfig.primaryColor5,
                            ))
                        : Container()
                    : Container();
          })
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ShopTab(
            spreviewController: controller,
          ),
          Expanded(
            child: Obx(
              () {
                return IndexedStack(
                  index: controller.tabes.indexOf(controller.selectedTab.value),
                  children: [
                    SBasicDetails(
                      shops: shop,
                      aShopController: controller,
                    ),
                    SGallery(spreviewController: controller),
                    SRelatedVisits(
                      spreviewController: controller,
                    ),
                    SRelatedReminders(),
                  ],
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: Obx(
        () {
          return controller.tabes.indexOf(controller.selectedTab.value) == 0
              ? controller.shopUpdating.isTrue
                  ? FloatingActionButton(
                      onPressed: () {},
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: () {
                        if (controller.editingMode.isTrue) {
                          controller.updateShopDetails();
                        } else {
                          controller.changeEditingMode();
                        }
                      },
                      icon: controller.editingMode.isTrue
                          ? const Icon(Icons.check)
                          : const Icon(Icons.edit),
                      label:
                          Text(controller.editingMode.isTrue ? "Save" : "Edit"),
                    )
              : controller.tabes.indexOf(controller.selectedTab.value) == 1
                  ? ElevatedButton.icon(
                      onPressed: () {
                        Get.dialog(Obx(
                          () {
                            return AlertDialog(
                              title: const Text('Upload Image'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  controller.uploadImage.value != "N/A"
                                      ? Container(
                                          height: 300,
                                          width: 300,
                                          child: Image.file(
                                            File(controller.uploadImage.value),
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Select image and upload to this shop gallery',
                                            style: GoogleFonts.firaSans(
                                              color: Colors.green,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                ],
                              ),
                              actions: controller.uploading.isTrue
                                  ? [
                                      const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    ]
                                  : controller.uploadImage.value != "N/A"
                                      ? [
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              controller.pickImage();
                                            },
                                            child: const Text('Change Image'),
                                          ),
                                          ElevatedButton(
                                            onPressed:
                                                controller.uploadShopImage,
                                            child: const Text('Upload'),
                                          ),
                                        ]
                                      : [
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              controller.pickImage();
                                            },
                                            child: const Text('Select Image'),
                                          ),
                                        ],
                            );
                          },
                        ), barrierDismissible: false);
                      },
                      icon: const Icon(Icons.upload),
                      label: const Text("Image"),
                    )
                  : Container();
        },
      ),
    );
  }
}

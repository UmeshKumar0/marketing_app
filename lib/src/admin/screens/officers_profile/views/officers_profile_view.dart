// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/screens/officers_profile/controller/officer_profile_controller.dart';
import 'package:marketing/src/admin/screens/officers_profile/views/profile_card.dart';
import 'package:marketing/src/admin/screens/officers_profile/views/related_reminders.dart';
import 'package:marketing/src/admin/screens/officers_profile/views/related_shops.dart';
import 'package:marketing/src/admin/screens/officers_profile/views/related_visits.dart';

class OfficersProfileView extends GetView<OfficersProfileController> {
  const OfficersProfileView({super.key});
  static String route = '/admin/officers_profile';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        titleSpacing: 1,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Profile',
          style: GoogleFonts.firaSans(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Obx(
        () {
          return controller.loading.isTrue
              ? Center(
                  child: Image.asset(
                    "assets/preloader.gif",
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AProfileCard(profile: controller.moProfile.value),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.items.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InkWell(
                              onTap: () {
                                controller.changeItem(
                                  i: controller.items[index],
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: controller.selected.value.value ==
                                          controller.items.value[index].value
                                      ? AppConfig.primaryColor5
                                      : Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  controller.items[index].title,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: controller.selected.value.value ==
                              controller.items.value[0].value
                          ? MoRelatedShops(controller: controller)
                          : controller.selected.value.value ==
                                  controller.items.value[1].value
                              ? MoRelatedVisits(controller: controller)
                              : MoRelatedReminders(controller: controller),
                    )
                  ],
                );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/models/AppHeaders_model.dart';
import 'package:marketing/src/admin/models/moProfile.dart';
import 'package:marketing/src/admin/screens/headers_profilelist/controller/headers_profile_controller.dart';
import 'package:marketing/src/admin/screens/officers_profile/views/officers_profile_view.dart';

class HeaderProfileList extends GetView<HeadersProfileController> {
  const HeaderProfileList({super.key});
  static String routeName = '/admin/headers_profilelist';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          controller.title.value,
          style: GoogleFonts.firaSans(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Obx(
        () {
          return controller.isLoading.isTrue
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : controller.singleVisit.isEmpty
                  ? Center(
                      child: Text(
                        'No Data found',
                        style: GoogleFonts.firaSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        return ProfileItem(
                          visit: controller.singleVisit[index],
                          controller: controller,
                        );
                      },
                      itemCount: controller.singleVisit.length,
                    );
        },
      ),
    );
  }
}

class ProfileItem extends StatefulWidget {
  ProfileItem({
    super.key,
    required this.visit,
    required this.controller,
  });
  SingleVisit visit;
  HeadersProfileController controller;

  @override
  State<ProfileItem> createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {
  bool isLoading = false;

  void loadProfileData() async {
    setState(() {
      isLoading = true;
    });
    MOProfile? profile = await widget.controller
        .fetchProfile(userId: widget.visit.sId as String);
    setState(() {
      isLoading = false;
    });
    if (profile != null) {
      Get.toNamed(
        OfficersProfileView.route,
        arguments: profile,
      );
    } else {
      Fluttertoast.showToast(msg: 'No profile found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                // Get.toNamed(
                //   OfficersProfileView.route,
                //   arguments: controller.singleVisit,
                // );
              },
              child: Row(
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          widget.visit.name
                              .toString()
                              .substring(0, 1)
                              .toUpperCase(),
                          style: GoogleFonts.firaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.visit.name == null
                            ? ''
                            : widget.visit.name.toString().length > 15
                                ? '${widget.visit.name.toString().substring(0, 15)}...'
                                : widget.visit.name.toString(),
                        style: GoogleFonts.firaSans(
                          color: AppConfig.primaryColor5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.visit.phone ?? '',
                        style: GoogleFonts.firaSans(
                          color: AppConfig.primaryColor5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                isLoading == true
                    ? Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: AppConfig.primaryColor5,
                        ),
                      )
                    : IconButton(
                        onPressed: loadProfileData,
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: AppConfig.primaryColor5,
                        ),
                      )
              ],
            )
          ],
        ),
      ),
    );
  }
}

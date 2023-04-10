import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/screens/validation/views/ValidationView.dart';
import 'package:marketing/src/user/widgets/tempCodeRunnerFile.dart';
import '../controller/AppPermissionController.dart';

class AppPermissionViews extends GetView<AppPermissionController> {
  const AppPermissionViews({super.key});
  static String routeName = '/admin/apppermission';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StylishName(firstName: "App", lastName: "Permission"),
        centerTitle: true,
      ),
      body: Obx(
        () {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/permission/security.png",
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                alignment: Alignment.center,
                child: Text(
                  'This app requires permission to access your device\'s camera, microphone, location, phone state, storage, and background location. Please Tap on each permission one by one and grant permission to continue.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              PermissionItem(
                title: 'LOCATION (${controller.location.value})',
                image: "assets/permission/location.png",
                onTap: controller.locationPermission,
                color: Colors.white,
              ),
              // PermissionItem(
              //   title:
              //       'BACKGROUND LOCATION (${controller.backgroundLocation.value})',
              //   image: "assets/permission/location.png",
              //   onTap: controller.backgroundLocationPermission,
              //   color: Colors.white,
              // ),
              PermissionItem(
                title: 'CAMERA (${controller.camera.value})',
                image: "assets/permission/camera.png",
                onTap: controller.cameraPermission,
                color: Colors.white,
              ),
              PermissionItem(
                title: 'MIC (${controller.mic.value})',
                image: "assets/permission/mic.png",
                onTap: controller.micPermission,
                color: Colors.white,
              ),
              // PermissionItem(
              //   title: 'PHONE STATE & SMS (${controller.phone.value})',
              //   image: "assets/permission/phone_state.png",
              //   onTap: controller.phonePermission,
              //   color: Colors.white,
              // ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: InkWell(
                  onTap: () {
                    if (controller.camera.isTrue &&
                        controller.location.isTrue &&
                        controller.mic.isTrue) {
                      Get.offAndToNamed(AppConfig.LOGIN_ROUTE);
                    } else {
                      Get.snackbar("Error", "Please grant all permission");
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: AppConfig.primaryColor7,
                    ),
                    child: Text(
                      "NEXT",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class PermissionItem extends StatelessWidget {
  PermissionItem({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
    required this.color,
  });
  String title;
  String image;
  Function onTap;
  Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

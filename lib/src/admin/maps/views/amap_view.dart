import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marketing/src/admin/maps/controller/maps_controller.dart';

class AdminMaps extends GetView<AMapsController> {
  const AdminMaps({super.key});
  static String routeName = '/admin/maps';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
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
          'Maps',
          style: GoogleFonts.firaSans(
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(
        () {
          return controller.mapLoading.isTrue
              ? Image.asset(
                  "assets/preloader.gif",
                  fit: BoxFit.cover,
                )
              : GoogleMap(
                  initialCameraPosition: controller.cameraPosition.value,
                  markers: Set.of(controller.markers.values),
                  polylines: Set.from(
                    [
                      controller.polyline.value,
                    ],
                  ),
                );
        },
      ),
    );
  }
}

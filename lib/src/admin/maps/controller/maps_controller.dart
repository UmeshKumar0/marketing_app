import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marketing/src/AppConfig.dart';

class AMapsController extends GetxController {
  var data;
  RxBool mapLoading = true.obs;
  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  Rx<Polyline> polyline = Polyline(
    polylineId: PolylineId('2'),
    points: [],
    color: Colors.red,
  ).obs;

  Rx<CameraPosition> cameraPosition = CameraPosition(
    target: Get.arguments['center'],
    zoom: 16,
  ).obs;

  @override
  void onInit() {
    data = Get.arguments;
    markers.value = data['markers'];
    Polyline p = Polyline(
      polylineId: PolylineId('2'),
      points: data['points'],
      color: AppConfig.primaryColor5,
    );
    polyline.value = p;
    mapLoading.value = false;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  registerController(GoogleMapController ) {

  }
  
}

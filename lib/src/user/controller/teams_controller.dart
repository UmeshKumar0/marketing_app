import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:get/get.dart';
import 'package:marketing/src/user/models/teams_model.dart';

class TeamsController extends GetxController {
  /* 
    TeamController is used for show all teams of user on map
  */

  /* Instance of ApiController */
  late ApiController apiController;
  /* Instance of CloudController */
  late CloudController cloudController;
  /* UserTeam this variable is obs and used for selected team member */
  Rx<UserTeam> userTeam = UserTeam().obs;

  /* This will notify that the team is seleted */
  RxBool selected = false.obs;

  /* 
    This is used for show all team members on map
    also it's an obs variable so map will update automatically when any change occur
    in this variable
  */
  RxMap<MarkerId, Marker> markers = {
    const MarkerId("mymark"): const Marker(
      markerId: MarkerId("mymark"),
      position: LatLng(25.593819, 85.160530),
    )
  }.obs;

  /* 
    This marker variable is used for show user visited of current day location on map
    This will generate automatically when team member is selected
  */
  RxMap<MarkerId, Marker> userVisits = {
    const MarkerId("mymark"): const Marker(
      markerId: MarkerId("mymark"),
      position: LatLng(25.593819, 85.160530),
    )
  }.obs;

  /* 
    This variable is used for show user current visits on map of current user

  */
  RxBool showVisit = false.obs;

  /* 
    This is used for control the map camera
  */
  Rx<CameraPosition> cameraPosition = const CameraPosition(
    /* 
      This is the default camera position of map
    */
    target: LatLng(
      25.593819,
      85.160530,
    ),
    /* 
      This is the default zoom level of map
    */
    zoom: 16,
  ).obs;

  changeVisitValue() {
    /* 
      This function is responsible for show all the visits of current user on map

      -> first it will check if showVisit is true or false

      if(showVisit.value == true) then it will animate the camera to the current visit location of selected user
    */
    showVisit.value = !showVisit.value;

    if (showVisit.value == true) {
      /* Creating camera position */
      cameraPosition.value = CameraPosition(
        target: userVisits.values.first.position,
        zoom: 16,
      );

      /* This will animate camera to current visit on map  */
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          cameraPosition.value,
        ),
      );
    } else {
      cameraPosition.value = CameraPosition(
        target: LatLng(
          userTeam.value.lastActive!.location!.latitude as double,
          userTeam.value.lastActive!.location!.longitude as double,
        ),
        zoom: 16,
      );
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          cameraPosition.value,
        ),
      );
    }
  }

  TeamsController() {
    /* Loading api controller */
    apiController = Get.find<ApiController>();
    /* Loading cloud controller */
    cloudController = Get.find<CloudController>();
  }

  RxList<UserTeam> teams = <UserTeam>[].obs;
  RxBool loadingTeams = false.obs;
  late GoogleMapController googleMapController;

  void registerLocationListner(
    GoogleMapController cntlr,
    BuildContext context,
  ) async {
    googleMapController = cntlr;
  }

  setCameraPosition({required CameraPosition cameraPosition}) {
    this.cameraPosition.value = cameraPosition;
  }

  getTeams() async {
    try {
      loadingTeams.value = true;
      teams.value = await apiController.getTeams(
        online: cloudController.alive.value,
      );

      print(teams.length);

      Uint8List bytes = await getBytesFromAsset("assets/user_location.png", 90);
      BitmapDescriptor icon = BitmapDescriptor.fromBytes(bytes);
      Map<MarkerId, Marker> markers = {};

      this.markers.value = markers;
      if (teams.isNotEmpty) {
        for (var element in teams) {
          if (element.profile != null &&
              element.profile!.thumbnailUrl != null) {
            icon = await apiController.downloadResizePictureCircle(
              element.profile!.thumbnailUrl.toString(),
              addBorder: true,
              borderColor: Colors.white,
              borderSize: 2,
              size: 120,
            );
          } else {
            Uint8List bytes =
                await getBytesFromAsset("assets/user_location.png", 90);
            icon = BitmapDescriptor.fromBytes(bytes);
          }

          if (element.lastActive != null) {
            markers[MarkerId(element.sId as String)] = Marker(
              markerId: MarkerId(element.sId as String),
              position: LatLng(element.lastActive!.location?.latitude as double,
                  element.lastActive!.location?.longitude as double),
              icon: icon,
              onTap: () {
                Fluttertoast.showToast(msg: 'Team ${element.name} is here');
              },
            );
          }
        }
      }
      loadingTeams.value = false;
    } catch (e) {
      Get.dialog(AlertDialog(
        title: const Text("Error"),
        content: Text(e.toString()),
      ));
    }
  }

  selectTeam({
    required UserTeam team,
  }) async {
    userVisits.clear();
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            team.lastActive!.location?.latitude as double,
            team.lastActive!.location?.longitude as double,
          ),
          zoom: 16,
        ),
      ),
    );
    userTeam.value = team;
    if (userTeam.value.visits != null && userTeam.value.visits!.isNotEmpty) {
      userTeam.value.visits?.forEach((element) {
        userVisits[MarkerId(element.sId as String)] = Marker(
          markerId: MarkerId(element.sId as String),
          position: LatLng(element.location?.latitude as double,
              element.location?.longitude as double),
          icon: BitmapDescriptor.defaultMarker,
          onTap: () {
            Fluttertoast.showToast(msg: 'Team ${element.name} is here');
          },
        );
      });
    }
    selected.value = true;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void onClose() {
    super.onClose();
    googleMapController.dispose();
  }
}

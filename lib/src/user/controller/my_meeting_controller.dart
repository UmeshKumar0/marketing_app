import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/models/meetings/created_meetings.dart';
import 'package:marketing/src/user/models/meetings/meeting_response.dart';
import 'package:marketing/src/user/models/mymeeting_model.dart';

class MyMeetingController extends GetxController {
  String appTitle = 'My Meeting';
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxBool updatingMeeting = false.obs;
  RxString errorMessage = ''.obs;
  late ApiController _apiController;
  RxList<MyMeetingModel> myMeetingList = <MyMeetingModel>[].obs;
  RxList<CreatedMeetings> createdMeetingList = <CreatedMeetings>[].obs;
  RxMap<String, List<String>> images = <String, List<String>>{}.obs;
  RxBool isWorking = false.obs;

  RxInt today = 0.obs;
  RxInt tomorrow = 0.obs;

  @override
  void onInit() {
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(
      const Duration(
        days: 1,
        minutes: 0,
        hours: 0,
        seconds: 0,
      ),
    );
    this.today.value = DateTime(today.year, today.month, today.day, 0, 0, 0)
        .millisecondsSinceEpoch;
    this.tomorrow.value = DateTime(
      tomorrow.year,
      tomorrow.month,
      tomorrow.day,
    ).millisecondsSinceEpoch;
    _apiController = Get.find<ApiController>();
    super.onInit();
  }

  changeState({required bool value}) {
    isWorking.value = value;
  }

  @override
  void onReady() {
    super.onReady();
    fetchMeetings();
  }

  fetchMeetings() async {
    try {
      isError.value = false;
      isLoading.value = true;
      myMeetingList.value = await _apiController.getassignedMeetings();
      isLoading.value = false;
    } on HttpException catch (e) {
      isLoading.value = false;
      isError.value = true;
      errorMessage.value = e.message;
    } catch (e) {
      isLoading.value = false;
      isError.value = true;
      errorMessage.value = e.toString();
    }
  }

  updateMeeting({
    required String status,
    required String meetingId,
  }) async {
    try {
      updatingMeeting.value = true;
      await _apiController.updateMeeting(
        status: status,
        meetingId: meetingId,
        body: [],
      );
      updatingMeeting.value = false;
      fetchMeetings();
    } on HttpException catch (e) {
      updatingMeeting.value = false;
      isError.value = true;
      errorMessage.value = e.message;
    } catch (e) {
      updatingMeeting.value = false;
      isError.value = true;
      errorMessage.value = e.toString();
    }
  }

  @override
  void onClose() {
    print('closing My Meeting Controller');
    super.onClose();
  }

  openMap({required MyMeetingModel meeting}) async {
    double lat = 0.0;
    double long = 0.0;
    if (meeting.shop == null) {
      Fluttertoast.showToast(msg: 'Shop Details not found');
      return;
    } else if (meeting.shop!.location == null) {
      Fluttertoast.showToast(msg: 'Shop Location not found');
      return;
    } else if (meeting.shop!.location!.coordinates == null) {
      Fluttertoast.showToast(msg: 'Shop Location not found');
      return;
    } else {
      lat = meeting.shop!.location!.coordinates![0];
      long = meeting.shop!.location!.coordinates![1];
      GoogleMapController gcl;
      Get.dialog(
        AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (meeting.shop != null &&
                  meeting.shop!.location != null &&
                  meeting.shop!.location!.coordinates != null)
                SizedBox(
                  height: 300,
                  width: 300,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(long, lat),
                      zoom: 15,
                    ),
                    onMapCreated: (controller) {
                      gcl = controller;
                      gcl.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(long, lat),
                            zoom: 15,
                          ),
                        ),
                      );
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId('shop'),
                        position: LatLng(long, lat),
                      ),
                    },
                    mapToolbarEnabled: true,
                    mapType: MapType.terrain,
                  ),
                ),
            ],
          ),
          title: Text('Map for ${meeting.shop!.name}'),
        ),
      );
    }
  }

  getImages(
      {required String meetingId,
      required bool isCamera,
      required Function callback}) async {
    String path = "N/A";
    if (isCamera) {
      path = await Get.toNamed(AppConfig.CAMERA_SCREEN);
    } else {
      ImagePicker imagePicker = ImagePicker();
      XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

      if (file != null) {
        path = file.path;
      }
    }

    if (path != "N/A") {
      if (images.containsKey(meetingId)) {
        images[meetingId]!.add(path);
        Map<String, List<String>> temp = images.value;
        images.value = {};
        images.value = temp;
      } else {
        images[meetingId] = [path];
      }
    }

    callback();
  }

  Future<bool> uploadMeetingImage({
    required String meetingId,
    required String imgpath,
    required String shopId,
  }) async {
    try {
      await _apiController.uploadMeetingImage(
          imagePath: imgpath, meetingId: meetingId, shopId: shopId);
      return true;
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  completeMeeting({
    required MyMeetingModel meeting,
    required List<MeetingResponseModel> meetingResponse,
  }) async {
    updatingMeeting.value = true;
    try {
      List<Map<String, String>> userData =
          meetingResponse.map((e) => e.toJSOn()).toList();
      print(userData);
      await _apiController.updateMeeting(
        meetingId: meeting.sId.toString(),
        status: 'COMPLETED',
        body: userData,
      );
      updatingMeeting.value = false;
    } on HttpException catch (e) {
      updatingMeeting.value = false;
      throw HttpException(e.message);
    } catch (e) {
      updatingMeeting.value = false;
      rethrow;
    }
  }

  getCreatedMeetings() async {
    try {
      isLoading.value = true;
      createdMeetingList.value = await _apiController.getCreatedMeetings(
        endTime: tomorrow.value,
        startTime: today.value,
      );
      print(createdMeetingList.length);
      isError.value = false;
      isLoading.value = false;
    } on HttpException catch (e) {
      isLoading.value = false;
      errorMessage.value = e.message;
      isError.value = true;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
      isError.value = true;
    }
  }

  cupertinoDatePicker({required bool current}) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.fromMillisecondsSinceEpoch(
                    current ? today.value : tomorrow.value),
                onDateTimeChanged: (DateTime newDateTime) {
                  if (current) {
                    today.value = DateTime(
                      newDateTime.year,
                      newDateTime.month,
                      newDateTime.day,
                      0,
                      0,
                    ).millisecondsSinceEpoch;
                  } else {
                    tomorrow.value = DateTime(
                      newDateTime.year,
                      newDateTime.month,
                      newDateTime.day,
                      0,
                      0,
                    ).millisecondsSinceEpoch;
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                getCreatedMeetings();
              },
              child: Text('Done !'),
            )
          ],
        ),
      ),
      isDismissible: false,
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/PermissionManager.dart';
import 'package:marketing/src/admin/screens/admin_home.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/models/Sim.dart';
import 'package:marketing/src/user/models/user_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';

class ValidationController extends GetxController {
  late IO.Socket socket;

  /* Socket connection status */
  List<String> status = ['CONNECTING', 'CONNECTED', 'DISCONNECTED', 'ERROR'];
  RxString connection = 'CONNECTING'.obs;

  RxInt currentInt = 0.obs;
  RxString sokcetId = ''.obs;
  RxString event = ''.obs;

  /* Sms payload */
  String key = 'M4WLK';
  /* Sms receiver */
  int number = 9220592205;

  RxBool sendingRequest = false.obs;
  RxString requestState = ''.obs;
  String base64Data = '';
  RxBool waitingForResponse = true.obs;
  RxString message =
      'Waiting for response from server please stay connected with internet!..'
          .obs;

  late CloudController _cloudController;
  RxList<Sim> simList = <Sim>[].obs;
  RxInt selectedSlot = 5.obs;
  RxInt simSlot = 0.obs;
  RxBool gettingSims = true.obs;

  PermissionManager permissionManager = PermissionManager();
  @override
  void onInit() {
    _cloudController = Get.find<CloudController>();
    init();
    super.onInit();
  }

  init() {
    waitingForResponse.value = true;
    socket = IO.io(
      '${AppConfig.SOCKET}/login',
      IO.OptionBuilder().enableAutoConnect().setTransports(
          ['websocket']).setExtraHeaders({'login': 'true'}).build(),
    );

    permissionManager.getSimNumbers().then((value) {
      simList.value = value;
      gettingSims.value = false;
      selectedSlot.value = simList.first.subsId;
    });

    event.value = generateEvent().toString();
    socket.once(event.value, (data) async {
      waitingForResponse.value = false;
      var decoded = data;
      print(data);
      if (decoded['status'] == false) {
        message.value = decoded['message'];
        Fluttertoast.showToast(
          msg: decoded['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        message.value = 'Login Successfull Redirecting to home page';
        UserModel userModel = UserModel.fromJson(decoded);
        print(userModel.toJson());
        await _cloudController.apiController.storageController
            .setUsermodel(userModel: userModel);
        await _cloudController.apiController.storageController.setAuthorizedSim(
          value:
              '${simSlot.value}@${selectedSlot.value}@${simList[simSlot.value].number}',
        );
        if (userModel.user!.role == "ADMIN") {
          Get.offAndToNamed(AdminHome.adminHomeRoute);
        } else {
          await _cloudController.apiController.gettodayattendancestatus(
            alive: true,
          );
          _cloudController.sync();
          Get.offAndToNamed(AppConfig.HOME_ROUTE);
        }
      }
    });

    socket.connect();
    socket.on('connect', (_) async {
      if (socket.id != null) sokcetId.value = socket.id!;
      connection.value = status[1];
      currentInt.value = 1;
    });

    socket.on('disconnect', (_) {
      currentInt.value = 0;

      connection.value = status[2];
    });

    socket.on('error', (_) {
      currentInt.value = 0;
      connection.value = status[3];
    });
  }

  getSims() async {
    List<Sim> simList = await permissionManager.getSimNumbers();
    this.simList.value = simList;
    gettingSims.value = false;
  }

  generateEvent() {
    var uuid = const Uuid();
    return uuid.v4();
  }

  @override
  void onReady() {
    super.onReady();
  }

  getDeviceInfoandSendToServer() async {
    sendingRequest.value = true;
    requestState.value = 'GENERATING INFO AND ACTIVE PERMISSIONS ...';
    Map<String, String> headers =
        await _cloudController.apiController.storageController.getHeaders();
    requestState.value = 'GENERATING INFO AND ACTIVE PERMISSIONS ... DONE';
    requestState.value = 'ENCODING INFO AND ACTIVE PERMISSIONS ...';
    String data = jsonEncode(headers);
    base64Data = base64Encode(data.codeUnits);
    requestState.value = 'ENCODING INFO AND ACTIVE PERMISSIONS ... DONE';
    requestState.value = 'SENDING SMS';
    String message =
        '$key###${sokcetId.value}###${event.value}###${headers['device']}';

    try {
      await permissionManager.sendSms(
          number.toString(), message, selectedSlot.value);
      currentInt.value = 3;
      Fluttertoast.showToast(msg: 'SMS Sent');
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }

    sendingRequest.value = false;
  }

  cancleAndRetry() {
    waitingForResponse.value = true;
    message.value =
        'Waiting for response from server please stay connected with internet!..';
    socket.clearListeners();
    socket.close();
    init();
  }

  @override
  void onClose() {
    socket.clearListeners();
    socket.close();
    super.onClose();
  }
}

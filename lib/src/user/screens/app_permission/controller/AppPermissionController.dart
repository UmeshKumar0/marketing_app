import 'package:get/get.dart';
import 'package:marketing/src/PermissionManager.dart';

class AppPermissionController extends GetxController {
  PermissionManager permissionManager = PermissionManager();
  RxBool location = false.obs;
  RxBool backgroundLocation = false.obs;
  RxBool camera = false.obs;
  RxBool mic = false.obs;
  RxBool phone = false.obs;
  void onInit() {
    super.onInit();
    checkPermission();
  }

  checkPermission() async {
    if (await permissionManager.checkPermission(PermissionTypes.LOCATION)) {
      location.value = true;
    }
    if (await permissionManager
        .checkPermission(PermissionTypes.BACKGROUND_LOCATION)) {
      backgroundLocation.value = true;
    }
    if (await permissionManager.checkPermission(PermissionTypes.CAMERA)) {
      camera.value = true;
    }
    
    if (await permissionManager.checkPermission(PermissionTypes.MIC)) {
      mic.value = true;
    }
    if (await permissionManager.checkPermission(PermissionTypes.PHONE_STATE) &&
        await permissionManager.checkPermission(PermissionTypes.PHONE_NUMBER) &&
        await permissionManager.checkPermission(PermissionTypes.SMS)) {
      phone.value = true;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  // backgroundLocationPermission() async {
  //   bool background = await permissionManager
  //       .checkPermission(PermissionTypes.BACKGROUND_LOCATION);
  //   if (background == false) {
  //     await permissionManager
  //         .requestPermission(PermissionTypes.BACKGROUND_LOCATION);
  //     backgroundLocationPermission();
  //   } else {
  //     backgroundLocation.value = true;
  //   }
  // }

  locationPermission() async {
    bool status =
        await permissionManager.checkPermission(PermissionTypes.LOCATION);
    if (status == false) {
      await permissionManager.requestPermission(PermissionTypes.LOCATION);
      locationPermission();
    } else {
      location.value = true;
    }
  }

  cameraPermission() async {
    bool status =
        await permissionManager.checkPermission(PermissionTypes.CAMERA);
    if (status == false) {
      await permissionManager.requestPermission(PermissionTypes.CAMERA);
      cameraPermission();
    } else {
      camera.value = true;
    }
  }

  // storagePermission() async {
  //   bool status =
  //       await permissionManager.checkPermission(PermissionTypes.STORAGE);
  //   if (status == false) {
  //     await permissionManager.requestPermission(PermissionTypes.STORAGE);
  //     storagePermission();
  //   } else {
  //     storage.value = true;
  //   }
  // }

  micPermission() async {
    bool status = await permissionManager.checkPermission(PermissionTypes.MIC);
    if (status == false) {
      await permissionManager.requestPermission(PermissionTypes.MIC);
      micPermission();
    } else {
      mic.value = true;
    }
  }

  phonePermission() async {
    bool status =
        await permissionManager.checkPermission(PermissionTypes.PHONE_STATE);
    bool status1 =
        await permissionManager.checkPermission(PermissionTypes.PHONE_NUMBER);
    bool status2 = await permissionManager.checkPermission(PermissionTypes.SMS);
    if (status == false || status1 == false || status2 == false) {
      if (status == false) {
        await permissionManager.requestPermission(PermissionTypes.PHONE_STATE);
      }
      if (status1 == false) {
        await permissionManager.requestPermission(PermissionTypes.PHONE_NUMBER);
      }
      if (status2 == false) {
        await permissionManager.requestPermission(PermissionTypes.SMS);
      }
      phonePermission();
    } else {
      phone.value = true;
    }
  }
}

import 'package:get/get.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:marketing/src/user/models/user_model.dart';

class PaintsController extends GetxController {
  late ApiController apiController;
  late StorageController storageController;
  UserModel user = UserModel();
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    apiController = Get.find<ApiController>();
    storageController = Get.find<StorageController>();
    user = storageController.userModel.value;

    super.onInit();
  }

  getNearByShaops() async {}

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}

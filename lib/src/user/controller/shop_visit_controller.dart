import 'package:get/get.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/models/visit_model.dart';

class ShopVisitController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxString errorMessage = ''.obs;
  RxBool isLoggedOut = false.obs;
  late ApiController _apiController;

  RxList visits = [].obs;

  ShopVisitController() {
    _apiController = Get.find<ApiController>();
  }

  getVisits({required String shopId}) async {
    try {
      isLoading.value = true;
      List<VisitModel> visit = await _apiController.getVisits(
        shopId: shopId,
        online: Get.find<CloudController>().alive.value,
      );
      isLoading.value = false;
      visits.value = visit;
    } on HttpException catch (e) {
      if (e.message == "TOKEN_EXPIRED") {
        isLoading.value = false;
        errorMessage.value = e.message;
        isLoggedOut.value = true;
      } else {
        errorMessage.value = e.message;
        isLoading.value = false;
        isError.value = true;
      }
    } catch (err) {
      errorMessage.value = err.toString();
      isLoading.value = false;
      isError.value = true;
    }
  }
}

import 'dart:async';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/models/shop_model.dart';

class ShopController extends GetxController {
  late ApiController _apiController;
  late CloudController _cloudController;

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  String errMessage = '';

  RxList shops = [].obs;

  RxString profileUrl = 'N/A'.obs;
  RxBool imageUploading = false.obs;

  ShopController() {
    _apiController = Get.find<ApiController>();
    _cloudController = Get.find<CloudController>();
  }
  Timer? _debounce;

  Future<List> getShops({
    required String skip,
    required String limit,
    required String name,
  }) async {
    try {
      List<Shops> shops = await _apiController.getShops(
        skip: skip,
        limit: limit,
        name: name,
        online: _cloudController.alive.value,
      ) as List<Shops>;
      return shops;
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  searchShop({
    required String name,
  }) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 1000), () async {
      isLoading.value = true;
      try {
        List shops = await _apiController.getShops(
          skip: 0.toString(),
          limit: 1000.toString(),
          name: name,
          online: _cloudController.alive.value,
        );

        isLoading.value = false;
        if (shops.isNotEmpty) {
          this.shops.value = shops;
        }
      } on HttpException catch (e) {
        errMessage = e.message;
        isLoading.value = false;
        isError.value = false;
      } catch (e) {
        errMessage = e.toString();
        isLoading.value = false;
        isError.value = false;
      }
    });
  }

  pickProfileImageFromGallary() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      profileUrl.value = file.path;
    }
  }

  pickProfileImageFromCamera() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.camera);

    if (file != null) {
      profileUrl.value = file.path;
    }
  }

  clearProfileImage() {
    profileUrl.value = 'N/A';
  }

  uploadImage() async {
    try {
      imageUploading.value = true;
      await _apiController.updateImageProfile(imagePath: profileUrl.value);
      imageUploading.value = false;
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }
}

import 'package:get/get.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/models/shop_image.dart';

class ShopDetailsController extends GetxController {
  late ApiController _apiController;
  ShopDetailsController() {
    _apiController = Get.find<ApiController>();
  }

  Future<List<ShopImage>> getImages({
    required String id,
    required String ekip,
    required String limit,
  }) async {
    try {
      return await _apiController.getImages(
        id: id,
        skip: ekip,
        limit: limit,
      );
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }
}

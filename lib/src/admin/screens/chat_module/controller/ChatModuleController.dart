import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/controller/admin_api.dart';
import 'package:marketing/src/admin/models/chatuser_model.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatModuleController extends GetxController {
  late IO.Socket socket;
  late StorageController storageController;
  late AdminApi adminApi;

  RxBool connection = false.obs;
  RxBool loadingChatUser = false.obs;
  RxBool connectionError = false.obs;
  String connectionErrorMessage = '';
  RxList<ChatUserModel> chats = <ChatUserModel>[].obs;

  @override
  void onInit() {
    adminApi = Get.find<AdminApi>();
    storageController = Get.find<StorageController>();
    socket = IO.io(
      '${AppConfig.SOCKET}?token=${storageController.userModel.value.token}',
      IO.OptionBuilder()
          .enableAutoConnect()
          .setTransports(['websocket']).setExtraHeaders({
        'token': '${storageController.userModel.value.token}',
      }).build(),
    );
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    socket.connect();
    socket.on('connect', (data) async {
      Fluttertoast.showToast(msg: 'user connected with socket');
      connection.value = true;
      connectionError.value = false;
      await getChatUser();
    });

    socket.on('disconnect', (data) {
      Fluttertoast.showToast(msg: 'user disconnected with socket');
      connection.value = false;
      connectionErrorMessage = 'user disconnected with socket';
      connectionError.value = true;
    });

    socket.on('error', (data) {
      Fluttertoast.showToast(msg: 'user error with socket');
      connection.value = false;
      connectionErrorMessage = 'user error with socket';
      connectionError.value = true;
    });
  }

  getChatUser() async {
    try {
      loadingChatUser.value = true;
      chats.value = await adminApi.getChatUsers();
      loadingChatUser.value = false;
    } on HttpException catch (e) {
      loadingChatUser.value = false;
      connectionError.value = true;
      connectionErrorMessage = e.message;
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      loadingChatUser.value = false;
      connectionError.value = true;
      connectionErrorMessage = e.toString();
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void onClose() {
    socket.clearListeners();
    socket.disconnect();
    super.onClose();
  }
}

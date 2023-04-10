import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/chat/models/chat.models.dart';
import 'package:marketing/src/user/chat/models/message.model.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

List<String> connStatus = ['connecting', 'connect', 'disconnect', 'error'];

class SocketService extends GetxController {
  IO.Socket? socket;
  late StorageController storageController;

  TextEditingController messageController = TextEditingController();

  RxString status = connStatus[0].obs;
  RxList<ChatUsers> users = <ChatUsers>[].obs;
  RxList<Message> messages = <Message>[].obs;
  ScrollController scrollController = ScrollController();
  RxBool enableInput = false.obs;

  Rx<ChatUsers> selected = ChatUsers(
    adminName: "Admin",
    admins: [],
    name: "Admin",
    sId: "Admin",
    type: "Admin",
  ).obs;
  RxBool loadingChats = true.obs;

  void connect() {
    status.value = connStatus[0];
    socket = IO.io(
      '${AppConfig.SOCKET}?token=${storageController.userModel.value.token}',
      IO.OptionBuilder()
          .enableAutoConnect()
          .setTransports(['websocket']).setExtraHeaders({
        'token': '${storageController.userModel.value.token}',
      }).build(),
    );

    socket!.connect();

    if (socket!.connected) {
      status.value = connStatus[1];
    } else {
      status.value = connStatus[2];
    }

    socket!.on('connect', (_) {
      enableInput.value = true;
      print('socket connected with id: ${socket!.id}');
      status.value = connStatus[1];
      getMessagesFromSocket();
    });

    socket!.on('disconnect', (d) {
      enableInput.value = false;
      status.value = connStatus[2];
      print('socket disconnected');
      socket!.clearListeners();
    });
    socket!.on('error', (d) {
      status.value = connStatus[3];
      enableInput.value = false;
    });
  }

  @override
  void onInit() {
    super.onInit();
    storageController = Get.find<StorageController>();
    messages.value = storageController.messageBox.values.toList();
    print(messages.length);
    getChats();
  }

  @override
  void onClose() {
    super.onClose();
    socket!.disconnect();
    socket!.dispose();
    scrollController.dispose();
  }

  getMessagesFromSocket() {
    socket!.on('CHAT_MESSAGE', (data) async {
      print(data);
      Message message = Message.fromJson(data['message']);
      Map<String, Message> messagesMap = {};
      messagesMap[message.sId as String] = message;
      await storageController.setMessage(message: messagesMap);
      messages.add(message);
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 300,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  getMessages() async {
    try {
      String timestamp = await storageController.getChatsLastTimeStamp();

      http.Response response = await http.get(
          Uri.parse(
              '${AppConfig.host}/messages/user?lastTime=$timestamp&chatId=${selected.value.sId}'),
          headers: {
            'authorization':
                'Bearer ${storageController.userModel.value.token}',
          });
      if (response.statusCode == 200) {
        if (json.decode(response.body).length > 0) {
          Map<String, Message> messagesMap = {};
          json.decode(response.body).forEach((v) {
            Message message = Message.fromJson(v);
            messages.add(message);
            messagesMap[message.sId!] = message;
          });
          await storageController.setMessage(message: messagesMap);
          await storageController.setChatsLastTimeStamp(
              value: DateTime.now().millisecondsSinceEpoch.toString());
          scrollController.animateTo(
            scrollController.position.maxScrollExtent + 300,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        } else {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent + 300,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      } else {
        Fluttertoast.showToast(msg: json.decode(response.body)['message']);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  sendMessage() async {
    if (messageController.text.isNotEmpty) {
      socket!.emit('SEND_MESSAGE', {
        'message': messageController.text,
        'chatId': selected.value.sId,
        'type': selected.value.type,
      });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 300,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  getChats() async {
    try {
      http.Response response = await http
          .get(Uri.parse('${AppConfig.host}/chats/user'), headers: {
        'authorization': 'Bearer ${storageController.userModel.value.token}'
      });
      if (response.statusCode != 200) {
        Fluttertoast.showToast(msg: json.decode(response.body)['message']);
      } else {
        List<ChatUsers> u = [];
        if (json.decode(response.body).length > 0) {
          json.decode(response.body).forEach((e) {
            u.add(ChatUsers.fromJson(e));
          });

          users.value = u;
          selected.value = u[0];
        } else {
          users.value = [];
        }

        await getMessages();
        connect();
        status.value = connStatus[3];
        loadingChats.value = false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      loadingChats.value = false;
    }
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:marketing/src/admin/controller/admin_api.dart';
import 'package:marketing/src/admin/models/AChat.dart';
import 'package:marketing/src/admin/models/chatuser_model.dart';
import 'package:marketing/src/admin/screens/chat_module/controller/ChatModuleController.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';

class AdminChatPreviewController extends GetxController {
  ChatUserModel chatUserModel = ChatUserModel();
  late AdminApi adminApi;
  RxBool loadingChats = false.obs;
  RxInt pageSize = 15.obs;
  PagingController<int, AChat> pagingController =
      PagingController(firstPageKey: 0);
  ScrollController scrollController = ScrollController();
  late StorageController storageController;
  late ChatModuleController chatModuleController;
  TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    chatModuleController = Get.find<ChatModuleController>();
    adminApi = Get.find<AdminApi>();
    storageController = Get.find<StorageController>();
    chatUserModel = Get.arguments as ChatUserModel;
    pagingController.addPageRequestListener((pageKey) {
      fetchChats(pageKey: pageKey);
    });
    super.onInit();

    chatModuleController.socket.on('CHAT_MESSAGE', (data) {
      
      pagingController.itemList!.add(AChat(
        admin: false,
        chatId: data['chatId'],
        createdAt: data['message']['createdAt'],
        delivered: data['message']['delivered'],
        message: data['message']['message'],
        messageType: data['message']['messageType'],
        seen: data['message']['seen'],
        sender: data['message']['sender'],
      ));
    });
  }

  sendMessage() {
    chatModuleController.socket.emit('ADMIN_SEND_MESSAGE', {
      'chatId': chatUserModel.sId.toString(),
      'message': messageController.text,
      'to': chatUserModel.userIds != null
          ? chatUserModel.userIds!.first.sId
          : null,
      'type': chatUserModel.type,
    });
    messageController.text = '';
  }

  fetchChats({
    required int pageKey,
  }) async {
    try {
      List<AChat> chats = await adminApi.getChats(
        chatId: chatUserModel.sId.toString(),
        skip: (pageKey / pageSize.value).toInt(),
        limit: pageSize.value,
      );

      if (chats.length < pageSize.value) {
        chats.add(AChat(
          admin: false,
          chatId: 'END',
          createdAt: DateTime.now().toString(),
          delivered: false,
          message: 'No More Messages Found',
        ));
        pagingController.appendLastPage(chats);
      } else {
        final nextPageKey = pageKey + pageSize.value;
        pagingController.appendPage(chats, nextPageKey);
      }
      animateToEnd();
    } on HttpException catch (e) {
      pagingController.error = e.message;
    } catch (e) {
      pagingController.error = e.toString();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  animateToEnd() {
    // Future.delayed(const Duration(milliseconds: 100), () {
    //   scrollController.animateTo(
    //     scrollController.position.,
    //     duration: const Duration(milliseconds: 500),
    //     curve: Curves.easeOut,
    //   );
    // });
  }
}

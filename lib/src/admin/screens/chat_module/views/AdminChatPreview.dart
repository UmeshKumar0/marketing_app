import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/models/AChat.dart';
import 'package:marketing/src/admin/screens/chat_module/controller/chat_preview_controller.dart';

class AdminChatPreview extends GetView<AdminChatPreviewController> {
  const AdminChatPreview({super.key});
  static String routeName = '/admin/chat-preview';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          '${controller.chatUserModel.userIds!.first.name}',
          style: GoogleFonts.firaSans(
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: PagedListView(
          scrollController: controller.scrollController,
          reverse: true,
          pagingController: controller.pagingController,
          builderDelegate: PagedChildBuilderDelegate<AChat>(
            itemBuilder: (context, item, index) {
              return item.chatId == 'END'
                  ? Container(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('No more messages'),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: controller.storageController
                                    .userModel.value.user!.sId ==
                                item.sender
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            alignment: controller.storageController.userModel
                                        .value.user!.sId ==
                                    item.sender
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: controller.storageController.userModel
                                            .value.user!.sId ==
                                        item.sender
                                    ? AppConfig.primaryColor5
                                    : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(10),
                                  topRight: const Radius.circular(10),
                                  bottomLeft: controller.storageController
                                              .userModel.value.user!.sId ==
                                          item.sender
                                      ? const Radius.circular(10)
                                      : const Radius.circular(0),
                                  bottomRight: controller.storageController
                                              .userModel.value.user!.sId ==
                                          item.sender
                                      ? const Radius.circular(0)
                                      : const Radius.circular(10),
                                ),
                              ),
                              child: Text(
                                item.message as String,
                                style: GoogleFonts.poppins(
                                  color: controller.storageController.userModel
                                              .value.user!.sId ==
                                          item.sender
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
      bottomSheet: Container(
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.attach_file,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller.messageController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a message',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.sendMessage();
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.camera_alt,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

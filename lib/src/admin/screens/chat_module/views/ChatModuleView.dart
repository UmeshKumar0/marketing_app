import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/admin/screens/chat_module/views/AdminChatPreview.dart';
import '../controller/ChatModuleController.dart';

class ChatModuleViews extends GetView<ChatModuleController> {
  const ChatModuleViews({super.key});
  static String routeName = '/admin/chatmodule';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Admin Chat',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Obx(() {
        return controller.connection.isFalse
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : controller.connectionError.isTrue
                ? Center(
                    child: Text(controller.connectionErrorMessage),
                  )
                : controller.loadingChatUser.isTrue
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          Text('Loading Chat User...'),
                        ],
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              Get.toNamed(AdminChatPreview.routeName,
                                  arguments: controller.chats[index]);
                            },
                            title: Text(controller.chats[index].userIds!.isEmpty
                                ? ''
                                : controller.chats[index].userIds![0].name ??
                                    'NOT FOUND'),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (controller.chats[index].lastMessage !=
                                        null &&
                                    controller.chats[index].lastMessage!
                                            .runtimeType !=
                                        String)
                                  Flexible(
                                    child: Text(
                                      controller.chats[index].lastMessage ==
                                              null
                                          ? 'No Message'
                                          : controller.chats[index].lastMessage!
                                                  .message ??
                                              '',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                if (controller.chats[index].lastMessage ==
                                        null ||
                                    controller.chats[index].lastMessage!
                                            .runtimeType ==
                                        String)
                                  Text(""),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    controller.chats[index].count == null
                                        ? ''
                                        : controller.chats[index].count!
                                            .toString(),
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            leading: CircleAvatar(
                              child: Text(
                                controller.chats[index].name == null
                                    ? 'NOT FOUND'
                                    : controller.chats[index].name![0],
                              ),
                            ),
                          );
                        },
                        itemCount: controller.chats.length,
                      );
      }),
    );
  }
}

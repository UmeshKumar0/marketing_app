import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/chat/controller/socket_service.dart';
import 'package:marketing/src/user/chat/models/chat.models.dart';
import 'package:marketing/src/user/chat/views/chat_switcher.dart';

class ChatsScreen extends GetView<SocketService> {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
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
        leadingWidth: 30,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Obx(() {
              return controller.loadingChats.isTrue
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.bottomSheet(
                              ChatSwitcher(
                                users: controller.users,
                                onSelect: (ChatUsers user) {},
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                controller.selected.value.name as String,
                                style: GoogleFonts.firaSans(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down,
                                  color: Colors.black),
                            ],
                          ),
                        ),
                        Obx(() {
                          return Text(
                            controller.status.value == 'connect'
                                ? 'Alive'
                                : 'Offline',
                            style: GoogleFonts.poppins(
                                color: controller.status.value == 'error' ||
                                        controller.status.value ==
                                            'disconnected'
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.w400,
                                fontSize: 10),
                          );
                        })
                      ],
                    );
            })
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: Stack(
          children: [
            Image.asset("assets/background.png", fit: BoxFit.fill),
            Obx(() {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  controller: controller.scrollController,
                  reverse: false,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: controller.messages[index].sender ==
                                controller
                                    .storageController.userModel.value.user!.sId
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            alignment: controller.messages[index].sender ==
                                    controller.storageController.userModel.value
                                        .user!.sId
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: controller.messages[index].sender ==
                                        controller.storageController.userModel
                                            .value.user!.sId
                                    ? AppConfig.primaryColor5
                                    : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(10),
                                  topRight: const Radius.circular(10),
                                  bottomLeft:
                                      controller.messages[index].sender ==
                                              controller.storageController
                                                  .userModel.value.user!.sId
                                          ? const Radius.circular(10)
                                          : const Radius.circular(0),
                                  bottomRight:
                                      controller.messages[index].sender ==
                                              controller.storageController
                                                  .userModel.value.user!.sId
                                          ? const Radius.circular(0)
                                          : const Radius.circular(10),
                                ),
                              ),
                              child: Text(
                                controller.messages[index].message as String,
                                style: GoogleFonts.poppins(
                                  color: controller.messages[index].sender ==
                                          controller.storageController.userModel
                                              .value.user!.sId
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
                  itemCount: controller.messages.length,
                ),
              );
            })
          ],
        ),
      ),
      bottomSheet: Obx(() {
        return controller.enableInput.isFalse
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                child: Text(
                  'There is some error in connection, please try again later',
                  style: GoogleFonts.poppins(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              )
            : Container(
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
              );
      }),
    );
  }
}

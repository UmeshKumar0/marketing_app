import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:marketing/src/user/controller/foreground_syncService.dart';
import 'package:flutter/material.dart';

class DatabaseSync extends GetView<ForeGroundSyncService> {
  const DatabaseSync({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.syncingData.isTrue
          ? Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.syncstatus.value,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const CircularProgressIndicator(
                    color: Colors.indigo,
                  ),
                ],
              ),
            )
          : IconButton(
              onPressed: () {
                try {
                  controller.sync();
                } catch (e) {
                  Fluttertoast.showToast(msg: e.toString());
                }
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.indigo,
              ),
            );
    });
  }
}

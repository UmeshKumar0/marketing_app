import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';

class SyncStatus extends StatelessWidget {
  const SyncStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<CloudController>(builder: (cloud) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: cloud.syncMessage.value == 'IDLE'
              ? Colors.green
              : cloud.syncMessage.value == 'ERROR'
                  ? Colors.red.withOpacity(0.7)
                  : AppConfig.primaryColor7,
          borderRadius: BorderRadius.circular(5),
        ),
        child: cloud.syncMessage.value == "SYNCING.."
            ? Container(
                height: 10,
                width: 10,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 1,
                ),
              )
            : Text(
                cloud.syncMessage.value,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
      );
    });
  }
}

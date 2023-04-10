// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';

class AdminAppBarButton extends StatelessWidget {
  AdminAppBarButton({
    super.key,
    required this.storageController,
  });
  StorageController storageController;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          borderRadius: BorderRadius.circular(25),
          elevation: 1,
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppConfig.primaryColor7,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                '${AppConfig.SERVER_IP}/${storageController.userModel.value.user!.images!.thumbnailUrl}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person,
                    color: AppConfig.primaryColor7,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './../controller/permission_controller.dart';

class PermissionViews extends GetView<PermisionController> {
  const PermissionViews({super.key});
  static String routeName = '/admin/permissions';
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
          'Permissions',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

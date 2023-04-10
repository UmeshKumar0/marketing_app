import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketing/src/admin/screens/deleted_users/controller/deleted_user_controller.dart';

class DeletedUser extends GetView<DeletedUserController> {
  const DeletedUser({super.key});
  static String routeName = '/admin/deleted_user';
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
        'Deleted Users',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
    ));
  }
}

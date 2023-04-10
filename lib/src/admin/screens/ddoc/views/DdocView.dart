import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/DdocController.dart';

class DdocViews extends GetView<DdocController> {
  const DdocViews({super.key});
  static String routeName = '/admin/ddoc';
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
          'Ddoc',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

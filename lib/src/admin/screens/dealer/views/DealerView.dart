
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/DealerController.dart';
class DealerViews extends GetView<DealerController> {
  const DealerViews({super.key});
  static String routeName = '/admin/dealer';
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
          'Dealer',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}


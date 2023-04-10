import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/models/AOdometer.model.dart';
import 'package:marketing/src/admin/screens/odometer/controller/admin_odometer.controller.dart';
import 'package:marketing/src/admin/screens/odometer/views/AOdometerItem.dart';
import 'package:marketing/src/admin/screens/odometer/views/edit_odometer.dart';
import 'package:marketing/src/admin/screens/odometer/views/login_history.dart';
import 'package:marketing/src/admin/screens/odometer/views/odometer_headers.dart';
import 'package:marketing/src/admin/screens/odometer/views/permission_modal.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';

class AOdometerScreen extends GetView<AOdometerController> {
  const AOdometerScreen({super.key});
  static String routeName = '/admin/odometer';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 1,
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
        titleSpacing: 0,
        title: Text(
          'Odometers',
          style: GoogleFonts.firaSans(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          OdometerHeader(controller: controller),
          Expanded(
            child: RefreshIndicator(
              child: PagedListView(
                pagingController: controller.pagingController,
                builderDelegate: PagedChildBuilderDelegate<AOdometer>(
                  itemBuilder: (context, item, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        height: 150,
                        child: AOdometerItem(
                          odometer: item,
                          controller: controller,
                        ),
                      ),
                    );
                  },
                ),
              ),
              onRefresh: () => Future.sync(
                () => controller.pagingController.refresh(),
              ),
            ),
          )
        ],
      ),
    );
  }
}




/// ${DateTime.parse(controller.visits[odometer.user!.sId]!.time.toString()).toLocal().toString().split(' ').last.split('.').first}
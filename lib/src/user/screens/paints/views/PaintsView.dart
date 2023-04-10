import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/user/screens/paints/views/create_request.dart';
import 'package:marketing/src/user/screens/paints/views/paint_request.dart';
import '../controller/PaintsController.dart';

class PaintsViews extends GetView<PaintsController> {
  const PaintsViews({super.key});
  static String routeName = '/admin/paints';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
            'Paints',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Create Request',
                  style: GoogleFonts.firaSans(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Your Requests',
                  style: GoogleFonts.firaSans(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CreateRequest(
              controller: controller,
            ),
            PaintRequest(
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}

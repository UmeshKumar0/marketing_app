// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/user/models/shop_model.dart';
import 'package:marketing/src/user/widgets/create_visit_widget.dart';

class CreateVisitScreen extends StatelessWidget {
  CreateVisitScreen({Key? key}) : super(key: key);

  late Shops shopDetails;
  @override
  Widget build(BuildContext context) {
    var shops = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        titleSpacing: 2,
        title: Text(
          'Create Visit',
          style: GoogleFonts.firaSans(
              fontSize: 20,
              color: Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.w400),
        ),
      ),
      body: CreateVisitWidget(shops: shops as Shops?),
    );
  }
}

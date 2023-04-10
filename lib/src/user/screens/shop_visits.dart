import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/user/controller/shop_visit_controller.dart';
import 'package:marketing/src/user/controller/visit_controller.dart';
import 'package:marketing/src/user/models/shop_model.dart';
import 'package:marketing/src/user/widgets/shop_visit_widget.dart';

class ShopVisitScreen extends StatefulWidget {
  const ShopVisitScreen({Key? key}) : super(key: key);

  @override
  State<ShopVisitScreen> createState() => _ShopVisitScreenState();
}

class _ShopVisitScreenState extends State<ShopVisitScreen> {
  late ShopVisitController _controller;
  late VisitController _visitController;
  @override
  void initState() {
    super.initState();
    _visitController = Get.find<VisitController>();
    _controller = Get.find<ShopVisitController>();
  }

  @override
  Widget build(BuildContext context) {
    Shops shops = ModalRoute.of(context)!.settings.arguments as Shops;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          'Visits By Shop',
          style: GoogleFonts.firaSans(
            fontWeight: FontWeight.w400,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        titleSpacing: 2,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _controller.getVisits(shopId: shops.sId as String);
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.red.withOpacity(0.7),
            ),
          )
        ],
      ),
      body: ShopVisitWidget(
        shopVisitController: _controller,
        visitController: _visitController,
        shop: shops,
      ),
    );
  }
}

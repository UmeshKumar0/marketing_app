// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/user/controller/shop_visit_controller.dart';
import 'package:marketing/src/user/controller/visit_controller.dart';
import 'package:marketing/src/user/models/shop_model.dart';
import 'package:marketing/src/user/widgets/error_widget.dart';
import 'package:marketing/src/user/widgets/visitItem.dart';

class ShopVisitWidget extends StatefulWidget {
  ShopVisitWidget({
    Key? key,
    required this.shopVisitController,
    required this.visitController,
    required this.shop,
  }) : super(key: key);

  ShopVisitController shopVisitController;
  VisitController visitController;
  Shops shop;
  @override
  State<ShopVisitWidget> createState() => _ShopVisitWidgetState();
}

class _ShopVisitWidgetState extends State<ShopVisitWidget> {
  late ShopVisitController controller;
  @override
  void initState() {
    super.initState();
    controller = widget.shopVisitController;
    widget.shopVisitController.getVisits(shopId: widget.shop.sId as String);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.7),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                'This is the visit history of ${widget.shop.name} shop',
                style: GoogleFonts.firaSans(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: controller.isLoading.isTrue
                  ? Container(
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    )
                  : controller.isLoggedOut.isTrue
                      ? CustomErrorWidget(
                          errorMessage:
                              'You are logged out or your session has expired please login again',
                          buttonText: 'Login',
                          loggedOut: true,
                          cb: () {},
                        )
                      : controller.isError.isTrue
                          ? CustomErrorWidget(
                              errorMessage: controller.errorMessage.value,
                              buttonText: 'Retry',
                              cb: () {
                                controller.getVisits(
                                    shopId: widget.shop.sId as String);
                              },
                              loggedOut: false,
                            )
                          : controller.visits.isEmpty
                              ? CustomErrorWidget(
                                  errorMessage: 'No visits found on date ',
                                  buttonText: 'Retry',
                                  loggedOut: false,
                                  cb: () {
                                    controller.getVisits(
                                        shopId: widget.shop.sId as String);
                                  },
                                )
                              : RefreshIndicator(
                                  onRefresh: () => Future.sync(
                                    () => controller.getVisits(
                                      shopId: widget.shop.sId as String,
                                    ),
                                  ),
                                  child: ListView.builder(
                                    physics: const ScrollPhysics(
                                        parent: BouncingScrollPhysics()),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: VisitItem(
                                          visitController:
                                              widget.visitController,
                                          visit: controller.visits[index],
                                        ),
                                      );
                                    },
                                    itemCount: controller.visits.length,
                                  ),
                                ),
            )
          ],
        );
      },
    );
  }
}

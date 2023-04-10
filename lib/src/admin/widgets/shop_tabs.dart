import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/controller/spreview_controller.dart';

class ShopTab extends StatelessWidget {
  ShopTab({
    super.key,
    required this.spreviewController,
  });
  SpreviewController spreviewController;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Obx(
          () {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: spreviewController.tabes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: InkWell(
                    onTap: () {
                      spreviewController
                          .changeSelectedTab(spreviewController.tabes[index]);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: spreviewController.selectedTab.value ==
                                spreviewController.tabes[index]
                            ? AppConfig.primaryColor5
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          spreviewController.tabes[index],
                          style: GoogleFonts.roboto(
                            color: spreviewController.selectedTab.value ==
                                    spreviewController.tabes[index]
                                ? Colors.white
                                : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

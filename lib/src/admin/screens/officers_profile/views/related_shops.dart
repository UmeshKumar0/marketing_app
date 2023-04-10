import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:marketing/src/admin/models/Ashop_model.dart';
import 'package:marketing/src/admin/screens/admin_shops_screen.dart';
import 'package:marketing/src/admin/screens/officers_profile/controller/officer_profile_controller.dart';
import 'package:marketing/src/admin/screens/shop_preview/admin_shop_preview.dart';

class MoRelatedShops extends StatelessWidget {
  MoRelatedShops({
    super.key,
    required this.controller,
  });
  OfficersProfileController controller;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: PagedListView(
        pagingController: controller.shopPageController,
        builderDelegate: PagedChildBuilderDelegate<AShop>(
          itemBuilder: (context, item, index) {
            return Padding(
              padding: const EdgeInsets.all(5),
              child: InkWell(
                onTap: () {
                  Get.toNamed(
                    AShopPreview.route,
                    arguments: item,
                  );
                },
                child: AShopItem(
                  aShop: item,
                ),
              ),
            );
          },
        ),
      ),
      onRefresh: () => Future.sync(
        () => controller.shopPageController.refresh(),
      ),
    );
  }
}

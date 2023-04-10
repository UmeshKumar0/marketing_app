import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:marketing/src/admin/models/AShopVisit.dart';
import 'package:marketing/src/admin/screens/officers_profile/controller/officer_profile_controller.dart';
import 'package:marketing/src/admin/widgets/ashop_postvisit.dart';

class MoRelatedVisits extends StatelessWidget {
  MoRelatedVisits({
    super.key,
    required this.controller,
  });
  OfficersProfileController controller;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: PagedListView(
        pagingController: controller.visitPageController,
        builderDelegate: PagedChildBuilderDelegate<AShopVisit>(
          itemBuilder: (context, item, index) {
            print("====================================");
            print(item.toJson());
            print("====================================");
            return AShopVisitPostWidget(
              visit: item,
            );
          },
        ),
      ),
      onRefresh: () => Future.sync(
        () => controller.visitPageController.refresh(),
      ),
    );
  }
}

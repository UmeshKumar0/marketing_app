import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketing/src/admin/controller/spreview_controller.dart';
import 'package:marketing/src/admin/widgets/ashop_postvisit.dart';
import 'package:marketing/src/admin/widgets/visit_item.dart';

class SRelatedVisits extends StatelessWidget {
  SRelatedVisits({
    super.key,
    required this.spreviewController,
  });
  SpreviewController spreviewController;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(() => spreviewController.fetchVisits()),
      child: Obx(() {
        return spreviewController.visitsLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : spreviewController.visits.isEmpty
                ? const Center(
                    child: Text('No Visits'),
                  )
                : ListView.builder(
                    itemCount: spreviewController.visits.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Obx(
                          () {
                            return spreviewController.isPostMode.isTrue
                                ? AShopVisitPostWidget(
                                    visit: spreviewController.visits[index],
                                  )
                                : AShopVisitItem(
                                    spreviewController: spreviewController,
                                    visit: spreviewController.visits[index],
                                  );
                          },
                        ),
                      );
                    },
                  );
      }),
    );
  }
}

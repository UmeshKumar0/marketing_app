import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/controller/ashop_controller.dart';
import 'package:marketing/src/admin/models/Ashop_model.dart';
import 'package:marketing/src/admin/screens/shop_preview/admin_shop_preview.dart';

class AdminShopsScreen extends GetView<AShopController> {
  AdminShopsScreen({super.key});
  static String route = '/admin/shops';
  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
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
          'Shops',
          style: GoogleFonts.firaSans(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppConfig.primaryColor7,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: controller.cupertinoDate,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  controller.createdAt.value,
                                  style: GoogleFonts.firaSans(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Checkbox(
                              activeColor: Colors.white,
                              fillColor: MaterialStateProperty.all(
                                Colors.white,
                              ),
                              checkColor: AppConfig.primaryColor5,
                              value: controller.dateFilter.value,
                              onChanged: (value) {
                                controller.changeDateFilter();
                              },
                            )
                          ],
                        );
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: controller.decrease,
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                          Obx(() {
                            return Container(
                              padding: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                controller.pageSize.value.toString(),
                                style: GoogleFonts.firaSans(
                                  color: AppConfig.primaryColor5,
                                ),
                              ),
                            );
                          }),
                          IconButton(
                            onPressed: controller.increase,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  TextField(
                    onChanged: (value) {
                      controller.changeName(value);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Seach shop....',
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              child: PagedListView(
                pagingController: controller.pagingController,
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
                () => controller.pagingController.refresh(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AShopItem extends StatelessWidget {
  AShopItem({
    super.key,
    required this.aShop,
  });
  AShop aShop;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          aShop.profile == null
              ? Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '404',
                    style:
                        GoogleFonts.firaSans(color: Colors.white, fontSize: 20),
                  ),
                )
              : Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                          '${AppConfig.SERVER_IP}/${aShop.profile!.thumbnail}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    aShop.name as String,
                    style: GoogleFonts.firaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Text(
                    aShop.address as String,
                    style: GoogleFonts.firaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  aShop.phone as String,
                  style: GoogleFonts.firaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  aShop.email as String,
                  style: GoogleFonts.firaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

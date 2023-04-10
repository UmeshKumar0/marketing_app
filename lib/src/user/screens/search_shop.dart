import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/shop_controller.dart';
import 'package:marketing/src/user/widgets/shop_item.dart';

class SearchShop extends StatelessWidget {
  const SearchShop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ShopController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          titleSpacing: 1,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 25,
            ),
          ),
          title: Container(
            color: Colors.white,
            height: 70,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 5,
                left: 10,
                right: 10,
                bottom: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppConfig.lightBG,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextField(
                              enabled: true,
                              keyboardType: TextInputType.text,

                              // controller: loginController.phoneController,
                              decoration: InputDecoration(
                                  isCollapsed: true,
                                  border: InputBorder.none,
                                  hintText: 'Want to search shops ?',
                                  hintStyle:
                                      GoogleFonts.firaSans(fontSize: 16)),
                              onChanged: (value) async {
                                await controller.searchShop(
                                  name: value,
                                );
                              },
                              cursorHeight: 20,
                              style: GoogleFonts.firaSans(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          controller.isLoading.isTrue
                              ? Container(
                                  height: 25,
                                  width: 25,
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    color: AppConfig.primaryColor7,
                                  ),
                                )
                              : Icon(
                                  Icons.search,
                                  color: AppConfig.primaryColor7,
                                )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: controller.isLoading.isTrue
            ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: AppConfig.primaryColor7,
                ),
              )
            : controller.isError.isTrue
                ? Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.center,
                    child: Text(
                      controller.errMessage,
                      style: GoogleFonts.firaSans(
                        color: AppConfig.primaryColor7,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : controller.shops.isNotEmpty
                    ? ListView.builder(
                        physics: const ScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        itemCount: controller.shops.length,
                        itemBuilder: (context, index) {
                          return ShopItem(
                            item: controller.shops[index],
                          );
                        },
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: Text(
                          'No Shops found with you search key',
                          style: GoogleFonts.firaSans(
                            color: AppConfig.primaryColor7,
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                      ),
      );
    });
  }
}

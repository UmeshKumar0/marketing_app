// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:marketing/src/user/models/shop_model.dart';

class MapShopItem extends StatelessWidget {
  MapShopItem({
    Key? key,
    required this.shops,
    required this.storageController,
  }) : super(key: key);
  Shops shops;
  StorageController storageController;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.7),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Image.asset("assets/createShop.png",
                          fit: BoxFit.cover),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      shops.name as String,
                      style: GoogleFonts.firaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              leading: Icon(
                Icons.map_outlined,
                color: Colors.red.withOpacity(0.7),
              ),
              title: Text(
                'Shop Location',
                style: GoogleFonts.firaSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              subtitle: Text(
                shops.mapAddress as String,
                style: GoogleFonts.firaSans(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.red.withOpacity(0.7),
              ),
              title: Text(
                'Shop Owner',
                style: GoogleFonts.firaSans(),
              ),
              subtitle: Text(
                shops.ownerName as String,
                style: GoogleFonts.firaSans(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () {
                Get.toNamed(
                  AppConfig.SHOP_PREVIEW,
                  arguments: shops,
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppConfig.lightBG,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'View Shop',
                  style: GoogleFonts.firaSans(
                    color: AppConfig.primaryColor5,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

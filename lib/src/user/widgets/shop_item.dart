// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/screens/shop_preview/admin_shop_preview.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:marketing/src/user/models/shopCreate.dart';
import 'package:marketing/src/user/models/shop_model.dart';

class ShopItem extends StatefulWidget {
  ShopItem({
    Key? key,
    required this.item,
  }) : super(key: key);
  Shops item;

  @override
  State<ShopItem> createState() => _ShopItemState();
}

class _ShopItemState extends State<ShopItem> {
  bool isUploading = false;
  bool created = false;
  uploadingShop() async {
    if (Get.find<CloudController>().alive.value == true) {
      try {
        setState(() {
          isUploading = true;
        });
        ShopCreate? shopCreate = Get.find<StorageController>()
            .shopCreateBox
            .get(int.parse(widget.item.sId.toString()));
        if (shopCreate == null) {
          Fluttertoast.showToast(msg: 'Shop not found with this id');
        } else {
          await Get.find<StorageController>()
              .shopCreateBox
              .delete(int.parse(widget.item.sId.toString()));
          Fluttertoast.showToast(msg: 'Shop created successfully');
          setState(() {
            created = true;
          });
        }
        setState(() {
          isUploading = false;
        });
      } on HttpException catch (e) {
        setState(() {
          isUploading = false;
        });
        Fluttertoast.showToast(msg: e.message);
      } catch (e) {
        setState(() {
          isUploading = false;
        });
        Fluttertoast.showToast(msg: e.toString());
      }
    } else {
      Fluttertoast.showToast(msg: 'Please check your internet connection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3, top: 3, left: 5, right: 5),
      color: Colors.white,
      child: ListTile(
        onTap: () {
          if (Get.find<StorageController>().userModel.value.user!.role ==
              'ADMIN') {
            Get.toNamed(
              AShopPreview.route,
              arguments: widget.item,
            );
          } else {
            Get.toNamed(
              AppConfig.SHOP_PREVIEW,
              arguments: widget.item,
            );
          }
        },
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: AppConfig.primaryColor7, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              '${AppConfig.SERVER_IP}/${widget.item.profile!.thumbnail}',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.home_work_rounded,
                  color: AppConfig.primaryColor7,
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.item.name as String,
              style: GoogleFonts.firaSans(
                color: Colors.black.withOpacity(0.7),
                letterSpacing: 1,
                fontWeight: FontWeight.w400,
              ),
            ),
            widget.item.uploaded == false
                ? IconButton(
                    onPressed: () {
                      uploadingShop();
                    },
                    icon: const Icon(
                      Icons.upload,
                      color: Colors.green,
                    ),
                  )
                : Text(
                    'Synced'.toUpperCase(),
                    style: GoogleFonts.firaSans(
                      color: Colors.green,
                      letterSpacing: 1,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/location.png",
              height: 15,
              width: 15,
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                widget.item.address as String,
                style: GoogleFonts.firaSans(
                  color: Colors.indigo.shade500,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.fade,
              ),
            )
          ],
        ),
      ),
    );
  }
}

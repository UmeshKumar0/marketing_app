// ignore_for_file: must_be_immutable, non_constant_identifier_names, file_names

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/visit_controller.dart';
import 'package:marketing/src/user/models/shop_model.dart';
import 'package:marketing/src/user/models/visit_model.dart';

class VisitPostWidget extends StatefulWidget {
  VisitPostWidget({
    super.key,
    required this.visitController,
    required this.visit,
  });
  VisitModel visit;
  VisitController visitController;

  @override
  State<VisitPostWidget> createState() => _VisitPostWidgetState();
}

class _VisitPostWidgetState extends State<VisitPostWidget> {
  List local_text = [];
  bool flag = false;
  bool showMore = false;
  bool loadingShop = false;
  bool isError = false;
  String errorMessage = '';

  fetchShop({
    required String id,
  }) async {
    try {
      setState(() {
        loadingShop = true;
      });
      Shops shops = await widget.visitController.apiController.getShopById(
        id: id,
        online: Get.find<CloudController>().alive.value,
      );
      setState(() {
        loadingShop = false;
      });
      return shops;
    } on HttpException catch (e) {
      setState(() {
        isError = true;
        errorMessage = e.message;
      });
    } catch (err) {
      setState(() {
        isError = true;
        errorMessage = err.toString();
      });
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.visit.remarks!.length > 80) {
      local_text = widget.visit.remarks!.substring(0, 80).split(' ');
      flag = true;
      showMore = true;
    } else {
      local_text = widget.visit.remarks!.split(' ');
      flag = false;
      showMore = false;
    }
  }

  showMoreAndLess() {
    if (showMore) {
      if (flag) {
        setState(() {
          local_text = widget.visit.remarks!.split(' ');
          flag = false;
        });
      } else {
        setState(() {
          local_text = widget.visit.remarks!.substring(0, 80).split(' ');
          flag = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.paste_outlined,
                    color: AppConfig.primaryColor7,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.visit.type as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          widget.visit.type == "SHOP_VISIT"
                              ? widget.visit.shop!.address as String
                              : widget.visit.name == null
                                  ? "NAME NOT FOUND"
                                  : widget.visit.name as String,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.grey.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                widget.visit.type == "SHOP_VISIT"
                    ? widget.visit.shop!.name as String
                    : widget.visit.phone == null
                        ? "PHONE NOT FOUND"
                        : widget.visit.phone as String,
                style: GoogleFonts.firaSans(
                  color: AppConfig.primaryColor7,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: RichText(
                text: TextSpan(
                  text: '',
                  children: [
                    TextSpan(
                      children: local_text
                          .map(
                            (e) => e.contains('#')
                                ? TextSpan(
                                    text: e + ' ',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        print(e);
                                      },
                                    style: GoogleFonts.firaSans(
                                      color: Colors.indigo.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : TextSpan(
                                    text: e + ' ',
                                    style: GoogleFonts.firaSans(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                          )
                          .toList(),
                    ),
                    showMore
                        ? flag
                            ? TextSpan(
                                text: ' show more',
                                style: GoogleFonts.firaSans(
                                  color: Colors.indigo.shade500,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    showMoreAndLess();
                                  })
                            : TextSpan(
                                text: ' show less',
                                style: GoogleFonts.firaSans(
                                  color: Colors.indigo.shade500,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    showMoreAndLess();
                                  })
                        : TextSpan(text: ''),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            widget.visit.images != null && widget.visit.images!.isNotEmpty
                ? Container(
                    height: 300,
                    color: Colors.grey.withOpacity(0.2),
                    child: PageView(
                      physics:
                          const ScrollPhysics(parent: BouncingScrollPhysics()),
                      children: widget.visit.images!
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ClipRRect(
                                child: Image.network(
                                  '${AppConfig.SERVER_IP}/${e.url}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Image not found",
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.5),
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      Shops? shops =
                          await fetchShop(id: widget.visit.shop!.sId as String);
                      if (shops != null) {
                        Get.toNamed(
                          AppConfig.SHOP_PREVIEW,
                          arguments: shops,
                        );
                      }
                    },
                    icon: Icon(
                      Icons.factory_rounded,
                      color: AppConfig.primaryColor7,
                    ),
                    label: Text(
                      loadingShop == true
                          ? 'Loading...'
                          : isError == true
                              ? errorMessage
                              : 'Visit Shop',
                      style: GoogleFonts.firaSans(
                        fontWeight: FontWeight.w500,
                        color: AppConfig.primaryColor7,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Get.toNamed(
                        AppConfig.REMINDER_VISIT,
                        arguments: widget.visit,
                      );
                    },
                    icon: Icon(
                      Icons.speed,
                      color: AppConfig.primaryColor7,
                    ),
                    label: Text(
                      "View Reminders",
                      style: GoogleFonts.firaSans(
                        fontWeight: FontWeight.w500,
                        color: AppConfig.primaryColor7,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

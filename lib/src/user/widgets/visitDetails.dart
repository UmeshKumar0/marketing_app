// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/visit_controller.dart';
import 'package:marketing/src/user/models/shop_model.dart';
import 'package:marketing/src/user/models/visit_model.dart';

class VisitDetails extends StatefulWidget {
  VisitDetails({
    Key? key,
    required this.visit,
    required this.visitController,
    required this.setSelected,
  }) : super(key: key);
  Function setSelected;
  VisitModel visit;
  VisitController visitController;

  @override
  State<VisitDetails> createState() => _VisitDetailsState();
}

class _VisitDetailsState extends State<VisitDetails> {
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
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Visit Detail',
                    style: GoogleFonts.firaSans(
                      fontSize: 20,
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.setSelected();
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
            widget.visit.type != "SHOP_VISIT"
                ? ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.red.withOpacity(0.7),
                    ),
                    title: Text(
                      widget.visit.name as String,
                      style: GoogleFonts.firaSans(
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    subtitle: Text(
                      widget.visit.phone as String,
                      style: GoogleFonts.firaSans(
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                : ListTile(
                    onTap: () async {
                      Shops? shops =
                          await fetchShop(id: widget.visit.shop!.sId as String);
                      if (shops != null) {
                        Get.toNamed(
                          AppConfig.SHOP_PREVIEW,
                          arguments: shops,
                        );
                      }
                    },
                    focusColor: Colors.indigo,
                    leading: Image.asset(
                      "assets/createShop.png",
                      height: 50,
                      width: 50,
                    ),
                    title: Text(
                      '${widget.visit.shop!.name}',
                      style: GoogleFonts.firaSans(
                        fontSize: 20,
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      loadingShop == true
                          ? 'Loading...'
                          : isError == true
                              ? errorMessage
                              : 'View Shop Detail',
                      style: GoogleFonts.firaSans(
                        color: Colors.green,
                      ),
                    ),
                  ),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text(
                        'Visit Image',
                        style: GoogleFonts.firaSans(
                          fontSize: 20,
                          color: Colors.black.withOpacity(0.7),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 300,
                            color: Colors.white,
                            child: widget.visit.images!.isNotEmpty
                                ? PageView(
                                    physics: const ScrollPhysics(
                                        parent: BouncingScrollPhysics()),
                                    children: widget.visit.images!
                                        .map(
                                          (e) => Image.network(
                                            '${AppConfig.SERVER_IP}/${e.url}',
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Center(
                                                child: Text(
                                                  'Image not found',
                                                  style: GoogleFonts.firaSans(
                                                    fontSize: 20,
                                                    color: Colors.black
                                                        .withOpacity(0.7),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                        .toList(),
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Image Not found for this visit',
                                      style: GoogleFonts.firaSans(
                                        fontSize: 16,
                                        color: Colors.black.withOpacity(0.7),
                                        fontWeight: FontWeight.w400,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Swipe to view more images',
                              style: GoogleFonts.firaSans(
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.7),
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      actions: [
                        OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.red.withOpacity(0.7)),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            'Close',
                            style: GoogleFonts.firaSans(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                );
              },
              leading: Icon(
                Icons.image_outlined,
                color: Colors.red.withOpacity(0.7),
              ),
              title: Text(
                'Images',
                style: GoogleFonts.firaSans(
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
              subtitle: Text(
                'Tap to view images',
                style: GoogleFonts.firaSans(
                  color: Colors.green.withOpacity(0.7),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (contex) {
                    return AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Visit Remark',
                            style: GoogleFonts.firaSans(),
                          ),
                          IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Colors.red.withOpacity(0.7),
                            ),
                          )
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                widget.visit.remarks as String,
                                style: GoogleFonts.firaSans(
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          )
                        ],
                      ),
                      actions: const [],
                    );
                  },
                );
              },
              leading: Icon(
                Icons.lock_clock,
                color: Colors.red.withOpacity(0.7),
              ),
              title: Text(
                'Remarks',
                style: GoogleFonts.firaSans(
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
              subtitle: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: widget.visit.remarks!.length > 25
                        ? '${widget.visit.remarks!.substring(0, 25)}... '
                        : widget.visit.remarks as String,
                    style: GoogleFonts.firaSans(
                        fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                  widget.visit.remarks!.length > 25
                      ? TextSpan(
                          text: 'Show More',
                          style: GoogleFonts.firaSans(
                            fontWeight: FontWeight.w400,
                            color: Colors.blue.withOpacity(0.7),
                          ),
                        )
                      : const TextSpan(),
                ]),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.category,
                color: Colors.red.withOpacity(0.7),
              ),
              title: Text(
                'Type',
                style: GoogleFonts.firaSans(
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
              subtitle: Text(
                widget.visit.type as String,
                style: GoogleFonts.firaSans(),
              ),
            ),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.blue.withOpacity(0.7),
                          ),
                        ),
                        onPressed: () {
                          Get.toNamed(
                            AppConfig.CREATE_REMINDER,
                            arguments: widget.visit,
                          );
                        },
                        child: const Text(
                          'Create Reminder',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.red.withOpacity(0.7),
                          ),
                        ),
                        onPressed: () {
                          Get.toNamed(
                            AppConfig.REMINDER_VISIT,
                            arguments: widget.visit,
                          );
                        },
                        child: Text(
                          'View Reminders',
                          style: GoogleFonts.firaSans(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

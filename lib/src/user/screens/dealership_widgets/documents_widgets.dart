// ignore_for_file: unnecessary_null_comparison, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/dealership_controller.dart';
import 'package:marketing/src/user/models/dealership_form/pdf_args.dart';
import 'package:marketing/src/user/screens/dealership_widgets/upload_alert.dart';

class DocumentsWidgets extends StatelessWidget {
  DocumentsWidgets({
    super.key,
    required this.dealerShipController,
  });
  DealerShipController dealerShipController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      margin: const EdgeInsets.only(left: 50, right: 10),
      color: Colors.grey.shade100,
      child: Obx(() {
        return dealerShipController.keys.isEmpty
            ? Center(
                child: Text(
                  "Document Keys not found please contact to Admin",
                  style: GoogleFonts.firaSans(
                    color: Colors.redAccent,
                  ),
                ),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Obx(() {
                      return Container(
                        color: dealerShipController.docs
                                .containsKey(dealerShipController.keys[index])
                            ? Colors.indigo.shade100
                            : Colors.white,
                        child: ListTile(
                          onTap: () {
                            if (dealerShipController.docs.containsKey(
                                dealerShipController.keys[index])) {
                              Get.bottomSheet(
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          top: 10,
                                          right: 20,
                                          bottom: 10,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Docs Details',
                                              style: GoogleFonts.firaSans(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              icon: const Icon(
                                                Icons.clear,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Document Name:  ${dealerShipController.keys[index]}',
                                          style: GoogleFonts.firaSans(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          // ignore: unnecessary_null_comparison
                                          dealerShipController
                                              .docs[dealerShipController
                                                  .keys[index]]!
                                              .reason,
                                          style: GoogleFonts.firaSans(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                if (dealerShipController.docs[
                                                            dealerShipController
                                                                .keys[index]] !=
                                                        null &&
                                                    dealerShipController
                                                            .docs[
                                                                dealerShipController
                                                                        .keys[
                                                                    index]]!
                                                            .url !=
                                                        null) {
                                                  Get.toNamed(
                                                    AppConfig.PDF_SCREEN,
                                                    arguments: PDFArgs(
                                                      link: dealerShipController
                                                          .docs[
                                                              dealerShipController
                                                                  .keys[index]]!
                                                          .url
                                                          .toString(),
                                                      cloud: dealerShipController
                                                          .docs[
                                                              dealerShipController
                                                                  .keys[index]]!
                                                          .uploaded,
                                                    ),
                                                  );
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Document is not Found");
                                                }
                                              },
                                              icon: const Icon(
                                                  Icons.picture_as_pdf),
                                              label: const Text("View"),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                dealerShipController.docs
                                                    .remove(
                                                  dealerShipController
                                                      .keys[index],
                                                );
                                                Get.back();
                                              },
                                              icon: const Icon(
                                                  Icons.change_circle),
                                              label: const Text("Replace"),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                isDismissible: false,
                              );
                            } else {
                              Get.dialog(
                                UploadAlert(
                                  keyString: dealerShipController.keys[index],
                                  dealerShipController: dealerShipController,
                                ),
                                barrierDismissible: false,
                              );
                            }
                          },
                          leading: Icon(
                            Icons.document_scanner,
                            color: AppConfig.primaryColor7,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  dealerShipController.keys[index],
                                  style: GoogleFonts.firaSans(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              dealerShipController.docs.containsKey(
                                      dealerShipController.keys[index])
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : Container(),
                            ],
                          ),
                          subtitle: Text(
                            dealerShipController.docs.containsKey(
                                    dealerShipController.keys[index])
                                ? "File Inserted"
                                : "File Not Inserted",
                            style: GoogleFonts.firaSans(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
                itemCount: dealerShipController.keys.length,
              );
      }),
    );
  }
}

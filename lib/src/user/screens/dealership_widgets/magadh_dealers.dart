import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/dealership_controller.dart';
import 'package:marketing/src/user/models/shop_model.dart';

class MagadhDealersNearby extends StatefulWidget {
  MagadhDealersNearby({
    super.key,
    required this.dealerShipController,
  });
  DealerShipController dealerShipController;

  @override
  State<MagadhDealersNearby> createState() => _MagadhDealersNearbyState();
}

class _MagadhDealersNearbyState extends State<MagadhDealersNearby> {
  @override
  void initState() {
    super.initState();
    widget.dealerShipController.getMagadhShops();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.only(left: 50, right: 10),
        height: 350,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppConfig.primaryColor7,
          ),
        ),
        child: Stack(
          children: [
            widget.dealerShipController.selectedMagadhDealers.keys.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                      child: Text(
                        "No dealers selected please click on add dealers button and add all magadh dealers of nearby you",
                        style: GoogleFonts.firaSans(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      String id = widget
                          .dealerShipController.selectedMagadhDealers.value.keys
                          .elementAt(index);
                      Shops shops = widget.dealerShipController
                          .selectedMagadhDealers.value[id]!;
                      return ListTile(
                        title: Text(
                          shops.name.toString(),
                          style: GoogleFonts.firaSans(),
                        ),
                        subtitle: Text(
                          shops.mapAddress.toString(),
                          style: GoogleFonts.firaSans(),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            widget.dealerShipController
                                .popMagadhDealer(sid: shops.sId.toString());
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      );
                    },
                    itemCount: widget
                        .dealerShipController.selectedMagadhDealers.length,
                  ),
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              "Nearby Magadh Dealers",
                              style: GoogleFonts.firaSans(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                widget.dealerShipController.getMagadhShops();
                              },
                              icon: const Icon(Icons.refresh))
                        ],
                      ),
                      content: Obx(() {
                        return Container(
                          height: 300,
                          color: Colors.white,
                          child: widget.dealerShipController
                                  .magadhDealersLoading.isTrue
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : widget.dealerShipController.magadhDealers
                                      .isEmpty
                                  ? Center(
                                      child: Text(
                                        "No Magadh Dealers found nearby you",
                                        style: GoogleFonts.firaSans(),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemBuilder: (context, index) {
                                        Shops shop = widget.dealerShipController
                                            .magadhDealers[index];
                                        return ListTile(
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  shop.name.toString(),
                                                  style: GoogleFonts.firaSans(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  if (widget
                                                      .dealerShipController
                                                      .selectedMagadhDealers
                                                      .keys
                                                      .contains(shop.sId
                                                          .toString())) {
                                                    widget.dealerShipController
                                                        .popMagadhDealer(
                                                      sid: shop.sId.toString(),
                                                    );
                                                  } else {
                                                    widget.dealerShipController
                                                        .pushMagadhDealer(
                                                      shops: shop,
                                                    );
                                                  }
                                                },
                                                icon: Icon(
                                                  widget.dealerShipController
                                                          .selectedMagadhDealers
                                                          .containsKey(shop.sId)
                                                      ? Icons.check
                                                      : Icons.add,
                                                ),
                                              )
                                            ],
                                          ),
                                          subtitle:
                                              Text(shop.mapAddress.toString()),
                                        );
                                      },
                                      itemCount: widget.dealerShipController
                                          .magadhDealers.length,
                                    ),
                        );
                      }),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            "Done",
                            style: GoogleFonts.firaSans(),
                          ),
                        )
                      ],
                    ),
                  );
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: Text(
                  "Select Dealers",
                  style: GoogleFonts.firaSans(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}

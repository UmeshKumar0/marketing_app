import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/dealership_controller.dart';

class IronDealers extends StatelessWidget {
  IronDealers({
    super.key,
    required this.dealerShipController,
  });

  DealerShipController dealerShipController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: 300,
        margin: const EdgeInsets.only(left: 50, right: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.indigo.shade400,
          ),
        ),
        child: Stack(
          children: [
            dealerShipController.ironDealers.isEmpty
                ? const Center(
                    child: Text("No Iron Dealers Added"),
                  )
                : ListView.builder(
                    physics:
                        const ScrollPhysics(parent: BouncingScrollPhysics()),
                    itemBuilder: (contex, index) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ListTile(
                          tileColor: Colors.white,
                          leading: Icon(
                            Icons.factory_outlined,
                            color: AppConfig.primaryColor7,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  dealerShipController.ironDealers[index].name,
                                  style: GoogleFonts.poppins(
                                    color: AppConfig.primaryColor7,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  dealerShipController.popDealer(
                                    ironDealer:
                                        dealerShipController.ironDealers[index],
                                  );
                                },
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.redAccent,
                                ),
                              )
                            ],
                          ),
                          subtitle: Text(
                            dealerShipController.ironDealers[index].total_sales,
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      );
                    },
                    itemCount: dealerShipController.ironDealers.length,
                  ),
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: Text(
                        "Add Iron Dealers",
                        style: GoogleFonts.firaSans(),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              controller: dealerShipController.ironDealerName,
                              decoration: InputDecoration(
                                hintText: "Enter Iron Dealer's Name",
                                labelText: "Iron Dealer's Name",
                                hintStyle: GoogleFonts.firaSans(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller:
                                  dealerShipController.ironDealerTotalSales,
                              decoration: InputDecoration(
                                hintText: "Total Sales",
                                labelText: "Total Sales",
                                hintStyle: GoogleFonts.firaSans(),
                              ),
                            ),
                          )
                        ],
                      ),
                      actions: [
                        ElevatedButton.icon(
                          onPressed: () {
                            dealerShipController.pushDealer(
                                ironDealer: IronDealer(
                                  name:
                                      dealerShipController.ironDealerName.text,
                                  total_sales: dealerShipController
                                      .ironDealerTotalSales.text,
                                  uploaded: false,
                                ),
                                cb: () {
                                  Get.back();
                                });
                          },
                          icon: const Icon(Icons.check),
                          label: const Text("Add Dealer"),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.clear),
                          label: const Text("Back"),
                        )
                      ],
                    ),
                    barrierDismissible: false,
                  );
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: Text(
                  "Add Iron Dealer",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}

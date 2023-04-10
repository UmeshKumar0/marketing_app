import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/user/controller/dealership_controller.dart';
import 'package:marketing/src/user/screens/dealership/form_widgets.dart';

class DealerShipForm extends GetView<DealerShipController> {
  const DealerShipForm({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
          ),
          title: Text(
            'Dealership',
            style: GoogleFonts.firaSans(
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.pages,
                  color: Colors.indigo.shade400,
                ),
                text: "Registration",
              ),
              Tab(
                icon: Icon(
                  Icons.local_activity,
                  color: Colors.indigo.shade400,
                ),
                text: "Check Status",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DealerShipFormWidgets(controller: controller),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: TextField(
                    controller: controller.gstController,
                    decoration: InputDecoration(
                      hintText: 'Enter your gst number',
                      border: const OutlineInputBorder(),
                      hintStyle: GoogleFonts.firaSans(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      label: const Text("GST Number"),
                    ),
                  ),
                ),
                Obx(() {
                  return controller.checkStatus.isTrue
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (controller.gstController.text.isNotEmpty) {
                                print('calling data');
                                controller.getDealershipStatus();
                              }
                            },
                            icon: const Icon(Icons.search),
                            label: const Text('Search'),
                          ),
                        );
                }),
                Obx(() {
                  return controller.statusMessage.value != "N/A"
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Text(
                            controller.statusMessage.value,
                            style: GoogleFonts.firaSans(
                              fontWeight: FontWeight.w400,
                              color: Colors.green,
                            ),
                          ),
                        )
                      : const SizedBox();
                })
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/controller/admin_controller.dart';
import 'package:marketing/src/admin/models/ReportGraph.dart';

class HomeGraph extends StatelessWidget {
  HomeGraph({
    super.key,
    required this.controller,
  });
  AdminController controller;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        height: 200,
        width: double.infinity,
        child: ListView(
          physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
          scrollDirection: Axis.horizontal,
          children: [
            GraphItem(
              title: 'Today Visits',
              data: controller.reportGraph.value.today as List<Item>,
            ),
            GraphItem(
              title: 'Weekly Visits',
              data: controller.reportGraph.value.week as List<Item>,
            ),
            GraphItem(
              title: 'Monthly Visits',
              data: controller.reportGraph.value.month as List<Item>,
            ),
            GraphItem(
              title: 'Yearly Visits',
              data: controller.reportGraph.value.year as List<Item>,
            ),
          ],
        ),
      );
    });
  }
}

class GraphItem extends StatelessWidget {
  GraphItem({
    super.key,
    required this.title,
    required this.data,
  });
  String title;
  List<Item> data;

  getTotalSum() {
    int sum = 0;
    for (var element in data) {
      sum += element.count == null ? 0 : element.count as int;
    }
    return sum;
  }

  List<String> tab = [
    'OTHERS',
    'SHOP_VISIT',
    'CONSTRUCTION_SITE',
    'CONTRACTOR/MASON_VISIT',
    "CONSTRUCTION_SITE"
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        elevation: 2,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 180,
          width: 180,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  getTotalSum().toString(),
                  style: GoogleFonts.firaSans(
                      color: AppConfig.primaryColor5, fontSize: 20),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return tab.contains(data[index].sId)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  data[index].sId.toString(),
                                  style: GoogleFonts.firaSans(
                                    color: AppConfig.primaryColor8,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  data[index].count.toString(),
                                  style: GoogleFonts.firaSans(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container();
                  },
                  itemCount: 4,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

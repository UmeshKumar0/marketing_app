// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/user/controller/visit_controller.dart';
import 'package:marketing/src/user/widgets/customButton.dart';

class FilterVisitBottomSheet extends StatelessWidget {
  FilterVisitBottomSheet({
    Key? key,
    required this.visitController,
  }) : super(key: key);
  late VisitController visitController;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Visit',
                  style: GoogleFonts.firaSans(
                    fontSize: 20,
                    color: Colors.black.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.clear,
                    color: Colors.black.withOpacity(0.7),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    color: Colors.black,
                    text: 'From ${visitController.from.value}',
                    onTap: () async {
                      await visitController.setStartDate(context: context);
                    },
                  ),
                  CustomButton(
                    color: Colors.black,
                    text: 'To ${visitController.to.value}',
                    onTap: () async {
                      await visitController.setEndDate(context: context);
                    },
                  ),
                ],
              );
            }),
          ),
          Container(
            alignment: Alignment.center,
            child: CustomButton(
              onTap: () {
                visitController.getVisits();
                Navigator.of(context).pop();
              },
              text: "Filter",
              color: Colors.blue.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

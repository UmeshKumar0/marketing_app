// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/visit_controller.dart';
import 'package:marketing/src/user/models/visit_model.dart';
import 'package:marketing/src/user/widgets/visitDetails.dart';

class VisitItem extends StatefulWidget {
  VisitItem({
    Key? key,
    required this.visitController,
    required this.visit,
  }) : super(key: key);
  VisitModel visit;

  VisitController visitController;

  @override
  State<VisitItem> createState() => _VisitItemState();
}

class _VisitItemState extends State<VisitItem> {
  bool selected = false;

  setSelected() {
    setState(() {
      selected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          selected = !selected;
        });
        if (selected) {
          Get.bottomSheet(
            BottomSheet(
              onClosing: () {
                setState(() {
                  selected = false;
                });
              },
              builder: (context) {
                return VisitDetails(
                  setSelected: setSelected,
                  visit: widget.visit,
                  visitController: widget.visitController,
                );
              },
            ),
            elevation: 10,
            isDismissible: false,
          );
        }
      },
      selected: selected,
      selectedColor: Colors.white,
      selectedTileColor: Colors.blue.withOpacity(0.8),
      tileColor: Colors.white,
      leading: Icon(
        Icons.paste_sharp,
        color: selected == true ? Colors.white : AppConfig.primaryColor7,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              widget.visit.type as String,
              style: GoogleFonts.firaSans(
                fontSize: 16,
                color: selected == true
                    ? Colors.white
                    : Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Text(
            widget.visit.createdAt?.split('T')[0] as String,
            style: GoogleFonts.firaSans(
              color: selected == true
                  ? Colors.white
                  : Colors.black.withOpacity(0.7),
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              widget.visit.type == "SHOP_VISIT"
                  ? widget.visit.shop?.name as String
                  : widget.visit.name as String,
              style: GoogleFonts.firaSans(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            widget.visit.type == "SHOP_VISIT"
                ? widget.visit.shop!.address as String
                : "N/A",
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

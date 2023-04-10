import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/controller/spreview_controller.dart';
import 'package:marketing/src/admin/models/AShopVisit.dart';
import 'package:marketing/src/admin/widgets/avisit_details.dart';

class AShopVisitItem extends StatefulWidget {
  AShopVisitItem({
    Key? key,
    required this.spreviewController,
    required this.visit,
  }) : super(key: key);
  AShopVisit visit;

  SpreviewController spreviewController;

  @override
  State<AShopVisitItem> createState() => _VisitItemState();
}

class _VisitItemState extends State<AShopVisitItem> {
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
                return AShopVisitDetails(
                  setSelected: setSelected,
                  visit: widget.visit,
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
              widget.visit.name == null
                  ? "NOT ADDED"
                  : widget.visit.type == "SHOP_VISIT"
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

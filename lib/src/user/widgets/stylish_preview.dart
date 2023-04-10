// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StylishPreviewItem extends StatelessWidget {
  StylishPreviewItem({
    Key? key,
    required this.iconData,
    required this.name,
  }) : super(key: key);
  IconData iconData;
  String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              name,
              style: GoogleFonts.firaSans(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.0,
                fontSize: 17,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';

class StylishIconButton extends StatelessWidget {
  StylishIconButton({
    Key? key,
    required this.iconData,
    required this.text,
  }) : super(key: key);
  IconData iconData;
  String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Icon(
              iconData,
              size: 40,
              color: AppConfig.primaryColor5,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              text,
              style: GoogleFonts.firaSans(
                fontSize: 10,
                color: AppConfig.primaryColor5, 
              ),
            ),
          )
        ],
      ),
    );
  }
}

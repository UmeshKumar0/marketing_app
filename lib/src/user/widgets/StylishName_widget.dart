// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';

class StylishName extends StatelessWidget {
  StylishName({Key? key, required this.firstName, required this.lastName})
      : super(key: key);
  String firstName;
  String lastName;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            firstName,
            style: GoogleFonts.firaSans(
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
                fontSize: 24,
                color: Colors.black.withOpacity(0.8)),
          ),
          Text(
            ' $lastName',
            style: GoogleFonts.firaSans(
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
              fontSize: 24,
              color: AppConfig.primaryColor7,
            ),
          ),
        ],
      ),
    );
  }
}

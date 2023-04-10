// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopAdress extends StatelessWidget {
  ShopAdress({
    Key? key,
    required this.addressController,
  }) : super(key: key);
  TextEditingController addressController;
  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: true,
      keyboardType: TextInputType.text,
      controller: addressController,
      decoration: InputDecoration(
        hintText: 'Enter shop\'s Address',
        hintStyle: GoogleFonts.firaSans(fontSize: 16),
        labelText: "Shop Address",
        prefixIcon: Icon(
          Icons.location_city_rounded,
          color: Colors.red.withOpacity(0.8),
        ),
      ),
      onChanged: (value) async {},
      cursorHeight: 18,
      style: GoogleFonts.firaSans(
        fontSize: 18,
      ),
    );
  }
}

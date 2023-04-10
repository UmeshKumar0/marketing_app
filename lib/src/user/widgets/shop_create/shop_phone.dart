// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopNumber extends StatelessWidget {
  ShopNumber({
    Key? key,
    required this.phoneController,
  }) : super(key: key);
  TextEditingController phoneController;
  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
      ],
      enabled: true,
      keyboardType: TextInputType.number,
      controller: phoneController,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.phone,
          color: Colors.red.withOpacity(0.8),
        ),
        hintText: 'Enter shop\'s phone',
        labelText: "Shop phone",
        hintStyle: GoogleFonts.firaSans(fontSize: 16),
      ),
      onChanged: (value) async {},
      cursorHeight: 18,
      style: GoogleFonts.firaSans(
        fontSize: 18,
      ),
    );
  }
}

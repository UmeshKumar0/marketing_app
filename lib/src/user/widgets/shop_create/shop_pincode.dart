// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopPinCode extends StatelessWidget {
  ShopPinCode({
    Key? key,
    required this.pinCodecontroller,
  }) : super(key: key);
  TextEditingController pinCodecontroller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(6),
      ],
      enabled: true,
      keyboardType: TextInputType.number,
      controller: pinCodecontroller,
      decoration: InputDecoration(
        hintText: 'Enter Pincode',
        labelText: "Shop Pincode",
        hintStyle: GoogleFonts.firaSans(fontSize: 16),
        prefixIcon: Icon(
          Icons.commit_rounded,
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

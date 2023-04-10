// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopEmail extends StatelessWidget {
  ShopEmail({
    Key? key,
    required this.emailController,
  }) : super(key: key);
  TextEditingController emailController;
  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: true,
      keyboardType: TextInputType.text,
      controller: emailController,
      decoration: InputDecoration(
        hintText: 'Enter shop\'s Email (Optional)',
        labelText: "Shop Email (Optional)",
        hintStyle: GoogleFonts.firaSans(fontSize: 16),
        prefixIcon: Icon(
          Icons.email,
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

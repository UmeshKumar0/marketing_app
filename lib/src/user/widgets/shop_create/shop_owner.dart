// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopOwner extends StatelessWidget {
  ShopOwner({
    Key? key,
    required this.ownerController,
  }) : super(key: key);
  TextEditingController ownerController;
  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: true,
      keyboardType: TextInputType.text,
      controller: ownerController,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.person_sharp,
          color: Colors.red.withOpacity(0.8),
        ),
        hintText: 'Enter Owner name',
        labelText: "Owner name",
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

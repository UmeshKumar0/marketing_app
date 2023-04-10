// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopName extends StatelessWidget {
  ShopName({
    Key? key,
    required this.nameController,
  }) : super(key: key);
  TextEditingController nameController;
  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.go,
      controller: nameController,
      enabled: true,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.shopify_sharp,
          color: Colors.red.withOpacity(0.7),
        ),
        hintText: 'Enter Shop name',
        labelText: "Shop Name",
        hintStyle: GoogleFonts.firaSans(fontSize: 16),
      ),
      onChanged: (value) async {},
      style: GoogleFonts.firaSans(
        fontSize: 18,
      ),
    );
  }
}

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/models/shop_model.dart';

class ShopInfo extends StatelessWidget {
  ShopInfo({
    Key? key,
    required this.shops,
  }) : super(key: key);
  Shops shops;
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      children: [
        ListTile(
          leading: Icon(
            Icons.factory_rounded,
            color: AppConfig.primaryColor7,
          ),
          title: Text(
            'Shop Name',
            style: GoogleFonts.firaSans(),
          ),
          subtitle: Text(
            shops.name as String,
            style: GoogleFonts.firaSans(color: Colors.blue.withOpacity(0.7)),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.person,
            color: AppConfig.primaryColor7,
          ),
          title: Text(
            'Owner Name',
            style: GoogleFonts.firaSans(),
          ),
          subtitle: Text(
            shops.ownerName as String,
            style: GoogleFonts.firaSans(color: Colors.blue.withOpacity(0.7)),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.email,
            color: AppConfig.primaryColor7,
          ),
          title: Text(
            'Shop Email',
            style: GoogleFonts.firaSans(),
          ),
          subtitle: Text(
            shops.email as String,
            style: GoogleFonts.firaSans(color: Colors.blue.withOpacity(0.7)),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.phone,
            color: AppConfig.primaryColor7,
          ),
          title: Text(
            'Shop Phone',
            style: GoogleFonts.firaSans(),
          ),
          subtitle: Text(
            shops.phone as String,
            style: GoogleFonts.firaSans(color: Colors.blue.withOpacity(0.7)),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.location_history,
            color: AppConfig.primaryColor7,
          ),
          title: Text(
            'Shop Address',
            style: GoogleFonts.firaSans(),
          ),
          subtitle: Text(
            '${shops.address as String}, ${shops.pincode as String}',
            style: GoogleFonts.firaSans(color: Colors.blue.withOpacity(0.7)),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.map,
            color: AppConfig.primaryColor7,
          ),
          title: Text(
            'Shop Map Address',
            style: GoogleFonts.firaSans(),
          ),
          subtitle: Text(
            shops.mapAddress as String,
            style: GoogleFonts.firaSans(color: Colors.blue.withOpacity(0.7)),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.verified,
            color: AppConfig.primaryColor7,
          ),
          title: Text(
            'Shop Status',
            style: GoogleFonts.firaSans(),
          ),
          subtitle: Text(
            shops.status.toString(),
            style: GoogleFonts.firaSans(color: Colors.blue.withOpacity(0.7)),
          ),
        )
      ],
    );
  }
}

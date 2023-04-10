import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConstantsViews extends StatelessWidget {
  const ConstantsViews({super.key});
  static String routeName = '/admin/constants';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Constants',
          style: GoogleFonts.firaSans(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

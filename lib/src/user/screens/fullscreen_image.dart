// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FullScreenImage extends StatelessWidget {
  FullScreenImage({
    Key? key,
    required this.url,
  }) : super(key: key);
  String url;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          titleSpacing: 1,
          backgroundColor: Colors.white,
          title: Text(
            'Image',
            style: GoogleFonts.firaSans(
                color: Colors.black, fontWeight: FontWeight.w400),
          ),
        ),
        body: Center(
          child: Image.network(
            url,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Text(
                  error.toString(),
                  style: GoogleFonts.firaSans(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

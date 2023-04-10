import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationErrorScreen extends StatelessWidget {
  const LocationErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Fluttertoast.showToast(
            msg: 'Please enable location this page will automatically close');
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Location Error',
            style: GoogleFonts.firaSans(
              color: Colors.indigo,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/location_earth.png"),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Text(
                'Your location is not available. Please enable location service it will automatically redirect you to your previous page.',
                style: GoogleFonts.firaSans(
                  color: Colors.redAccent,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Geolocator.openLocationSettings();
              },
              child: Text(
                'Request Location',
                style: GoogleFonts.firaSans(
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                exit(0);
              },
              child: Text(
                'Close App',
                style: GoogleFonts.firaSans(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

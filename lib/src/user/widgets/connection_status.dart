import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';

class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<CloudController>(builder: (connection) {
      return connection.alive.isFalse
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 3),
              width: double.infinity,
              decoration: BoxDecoration(color: AppConfig.primaryColor8),
              alignment: Alignment.center,
              child: Text(
                'You are offline please check your connection',
                style: GoogleFonts.firaSans(
                  color: Colors.white,
                ),
              ),
            )
          : Container();
    });
  }
}

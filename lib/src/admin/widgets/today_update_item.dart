// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/admin/controller/admin_controller.dart';

class TodayUpdateItem extends StatelessWidget {
  TodayUpdateItem({
    super.key,
    required this.count,
    required this.title,
    required this.icon,
    this.height150 = false,
    required this.adminController,
  });
  IconData icon;
  String title;
  Widget count;
  bool height150;
  AdminController adminController;
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 2,
      child: Container(
        height: 120,
        width: height150 ? 150 : 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Icon(
                  icon,
                  color: Colors.indigoAccent,
                  size: 40,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  title,
                  style: GoogleFonts.firaSans(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              count,
            ],
          ),
        ),
      ),
    );
  }
}

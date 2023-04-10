import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoolButton extends StatelessWidget {
  CoolButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.text,
    this.isAdmin = false,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
  });
  Function onTap;
  bool isAdmin;
  String text;
  IconData icon;
  Color backgroundColor;
  Color iconColor;
  Color textColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: isAdmin ? 40 : 60,
            width: isAdmin ? 40 : 60,
            padding: EdgeInsets.all(isAdmin ? 5 : 15),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(isAdmin ? 6 : 10),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: GoogleFonts.firaSans(
                color: textColor,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

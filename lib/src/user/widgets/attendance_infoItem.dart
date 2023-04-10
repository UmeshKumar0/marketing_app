import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceInfoItem extends StatelessWidget {
  AttendanceInfoItem({
    super.key,
    required this.color,
    required this.value,
  });
  Color color;
  String value;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          value,
          style: GoogleFonts.firaSans(
            fontSize: 12,
            color: Colors.black,
          ),
        )
      ],
    );
  }
}

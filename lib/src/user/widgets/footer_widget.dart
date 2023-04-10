import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'version 1.0.0+3',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.withOpacity(0.9),
                  fontSize: 15),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       'Developed By : ',
            //       style: TextStyle(
            //         fontSize: 15,
            //         color: Colors.grey.withOpacity(0.6),
            //       ),
            //     ),
            //     Text(
            //       'Magadh Digital Solutions',
            //       style: TextStyle(
            //         fontSize: 15,
            //         color: Colors.green.withOpacity(0.6),
            //       ),
            //     )
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

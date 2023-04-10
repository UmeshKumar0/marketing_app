import 'package:flutter/material.dart';
import 'package:marketing/src/user/controller/dealership_controller.dart';

class SDdetails extends StatelessWidget {
  SDdetails({
    super.key,
    required this.dealerShipController,
  });

  DealerShipController dealerShipController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
            enabled: dealerShipController.editable.value,
            keyboardType: TextInputType.number,
            controller: dealerShipController.chequeno,
            decoration: const InputDecoration(
              hintText: "Cheque No. / DD No.",
              label: Text('Cheque No. / DD No.'),
            ),
          ),
          InkWell(
            onTap: () async {
              int milizeconds = await dealerShipController.pickADate();
              dealerShipController.chequeDate.text =
                  DateTime.fromMillisecondsSinceEpoch(milizeconds).toString();
            },
            child: TextFormField(
              enabled: false,
              keyboardType: TextInputType.datetime,
              controller: dealerShipController.chequeDate,
              decoration: const InputDecoration(
                hintText: "Date of Issue",
                label: Text('Date of Issue'),
              ),
            ),
          ),
          TextFormField(
            enabled: dealerShipController.editable.value,
            controller: dealerShipController.chequeAmount,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "SD Amount in Rs.",
              label: Text('SD Amount in Rs.'),
            ),
          )
        ],
      ),
    );
  }
}

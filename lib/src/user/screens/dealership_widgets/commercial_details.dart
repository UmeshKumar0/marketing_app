import 'package:flutter/material.dart';
import 'package:marketing/src/user/controller/dealership_controller.dart';

class CommercialDetails extends StatelessWidget {
  CommercialDetails({
    super.key,
    required this.dealerShipController,
  });
  DealerShipController dealerShipController;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 50, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
            controller: dealerShipController.tradeLicenseDetails,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Trade Licence Details",
              label: Text('Trade Licence Details'),
            ),
          ),
          InkWell(
            onTap: () async {
              int milizeconds = await dealerShipController.pickADate();
              dealerShipController.dateofissue.text =
                  DateTime.fromMillisecondsSinceEpoch(milizeconds).toString();
            },
            child: TextFormField(
              enabled: false,
              keyboardType: TextInputType.datetime,
              controller: dealerShipController.dateofissue,
              decoration: const InputDecoration(
                hintText: "Date of Issue",
                label: Text('Date of Issue'),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              int milizeconds = await dealerShipController.pickADate();
              dealerShipController.validUpTo.text =
                  DateTime.fromMillisecondsSinceEpoch(milizeconds).toString();
            },
            child: TextFormField(
              enabled: false,
              keyboardType: TextInputType.datetime,
              controller: dealerShipController.validUpTo,
              decoration: const InputDecoration(
                hintText: "Date of Expiry",
                label: Text('Date of Expiry'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

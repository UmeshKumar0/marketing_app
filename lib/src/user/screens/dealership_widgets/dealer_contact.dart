import 'package:flutter/material.dart';
import 'package:marketing/src/user/controller/dealership_controller.dart';

class DealerContactDetails extends StatelessWidget {
  DealerContactDetails({
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
            controller: dealerShipController.dealerPhone,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Dealer\'s Phone",
              label: Text('Dealer\'s Phone'),
            ),
          ),
          TextFormField(
            controller: dealerShipController.dealerEmail,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: "Dealer\'s Email",
              label: Text('Dealer\'s Email'),
            ),
          ),
          TextFormField(
            controller: dealerShipController.dealerLandline,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Dealer\'s Landline",
              label: Text('Dealer\'s Landline'),
            ),
          ),
        ],
      ),
    );
  }
}

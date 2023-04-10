import 'package:flutter/material.dart';
import 'package:marketing/src/user/controller/dealership_controller.dart';

class BasicDetails extends StatelessWidget {
  BasicDetails({
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
            enabled: dealerShipController.editable.value,
            keyboardType: TextInputType.number,
            controller: dealerShipController.counterPotential,
            decoration: const InputDecoration(
              hintText: "Counter Potential in MT.",
              label: Text('Counter Potential'),
            ),
          ),
          TextFormField(
            enabled: dealerShipController.editable.value,
            keyboardType: TextInputType.number,
            controller: dealerShipController.tagetQuantity,
            decoration: const InputDecoration(
              label: Text('Target Quantity in MT.'),
              hintText: "Target Quantity",
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: dealerShipController.spaceAvailable,
            enabled: dealerShipController.editable.value,
            decoration: const InputDecoration(
              hintText: "Space Available in Sq.ft.",
              label: Text('Space Available'),
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: dealerShipController.partnerDetails,
            enabled: dealerShipController.editable.value,
            decoration: const InputDecoration(
              hintText: "Partner Name",
              label: Text('Partner Name'),
            ),
          ),
        ],
      ),
    );
  }
}

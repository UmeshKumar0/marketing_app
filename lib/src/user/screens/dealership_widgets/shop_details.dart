import 'package:flutter/material.dart';
import 'package:marketing/src/user/controller/dealership_controller.dart';

class ShopDetails extends StatelessWidget {
  ShopDetails({
    super.key,
    required this.dealerShipController,
  });
  DealerShipController dealerShipController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 50,
        right: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
            enabled: false,
            controller: dealerShipController.counterController,
            decoration: const InputDecoration(
              hintText: "Counter Name",
              label: Text('Counter Name'),
            ),
          ),
          TextFormField(
            enabled: false,
            controller: dealerShipController.firmController,
            decoration: const InputDecoration(
              label: Text('Firm Name'),
              hintText: "Firm Name",
            ),
          ),
          TextFormField(
            enabled: false,
            controller: dealerShipController.gstController,
            decoration: const InputDecoration(
              hintText: "GSTIN",
              label: Text('GSTIN'),
            ),
          ),
          TextFormField(
            enabled: false,
            controller: dealerShipController.addressController,
            decoration: const InputDecoration(
              hintText: "Address",
              label: Text('Address'),
            ),
          ),
          TextFormField(
            enabled: false,
            controller: dealerShipController.talukaController,
            decoration: const InputDecoration(
              hintText: "Taluka",
              label: Text('Taluka'),
            ),
          ),
          TextFormField(
            enabled: false,
            controller: dealerShipController.proprietorController,
            decoration: const InputDecoration(
              hintText: "Proprietor Name",
              label: Text('Proprietor Name'),
            ),
          ),
          TextFormField(
            enabled: false,
            controller: dealerShipController.panController,
            decoration: const InputDecoration(
              hintText: "PAN Number",
              label: Text('PAN Number'),
            ),
          ),
        ],
      ),
    );
  }
}

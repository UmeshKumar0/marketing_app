import 'package:flutter/material.dart';
import 'package:marketing/src/user/controller/dealership_controller.dart';

class BankDetails extends StatelessWidget {
  BankDetails({
    super.key,
    required this.dealerShipController,
  });
  DealerShipController dealerShipController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 10),
      child: Column(
        children: [
          TextFormField(
            controller: dealerShipController.bankName,
            enabled: dealerShipController.editable.value,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: "Name of Bank",
              label: Text('Name of Bank'),
            ),
          ),
          TextFormField(
            controller: dealerShipController.bankBranch,
            enabled: dealerShipController.editable.value,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: "Branch name ",
              label: Text('Branch name'),
            ),
          ),
          TextFormField(
            controller: dealerShipController.bankAccount,
            enabled: dealerShipController.editable.value,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Account No.",
              label: Text('Account No.'),
            ),
          ),
          TextFormField(
            controller: dealerShipController.ccLimits,
            enabled: dealerShipController.editable.value,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "CC Limits from bank",
              label: Text('CC Limits from bank'),
            ),
          ),
          TextFormField(
            controller: dealerShipController.bankIfsc,
            enabled: dealerShipController.editable.value,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: "IFSC Code",
              label: Text('IFSC Code'),
            ),
          ),
          TextFormField(
            controller: dealerShipController.bankMicr,
            enabled: dealerShipController.editable.value,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "MICR Code",
              label: Text('MICR Code'),
            ),
          ),
        ],
      ),
    );
  }
}

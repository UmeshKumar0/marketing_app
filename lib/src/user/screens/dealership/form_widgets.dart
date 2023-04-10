import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/dealership_controller.dart';
import 'package:marketing/src/user/screens/dealership_widgets/index.dart';

class DealerShipFormWidgets extends StatelessWidget {

  DealerShipFormWidgets({
    super.key,
    required this.controller,
  });
  DealerShipController controller;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stepper(
        physics: const ClampingScrollPhysics(),
        steps: [
          Step(
            title: Text(
              "GST Verification",
              style: GoogleFonts.firaSans(
                color: AppConfig.primaryColor7,
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(15),
                ],
                controller: controller.gstinController,
                decoration: InputDecoration(
                  hintText: "Enter GST Number",
                  hintStyle: GoogleFonts.firaSans(
                    color: AppConfig.primaryColor7,
                  ),
                ),
              ),
            ),
            state: controller.stepperIndex.value > 0
                ? StepState.complete
                : controller.stepperIndex.value == 0
                    ? StepState.editing
                    : StepState.disabled,
            subtitle: Text(
              "You have to enter gst number",
              style: GoogleFonts.firaSans(color: Colors.black),
            ),
            isActive: controller.stepperIndex.value == 0,
          ),
          Step(
            title: Text(
              "Shop Details",
              style: GoogleFonts.firaSans(
                color: AppConfig.primaryColor7,
              ),
            ),
            content: ShopDetails(
              dealerShipController: controller,
            ),
            state: controller.stepperIndex.value > 1
                ? StepState.complete
                : controller.stepperIndex.value == 1
                    ? StepState.editing
                    : StepState.disabled,
            subtitle: Text(
              "Shop Details by GST Number",
              style: GoogleFonts.firaSans(color: Colors.black),
            ),
            isActive: controller.stepperIndex.value == 1,
          ),
          Step(
            title: Text(
              "Basic Details",
              style: GoogleFonts.firaSans(
                color: AppConfig.primaryColor7,
              ),
            ),
            content: BasicDetails(
              dealerShipController: controller,
            ),
            state: controller.stepperIndex.value > 2
                ? StepState.complete
                : controller.stepperIndex.value == 2
                    ? StepState.editing
                    : StepState.disabled,
            subtitle: Text(
              "Basic Details of Shop",
              style: GoogleFonts.firaSans(color: Colors.black),
            ),
            isActive: controller.stepperIndex.value == 2,
          ),
          Step(
            title: Text(
              "SD Details",
              style: GoogleFonts.firaSans(
                color: AppConfig.primaryColor7,
              ),
            ),
            content: SDdetails(
              dealerShipController: controller,
            ),
            state: controller.stepperIndex.value > 3
                ? StepState.complete
                : controller.stepperIndex.value == 3
                    ? StepState.editing
                    : StepState.disabled,
            subtitle: Text(
              "Security Deposit Details",
              style: GoogleFonts.firaSans(color: Colors.black),
            ),
            isActive: controller.stepperIndex.value == 3,
          ),
          Step(
            title: Text(
              "Bank Details",
              style: GoogleFonts.firaSans(
                color: AppConfig.primaryColor7,
              ),
            ),
            content: BankDetails(
              dealerShipController: controller,
            ),
            state: controller.stepperIndex.value > 4
                ? StepState.complete
                : controller.stepperIndex.value == 4
                    ? StepState.editing
                    : StepState.disabled,
            subtitle: Text(
              "Bank Account Details",
              style: GoogleFonts.firaSans(color: Colors.black),
            ),
            isActive: controller.stepperIndex.value == 4,
          ),
          Step(
            title: Text(
              "Contact Details",
              style: GoogleFonts.firaSans(
                color: AppConfig.primaryColor7,
              ),
            ),
            content: DealerContactDetails(
              dealerShipController: controller,
            ),
            state: controller.stepperIndex.value > 5
                ? StepState.complete
                : controller.stepperIndex.value == 5
                    ? StepState.editing
                    : StepState.disabled,
            subtitle: Text(
              "Dealer\'s Contact Details",
              style: GoogleFonts.firaSans(color: Colors.black),
            ),
            isActive: controller.stepperIndex.value == 5,
          ),
          Step(
            title: Text(
              "Commercial Details",
              style: GoogleFonts.firaSans(
                color: AppConfig.primaryColor7,
              ),
            ),
            content: CommercialDetails(
              dealerShipController: controller,
            ),
            state: controller.stepperIndex.value > 6
                ? StepState.complete
                : controller.stepperIndex.value == 6
                    ? StepState.editing
                    : StepState.disabled,
            subtitle: Text(
              "Commercial details",
              style: GoogleFonts.firaSans(color: Colors.black),
            ),
            isActive: controller.stepperIndex.value == 6,
          ),
          Step(
            title: Text(
              "Upload Documents",
              style: GoogleFonts.firaSans(
                color: AppConfig.primaryColor7,
              ),
            ),
            content: DocumentsWidgets(
              dealerShipController: controller,
            ),
            state: controller.stepperIndex.value > 7
                ? StepState.complete
                : controller.stepperIndex.value == 7
                    ? StepState.editing
                    : StepState.disabled,
            subtitle: Text(
              "Upload all required documents here otherwise mention reason for not uploading",
              style: GoogleFonts.firaSans(color: Colors.black),
            ),
            isActive: controller.stepperIndex.value == 7,
          ),
          Step(
            title: Text(
              "Iron Dealers",
              style: GoogleFonts.firaSans(
                color: AppConfig.primaryColor7,
              ),
            ),
            content: IronDealers(
              dealerShipController: controller,
            ),
            state: controller.stepperIndex.value > 8
                ? StepState.complete
                : controller.stepperIndex.value == 8
                    ? StepState.editing
                    : StepState.disabled,
            subtitle: Text(
              "Enter Details of your Iron Dealers",
              style: GoogleFonts.firaSans(color: Colors.black),
            ),
            isActive: controller.stepperIndex.value == 8,
          ),
          Step(
            title: Text(
              "Magadh Dealers",
              style: GoogleFonts.firaSans(
                color: AppConfig.primaryColor7,
              ),
            ),
            content: MagadhDealersNearby(
              dealerShipController: controller,
            ),
            state: controller.stepperIndex.value > 9
                ? StepState.complete
                : controller.stepperIndex.value == 9
                    ? StepState.editing
                    : StepState.disabled,
            subtitle: Text(
              "Select 4 or more Nearby Magadh Dealers",
              style: GoogleFonts.firaSans(color: Colors.black),
            ),
            isActive: controller.stepperIndex.value == 9,
          ),
          Step(
            title: Text(
              "Image & Signature",
              style: GoogleFonts.firaSans(
                color: AppConfig.primaryColor7,
              ),
            ),
            content: ImageSignWidget(
              dealerShipController: controller,
            ),
            state: controller.stepperIndex.value > 12
                ? StepState.complete
                : controller.stepperIndex.value == 12
                    ? StepState.editing
                    : StepState.disabled,
            subtitle: Text(
              "Dealer\'s Image & Signature",
              style: GoogleFonts.firaSans(color: Colors.black),
            ),
            isActive: controller.stepperIndex.value == 12,
          ),
          Step(
            title: Text(
              "Approval Request",
              style: GoogleFonts.firaSans(
                color: AppConfig.primaryColor7,
              ),
            ),
            content: Container(
              alignment: Alignment.center,
              child: const Icon(
                Icons.check,
                color: Colors.lightGreen,
                size: 50,
              ),
            ),
            state: controller.stepperIndex.value > 13
                ? StepState.complete
                : controller.stepperIndex.value == 13
                    ? StepState.editing
                    : StepState.disabled,
            subtitle: Text(
              "Your dealership is ready to be approved",
              style: GoogleFonts.firaSans(color: Colors.black),
            ),
            isActive: controller.stepperIndex.value == 13,
          ),
        ],
        currentStep: controller.stepperIndex.value,
        elevation: 2,
        margin: const EdgeInsets.all(10),
        type: StepperType.vertical,
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                controller.stepperIndex.value > 0
                    ? Obx(() {
                        return controller.verifingGst.isTrue
                            ? Container()
                            : ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    AppConfig.primaryColor8,
                                  ),
                                  elevation: MaterialStateProperty.all(2),
                                  padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                  ),
                                ),
                                onPressed: controller.decreaseStepprtIndex,
                                child: Text(
                                  "Previous",
                                  style: GoogleFonts.firaSans(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                      })
                    : Container(),
                controller.stepperIndex.value > 0
                    ? const SizedBox(
                        width: 20,
                      )
                    : Container(),
                Obx(() {
                  return controller.stepperIndex.value > 10
                      ? Container()
                      : controller.verifingGst.isTrue
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  AppConfig.primaryColor7,
                                ),
                                elevation: MaterialStateProperty.all(2),
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                              onPressed: controller.stepperIndex.value == 0
                                  ? controller.verifingGst.isFalse
                                      ? controller.fetchDetailsByGSTNumber
                                      : () {
                                          Fluttertoast.showToast(
                                              msg: "Please wait...");
                                        }
                                  : controller.stepperIndex.value == 2
                                      ? controller.setBasicDetailsInGST
                                      : controller.stepperIndex.value == 3
                                          ? controller.setChequeDetailsInGST
                                          : controller.stepperIndex.value == 4
                                              ? controller.setBankDetailsInGST
                                              : controller.stepperIndex.value ==
                                                      5
                                                  ? controller
                                                      .setContactDetailsInGST
                                                  : controller.stepperIndex
                                                              .value ==
                                                          6
                                                      ? controller
                                                          .setCommercialDetails
                                                      : controller.stepperIndex
                                                                  .value ==
                                                              7
                                                          ? controller
                                                              .setCommercialDetails
                                                          : controller
                                                              .increaseStepperIndex,
                              child: Text(
                                controller.stepperIndex.value == 0
                                    ? 'Verify GST'
                                    : controller.stepperIndex.value == 6 &&
                                            controller.dealerShipFrom.value
                                                    .status ==
                                                false
                                        ? 'Save & Next'
                                        : controller.stepperIndex.value == 10
                                            ? "Next & Complete"
                                            : "Done",
                                style: GoogleFonts.firaSans(
                                  color: Colors.white,
                                ),
                              ),
                            );
                }),
                Obx(() {
                  return controller.stepperIndex.value == 7
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '${controller.docs.length - 1} / ${controller.keys.length}',
                            style: GoogleFonts.firaSans(
                              color: Colors.black,
                            ),
                          ),
                        )
                      : Container();
                })
              ],
            ),
          );
        },
      );
    });
  }
}

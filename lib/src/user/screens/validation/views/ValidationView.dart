import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import '../controller/ValidationController.dart';

class ValidationViews extends GetView<ValidationController> {
  const ValidationViews({super.key});
  static String routeName = '/admin/validation';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Validation',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Obx(
        () {
          return Stepper(
            currentStep: controller.currentInt.value,
            steps: [
              Step(
                title: Text(
                  'Connection Status',
                  style: GoogleFonts.firaSans(),
                ),
                subtitle: Text(
                  controller.connection.value,
                  style: GoogleFonts.firaSans(
                    color: controller.connection.value == 'CONNECTED'
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                content: controller.connection.value == controller.status[1]
                    ? Container(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            'Continue',
                          ),
                        ),
                      )
                    : controller.connection.value == 'CONNECTING'
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                    'Connected to server you can continue to next step'),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: const CircularProgressIndicator(),
                              )
                            ],
                          )
                        : Container(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                              onPressed: () {
                                controller.socket.connect();
                              },
                              child: const Text(
                                'Retry',
                              ),
                            ),
                          ),
                state: controller.currentInt.value == 0
                    ? StepState.editing
                    : controller.currentInt.value > 0
                        ? StepState.complete
                        : StepState.indexed,
                isActive: controller.currentInt.value == 0,
              ),
              Step(
                title: Text(
                  'Select Sim Card',
                  style: GoogleFonts.firaMono(),
                ),
                subtitle: Text(
                  'Select Registered Sim Card',
                  style: GoogleFonts.firaMono(),
                ),
                content: Container(
                  alignment: Alignment.centerLeft,
                  child: controller.gettingSims.isTrue
                      ? Text(
                          'Loading sim cards',
                          style: GoogleFonts.firaSans(
                            color: AppConfig.primaryColor5,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : SizedBox(
                          height: 60,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Obx(() {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: InkWell(
                                    onTap: () {
                                      controller.selectedSlot.value =
                                          controller.simList[index].subsId;

                                      controller.simSlot.value =
                                          controller.simList[index].slot;
                                      controller.selectedSlot.refresh();
                                    },
                                    child: Container(
                                      height: 60,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: controller
                                                      .simList[index].subsId ==
                                                  controller.selectedSlot.value
                                              ? AppConfig.primaryColor5
                                              : Colors.black,
                                          width: controller
                                                      .simList[index].subsId ==
                                                  controller.selectedSlot.value
                                              ? 2
                                              : 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.elliptical(10, 10),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            controller
                                                .simList[index].carrierName,
                                          ),
                                          Text(
                                            "Slot: ${controller.simList[index].slot == 0 ? 1 : 2}",
                                            style: GoogleFonts.firaMono(
                                                color: AppConfig.primaryColor5,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                            },
                            itemCount: controller.simList.length,
                          ),
                        ),
                ),
                state: controller.currentInt.value == 1
                    ? StepState.editing
                    : controller.currentInt.value > 1
                        ? StepState.complete
                        : StepState.indexed,
                isActive: controller.currentInt.value == 1,
              ),
              Step(
                title: Text(
                  'Authorization Request',
                  style: GoogleFonts.firaMono(),
                ),
                subtitle: Text(
                  'Send Authorization Request to Server using sms with your registered mobile number',
                  style: GoogleFonts.firaMono(),
                ),
                content: Container(
                  alignment: Alignment.centerLeft,
                  child: controller.sendingRequest.isTrue
                      ? Text(
                          controller.requestState.value,
                          style: GoogleFonts.firaSans(
                            color: AppConfig.primaryColor5,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            controller.getDeviceInfoandSendToServer();
                          },
                          child: const Text(
                            'Send Request',
                          ),
                        ),
                ),
                state: controller.currentInt.value == 2
                    ? StepState.editing
                    : controller.currentInt.value > 2
                        ? StepState.complete
                        : StepState.indexed,
                isActive: controller.currentInt.value == 2,
              ),
              Step(
                title: Text(
                  'Authorization Response',
                  style: GoogleFonts.firaSans(),
                ),
                subtitle: Text(
                  'Wait for server response',
                  style: GoogleFonts.firaMono(),
                ),
                content: Column(
                  children: [
                    controller.waitingForResponse.isTrue
                        ? Container(
                            alignment: Alignment.centerLeft,
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              controller.message.value,
                              style: GoogleFonts.firaMono(
                                color: Colors.green,
                              ),
                            ),
                          ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.cancleAndRetry();
                        },
                        child: const Text(
                          'Cancle And Retry',
                        ),
                      ),
                    ),
                  ],
                ),
                state: controller.currentInt.value == 3
                    ? StepState.editing
                    : controller.currentInt.value > 3
                        ? StepState.complete
                        : StepState.indexed,
                isActive: controller.currentInt.value == 3,
              ),
            ],
            controlsBuilder: (context, details) => details.currentStep == 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          controller.currentInt.value = 2;
                          controller.currentInt.refresh();
                        },
                        child: Text("Continue"),
                      ),
                    ],
                  )
                : Container(),
          );
        },
      ),
    );
  }
}

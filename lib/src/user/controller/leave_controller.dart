import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/models/leave_create_model.dart';
import 'package:marketing/src/user/models/leave_model.dart';

class LeaveController extends GetxController {
  late ApiController apiController;
  RxList leaves = [].obs;
  RxBool isLoading = false.obs;
  String errorMessage = '';
  RxBool isError = false.obs;
  RxList leaveTypes = [].obs;
  RxBool isLoadingLeaveTypes = false.obs;
  RxBool isErrorLoadingLeaveTypes = false.obs;
  String errorMessageLeaveTypes = '';

  RxString from = 'N/A'.obs;
  RxString to = 'N/A'.obs;
  RxString leaveType = 'N/A'.obs;
  TextEditingController reasonController = TextEditingController();
  RxBool createingLeave = false.obs;

  @override
  void onInit() {
    super.onInit();
    apiController = Get.find<ApiController>();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    apiController.dispose();
  }

  pickDate({required bool isFrom}) {
    showCupertinoModalPopup(
      barrierDismissible: false,
      context: Get.overlayContext!,
      builder: (context) {
        return Container(
          height: 320,
          color: CupertinoColors.lightBackgroundGray,
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (value) {
                    if (isFrom) {
                      from.value = value.toString().substring(0, 10);
                    } else {
                      to.value = value.toString().substring(0, 10);
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CupertinoButton.filled(
                    child: const Text('Back'),
                    onPressed: () {
                      if (isFrom) {
                        from.value = 'N/A';
                      } else {
                        to.value = 'N/A';
                      }
                      Get.back();
                    },
                  ),
                  CupertinoButton.filled(
                    child: const Text('Next'),
                    onPressed: () {
                      Get.back();
                    },
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  loadLeaves() async {
    try {
      isLoading.value = true;
      List<LeaveModel> leaves = await apiController.getAllLeavesofUser();
      this.leaves.value = leaves;
      isLoading.value = false;
    } on HttpException catch (e) {
      isLoading.value = false;
      errorMessage = e.message;
      isError.value = true;
    } catch (e) {
      isLoading.value = false;
      errorMessage = e.toString();
      isError.value = true;
    }
  }

  getLeaveTypes() async {
    try {
      isLoadingLeaveTypes.value = true;
      List leaveTypes = await apiController.getLeaveTypes();
      this.leaveTypes.value = leaveTypes;
      isLoadingLeaveTypes.value = false;
    } on HttpException catch (e) {
      isLoadingLeaveTypes.value = false;
      errorMessageLeaveTypes = e.message;
      isErrorLoadingLeaveTypes.value = true;
    } catch (e) {
      isLoadingLeaveTypes.value = false;
      errorMessageLeaveTypes = e.toString();
      isErrorLoadingLeaveTypes.value = true;
    }
  }

  setLeaveValue({
    required String value,
  }) {
    leaveType.value = value;
  }

  createLeave() async {
    try {
      createingLeave.value = true;

      if (from.value == 'N/A' ||
          to.value == 'N/A' ||
          leaveType.value == 'N/A' ||
          reasonController.text.isEmpty) {
        Get.snackbar('Error', 'Please fill all fields');
        createingLeave.value = false;
        return;
      }

      await apiController.applyForLeave(
        leave: LeaveCreate(
          startDate: from.value,
          endDate: to.value,
          leaveType: leaveType.value,
          reason: reasonController.text,
        ),
      );

      from.value = "N/A";
      to.value = "N/A";
      leaveType.value = "N/A";
      reasonController.text = "";

      createingLeave.value = false;
      Get.snackbar(
        'Success',
        'Leave Created Successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on HttpException catch (e) {
      createingLeave.value = false;
      Get.snackbar(
        'Error',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      createingLeave.value = false;
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

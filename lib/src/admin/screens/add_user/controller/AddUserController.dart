import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:marketing/src/admin/controller/admin_api.dart';
import 'package:marketing/src/admin/models/moProfile.dart';

class AddUserController extends GetxController {
  RxBool isCreating = false.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController empId = TextEditingController();
  RxString dob = DateTime.now().toString().split(' ').first.obs;
  RxString selectedRole = 'SELECT_USER_ROLE'.obs;
  RxBool isActive = false.obs;
  RxString sponsorId = 'N/A'.obs;
  MOProfile profile = MOProfile();
  late AdminApi api;
  RxString title = 'Add User'.obs;

  @override
  void onInit() {
    api = Get.find<AdminApi>();
    if (Get.arguments != null) {
      Map<String, dynamic> data = Get.arguments as Map<String, dynamic>;

      if (data.keys.contains('title')) {
        title.value = data['title'];
      }
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  validateFields() {
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Name is required');
      return false;
    }
    if (phone.text.isEmpty) {
      Get.snackbar('Error', 'Phone is required');
      return false;
    }
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Email is required');
      return false;
    }
    if (areaController.text.isEmpty) {
      Get.snackbar('Error', 'Area is required');
      return false;
    }
    if (selectedRole.value == 'SELECT_USER_ROLE') {
      Get.snackbar('Error', 'Please select a role');
      return false;
    }
    if (sponsorId.value == 'N/A') {
      Get.snackbar('Error', 'Please select a sponsor');
      return false;
    }
    if (dob.value == "N/A") {
      Get.snackbar('Error', 'Please select a date of birth');
      return false;
    }
    if (empId.text.isEmpty) {
      Get.snackbar('Error', 'Please enter employee id');
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    nameController.dispose();
    phone.dispose();
    emailController.dispose();
    areaController.dispose();
    super.onClose();
  }

  cuportinoDatePicker({
    required BuildContext context,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime.now(),
            onDateTimeChanged: (DateTime newDateTime) {
              dob.value = newDateTime.toString().split(' ').first;
            },
          ),
        );
      },
    );
  }

  createUser() async {
    if (validateFields()) {
      Map<String, dynamic> body = {
        'name': nameController.text,
        'phone': phone.text,
        'email': emailController.text,
        'area': areaController.text,
        'dob': dob.value,
        'role': selectedRole.value,
        'status': isActive.value ? 'ACTIVE' : 'BLOCKED',
        'sponsor': sponsorId.value,
        'emp_id': empId.text,
      };

      isCreating.value = true;
      try {
        await api.createUserAccount(body: body);
        areaController.text = '';
        nameController.text = '';
        phone.text = '';
        emailController.text = '';
        dob.value = DateTime.now().toString().split(' ').first;
        selectedRole.value = 'SELECT_USER_ROLE';
        sponsorId.value = 'N/A';
        empId.text = '';
        Fluttertoast.showToast(msg: 'User created successfully');
        isCreating.value = false;
      } on HttpException catch (e) {
        Fluttertoast.showToast(msg: 'Error: ${e.message}');
        isCreating.value = false;
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
        isCreating.value = false;
      }
    }
  }
}

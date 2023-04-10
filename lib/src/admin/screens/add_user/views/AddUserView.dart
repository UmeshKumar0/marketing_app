import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/models/moProfile.dart';
import 'package:marketing/src/admin/screens/sponsor/views/SponsorView.dart';
import '../controller/AddUserController.dart';

class AddUserViews extends GetView<AddUserController> {
  const AddUserViews({super.key});
  static String routeName = '/admin/adduser';
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
          'Create User',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  enabled: controller.isCreating.value ? false : true,
                  controller: controller.nameController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Enter Name',
                    label: Text(
                      'Enter User\'s Name',
                      style: GoogleFonts.firaSans(
                        color: AppConfig.primaryColor5,
                      ),
                    ),
                  ),
                  style: GoogleFonts.firaSans(
                    fontSize: 16,
                    color: Colors.indigo.shade400,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  enabled: controller.isCreating.value ? false : true,
                  controller: controller.phone,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Enter Phone',
                    label: Text(
                      'Enter User\'s Phone',
                      style: GoogleFonts.firaSans(
                        color: AppConfig.primaryColor5,
                      ),
                    ),
                  ),
                  style: GoogleFonts.firaSans(
                    fontSize: 16,
                    color: Colors.indigo.shade400,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  enabled: controller.isCreating.value ? false : true,
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Enter Email',
                    label: Text(
                      'Enter User\'s Email',
                      style: GoogleFonts.firaSans(
                        color: AppConfig.primaryColor5,
                      ),
                    ),
                  ),
                  style: GoogleFonts.firaSans(
                    fontSize: 16,
                    color: Colors.indigo.shade400,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  enabled: controller.isCreating.value ? false : true,
                  controller: controller.areaController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Enter Area',
                    label: Text(
                      'Enter User\'s Area',
                      style: GoogleFonts.firaSans(
                        color: AppConfig.primaryColor5,
                      ),
                    ),
                  ),
                  style: GoogleFonts.firaSans(
                    fontSize: 16,
                    color: Colors.indigo.shade400,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  enabled: controller.isCreating.value ? false : true,
                  controller: controller.empId,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Enter Employee ID',
                    label: Text(
                      'Enter User\'s Employee ID',
                      style: GoogleFonts.firaSans(
                        color: AppConfig.primaryColor5,
                      ),
                    ),
                  ),
                  style: GoogleFonts.firaSans(
                    fontSize: 16,
                    color: Colors.indigo.shade400,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    if (controller.isCreating.value == false) {
                      controller.cuportinoDatePicker(
                        context: context,
                      );
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Please wait... while we create user');
                    }
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: controller.dob.value != "N/A"
                        ? Text(
                            controller.dob.value,
                          )
                        : Text(
                            'Pick Date Of Birth'.toUpperCase(),
                            style: GoogleFonts.firaSans(
                              color: Colors.indigo.shade400,
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: DropdownButton(
                    items: const [
                      DropdownMenuItem(
                        value: 'SELECT_USER_ROLE',
                        child: Text('SELECT_USER_ROLE'),
                      ),
                      DropdownMenuItem(
                        value: 'ADMIN',
                        child: Text('ADMIN'),
                      ),
                      DropdownMenuItem(
                        value: 'USER',
                        child: Text('USER'),
                      ),
                      DropdownMenuItem(
                        value: 'MARKETING_OFFICER',
                        child: Text('MARKETING_OFFICER'),
                      ),
                    ],
                    onChanged: (value) {
                      controller.selectedRole.value = value.toString();
                    },
                    isExpanded: true,
                    underline: const SizedBox(),
                    value: controller.selectedRole.value,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: controller.isActive.value,
                        onChanged: (value) {
                          controller.isActive.value = value!;
                        },
                      ),
                      Text(
                        'Create as Active User',
                        style: GoogleFonts.firaSans(
                          color: Colors.indigo.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    if (controller.isCreating.value == false) {
                      var profile = await Get.toNamed(SponsorViews.routeName);
                      if (profile != null) {
                        controller.profile = profile as MOProfile;
                        controller.sponsorId.value = profile.sId.toString();
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Please select a sponsor for this user',
                        );
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Please wait... while we create user');
                    }
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: controller.sponsorId.value == "N/A"
                        ? Text(
                            'Select Sponsor for this User'.toUpperCase(),
                            style: GoogleFonts.firaSans(
                              color: Colors.indigo.shade400,
                            ),
                          )
                        : Text(
                            '${controller.profile.name}',
                            style: GoogleFonts.firaSans(
                              color: Colors.indigo.shade400,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    if (controller.isCreating.isTrue) {
                      Fluttertoast.showToast(
                          msg: 'Please wait... while we create user');
                    } else {
                      controller.createUser();
                    }
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade400,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: controller.isCreating.isTrue
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 1,
                          )
                        : Text(
                            'Create User'.toUpperCase(),
                            style: GoogleFonts.firaSans(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

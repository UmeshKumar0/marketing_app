// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/visit_controller.dart';
import 'package:marketing/src/user/models/shop_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketing/src/user/widgets/connection_status.dart';
import 'package:marketing/src/user/widgets/cool_button.dart';
import 'package:marketing/src/user/widgets/customButton.dart';

class CreateVisitWidget extends StatefulWidget {
  CreateVisitWidget({
    Key? key,
    required this.shops,
  }) : super(key: key);
  Shops? shops;

  @override
  State<CreateVisitWidget> createState() => _CreateVisitWidgetState();
}

class _CreateVisitWidgetState extends State<CreateVisitWidget> {
  clear() {
    setState(() {
      widget.shops = null;
    });
  }

  setShop({
    required Shops shops,
  }) {
    setState(() {
      widget.shops = shops;
    });
  }

  late VisitController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<VisitController>();
    controller.getNearbyShops();
    controller.getTypes();
    if (widget.shops != null) {
      controller.setType(type: "SHOP_VISIT");
    }
  }

  TextEditingController remarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const ConnectionStatus(),
          widget.shops != null
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.7),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  child: Text(
                    'Create Visit for Shop ${widget.shops!.name}',
                    style: GoogleFonts.firaSans(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : Container(),
          const SizedBox(
            height: 10,
          ),
          Obx(
            () {
              return controller.visitType.value != 'N/A'
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: AppConfig.primaryColor7,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(Icons.category,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              flex: 5,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  controller.visitType.value,
                                  style: GoogleFonts.firaSans(
                                    fontSize: 17,
                                    color: Colors.black.withOpacity(0.8),
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                controller.clearType();
                                setState(() {
                                  widget.shops = null;
                                });
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: AppConfig.primaryColor7,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(Icons.category,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: controller.loadingType.isTrue
                                  ? Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Loading...',
                                        style: GoogleFonts.firaSans(
                                          fontSize: 17,
                                          color: Colors.black.withOpacity(0.8),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                  : controller.types.isEmpty
                                      ? Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Types Not Found',
                                            style: GoogleFonts.firaSans(
                                              fontSize: 16,
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              fontWeight: FontWeight.w400,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppConfig.lightBG,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: DropdownButton(
                                            underline: Container(),
                                            isExpanded: true,
                                            elevation: 3,
                                            iconDisabledColor:
                                                AppConfig.primaryColor7,
                                            iconEnabledColor:
                                                Colors.blue.withOpacity(0.7),
                                            hint: Text(
                                              'SELECT VISIT TYPE',
                                              style: GoogleFonts.firaSans(
                                                fontSize: 17,
                                                color: Colors.blue
                                                    .withOpacity(0.7),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            menuMaxHeight:
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.5,
                                            items: controller.types.map((type) {
                                              return DropdownMenuItem(
                                                value: type.value,
                                                child: Text(
                                                  type.value,
                                                  style: GoogleFonts.firaSans(
                                                    fontSize: 17,
                                                    color: Colors.black
                                                        .withOpacity(0.8),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              controller.setType(
                                                  type: value.toString());
                                            },
                                          ),
                                        ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () async {
                                if (controller.loadingType.isFalse) {
                                  await controller.getTypes();
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                alignment: Alignment.center,
                                child: controller.loadingType.isTrue
                                    ? const CircularProgressIndicator()
                                    : const Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Obx(
            () {
              return controller.visitType.value == "SHOP_VISIT"
                  ? widget.shops != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: AppConfig.primaryColor7,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Icon(Icons.factory,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Flexible(
                                  flex: 5,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.shops!.name as String,
                                      style: GoogleFonts.firaSans(
                                        fontSize: 17,
                                        color: Colors.black.withOpacity(0.8),
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: clear,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: AppConfig.primaryColor7,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Icon(Icons.factory,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: controller.loadingNearByShops.isTrue
                                      ? Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Loading...',
                                            style: GoogleFonts.firaSans(
                                              fontSize: 17,
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        )
                                      : controller.nearbyShops.isEmpty
                                          ? Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'No Shops Found',
                                                style: GoogleFonts.firaSans(
                                                  fontSize: 16,
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          : Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppConfig.lightBG,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: DropdownButton(
                                                underline: Container(),
                                                isExpanded: true,
                                                elevation: 3,
                                                iconDisabledColor:
                                                    AppConfig.primaryColor7,
                                                iconEnabledColor: Colors.blue
                                                    .withOpacity(0.7),
                                                hint: Text(
                                                  'SELECT NEARBY SHOP',
                                                  style: GoogleFonts.firaSans(
                                                    fontSize: 17,
                                                    color: Colors.blue
                                                        .withOpacity(0.7),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                menuMaxHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.5,
                                                items: controller.nearbyShops
                                                    .map((shop) {
                                                  return DropdownMenuItem(
                                                    value: shop,
                                                    child: Text(
                                                      shop.name,
                                                      style:
                                                          GoogleFonts.firaSans(
                                                        fontSize: 17,
                                                        color: Colors.black
                                                            .withOpacity(0.8),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setShop(
                                                      shops: value as Shops);
                                                },
                                              ),
                                            ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (controller.loadingNearByShops.isFalse) {
                                      await controller.getNearbyShops();
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    alignment: Alignment.center,
                                    child: controller.loadingNearByShops.isTrue
                                        ? const CircularProgressIndicator()
                                        : const Icon(
                                            Icons.refresh,
                                            color: Colors.white,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                  : Container();
            },
          ),

          Obx(() {
            return controller.visitType.value == 'CP_CODE'
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter CP Code',
                                hintStyle: GoogleFonts.firaSans(
                                  fontSize: 17,
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.w400,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                controller.fetchShopWithCpCode(cpCode: value);
                              },
                            ),
                          ),
                          controller.fetchShop.isTrue
                              ? const SizedBox(
                                  width: 5,
                                )
                              : Container(),
                          controller.fetchShop.isTrue
                              ? Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  alignment: Alignment.center,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  )
                : Container();
          }),
          Obx(() {
            return controller.visitType.value == "CP_CODE"
                ? controller.fetchedShops.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "No Shop Found Please enter Cp Code and Selected Shop",
                                style: GoogleFonts.firaSans(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: 300,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Icon(
                                  Icons.factory_rounded,
                                  color: AppConfig.primaryColor7,
                                ),
                                onTap: () {
                                  setState(() {
                                    widget.shops =
                                        controller.fetchedShops[index];
                                    controller.visitType.value = "SHOP_VISIT";
                                  });
                                },
                                title: Text(
                                  controller.fetchedShops[index].name,
                                  style: GoogleFonts.firaSans(),
                                ),
                                subtitle: Text(
                                  controller.fetchedShops[index].mapAddress,
                                  style: GoogleFonts.firaSans(),
                                ),
                              );
                            },
                            itemCount: controller.fetchedShops.length,
                          ),
                        ),
                      )
                : Container();
          }),
          Obx(() {
            return controller.visitType.value == "SHOP_VISIT" ||
                    controller.visitType.value == "N/A" ||
                    controller.visitType.value == "CP_CODE"
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            spreadRadius: -10,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: controller.phoneController,
                          enabled: !controller.creatingVisit.value,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Enter Phone Number',
                            hintStyle: GoogleFonts.firaSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.blue.withOpacity(0.7),
                            ),
                            prefixIcon: Icon(
                              Icons.phone,
                              color: AppConfig.primaryColor7,
                            ),
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                    ),
                  );
          }),
          Obx(() {
            return controller.visitType.value == "SHOP_VISIT" ||
                    controller.visitType.value == "N/A" ||
                    controller.visitType.value == "CP_CODE"
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            spreadRadius: -10,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: controller.nameController,
                          enabled: !controller.creatingVisit.value,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Enter Name',
                            hintStyle: GoogleFonts.firaSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.blue.withOpacity(0.7),
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                              color: AppConfig.primaryColor7,
                            ),
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                    ),
                  );
          }),
          SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: -10,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: remarkController,
                    // enabled: !reminder.createReminderLoading.value,
                    expands: true,
                    maxLines: null,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Remark for this Visit',
                      hintStyle: GoogleFonts.firaSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.blue.withOpacity(0.7),
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                ),
              ),
            ),
          ),

          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Switch(
                  value: controller.reminder.value,
                  onChanged: (value) {
                    controller.reminder.value = value;
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Add Reminder for this visit",
                  style: GoogleFonts.firaSans(),
                ),
              ],
            );
          }),

          Obx(() {
            return controller.reminder.isTrue
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          controller.pickDateAndTimeFor(context: context);
                        },
                        child: Text(
                          controller.pickedDate.value == "N/A"
                              ? "Tap Here to Pick Date".toUpperCase()
                              : controller.pickedDate.value,
                          style: GoogleFonts.firaSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container();
          }),
          const SizedBox(
            height: 5,
          ),
          Obx(() {
            return controller.reminder.isTrue
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          controller.pickDateAndTimeFor(context: context);
                        },
                        child: TextField(
                          controller: controller.remarkController,
                          decoration: const InputDecoration(
                            label: Text("Reminder Message (Optional)"),
                            hintText: "Input Reminder Message (Optional)",
                          ),
                        ),
                      ),
                    ),
                  )
                : Container();
          }),

          //Image ......
          Obx(() {
            return controller.visitImg.isNotEmpty
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: InkWell(
                                    onTap: () {
                                      Get.bottomSheet(
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 5,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Actions',
                                                      style:
                                                          GoogleFonts.firaSans(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      icon: const Icon(
                                                        Icons.clear,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              ListTile(
                                                leading: Icon(
                                                  Icons.image,
                                                  color:
                                                      AppConfig.primaryColor7,
                                                ),
                                                title: Text(
                                                  'View Image',
                                                  style: GoogleFonts.firaSans(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    color: Colors.blue
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  controller.removeImage(
                                                      img: controller
                                                          .visitImg[index]);
                                                  Get.back();
                                                },
                                                leading: Icon(
                                                  Icons.clear,
                                                  color:
                                                      AppConfig.primaryColor7,
                                                ),
                                                title: Text(
                                                  'Remove From List',
                                                  style: GoogleFonts.firaSans(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    color: Colors.blue
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                          topRight: Radius.circular(5),
                                        ),
                                        child: Image.file(
                                          File(controller.visitImg[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: controller.visitImg.length,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');

                              Get.bottomSheet(
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 15,
                                        spreadRadius: -10,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Select Image',
                                              style: GoogleFonts.firaSans(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                color: AppConfig.primaryColor7,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                color: AppConfig.primaryColor7,
                                              ),
                                              onPressed: () {
                                                Get.back();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            CoolButton(
                                              icon: Icons.camera,
                                              onTap: () async {
                                                final String image =
                                                    await Get.toNamed(AppConfig
                                                        .CAMERA_SCREEN);

                                                controller.visitImg.add(image);
                                                Get.back();
                                              },
                                              text: "Camera 1",
                                              backgroundColor:
                                                  AppConfig.primaryColor5,
                                              iconColor: Colors.white,
                                              textColor:
                                                  AppConfig.primaryColor5,
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            CoolButton(
                                              icon: Icons.camera_alt,
                                              onTap: () async {
                                                ImagePicker picker =
                                                    ImagePicker();
                                                final XFile? image =
                                                    await picker.pickImage(
                                                  source: ImageSource.camera,
                                                  preferredCameraDevice:
                                                      CameraDevice.rear,
                                                  imageQuality: 50,
                                                  maxHeight: 640,
                                                  maxWidth: 480,
                                                );

                                                if (image != null) {
                                                  controller.visitImg
                                                      .add(image.path);
                                                  Get.back();
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: 'No image selected');
                                                }
                                              },
                                              text: "Camera 2",
                                              backgroundColor:
                                                  AppConfig.primaryColor5,
                                              iconColor: Colors.white,
                                              textColor:
                                                  AppConfig.primaryColor5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                isDismissible: false,
                              );
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    child: InkWell(
                      onTap: () async {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');

                        Get.bottomSheet(
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 15,
                                  spreadRadius: -10,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Select Image',
                                        style: GoogleFonts.firaSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: AppConfig.primaryColor7,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: AppConfig.primaryColor7,
                                        ),
                                        onPressed: () {
                                          Get.back();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CoolButton(
                                        icon: Icons.camera,
                                        onTap: () async {
                                          final String image =
                                              await Get.toNamed(
                                                  AppConfig.CAMERA_SCREEN);

                                          controller.visitImg.add(image);
                                          Get.back();
                                        },
                                        text: "Camera 1",
                                        backgroundColor:
                                            AppConfig.primaryColor5,
                                        iconColor: Colors.white,
                                        textColor: AppConfig.primaryColor5,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      CoolButton(
                                        icon: Icons.camera_alt,
                                        onTap: () async {
                                          ImagePicker picker = ImagePicker();
                                          final XFile? image =
                                              await picker.pickImage(
                                            source: ImageSource.camera,
                                            preferredCameraDevice:
                                                CameraDevice.rear,
                                            imageQuality: 50,
                                            maxHeight: 640,
                                            maxWidth: 480,
                                          );

                                          if (image != null) {
                                            controller.visitImg.add(image.path);
                                            Get.back();
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: 'no image selected');
                                          }
                                        },
                                        text: "Camera 2",
                                        backgroundColor:
                                            AppConfig.primaryColor5,
                                        iconColor: Colors.white,
                                        textColor: AppConfig.primaryColor5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isDismissible: false,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: AppConfig.primaryColor7,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Click here to add visit image',
                                style: GoogleFonts.firaSans(
                                  fontSize: 17,
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
          }),
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Switch(
                  value: controller.instantCreate.value,
                  onChanged: (value) {
                    controller.instantCreate.value = value;
                  },
                ),
                Text(
                  'Want to create Instantly ?',
                  style: GoogleFonts.firaSans(
                    fontSize: 17,
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            );
          }),
          Obx(() {
            return controller.creatingVisit.isTrue
                ? Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  )
                : CustomButton(
                    onTap: () {
                      var focus = FocusScope.of(context);
                      if (!focus.hasPrimaryFocus) {
                        focus.unfocus();
                      }
                      if (controller.visitType.value == 'SHOP_VISIT') {
                        if (widget.shops == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Please select a shop",
                                style:
                                    GoogleFonts.firaSans(color: Colors.white),
                              ),
                              backgroundColor: Colors.red.withOpacity(0.7),
                            ),
                          );
                        } else {
                          controller.createVisit(
                            context: context,
                            remarks: remarkController.text,
                            shopId: widget.shops!.sId as String,
                            shopUploaded: widget.shops!.uploaded,
                            withOutShop: false,
                            cb: () {
                              Get.back();
                            },
                          );
                        }
                      } else {
                        controller.createVisit(
                          context: context,
                          remarks: remarkController.text,
                          shopUploaded: false,
                          withOutShop: true,
                          cb: () {
                            Get.back();
                          },
                        );
                      }
                    },
                    text: "Create Visit",
                    color: Colors.blue.withOpacity(0.7),
                  );
          }),
        ],
      ),
    );
  }
}

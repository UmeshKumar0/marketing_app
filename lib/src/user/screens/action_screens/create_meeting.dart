import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/meetings_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marketing/src/user/models/meetings/meeting_user.dart';
import 'package:marketing/src/user/models/shop_model.dart';

class CreateMeeting extends GetView<MeetingsController> {
  const CreateMeeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Create Meeting",
          style: GoogleFonts.firaSans(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Obx(
              () {
                return controller.shopSelected.isTrue
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
                                    controller.shops.name.toString(),
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
                                onTap: controller.unSetShop,
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
                                child: controller.fetchShop.isTrue
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
                                    : controller.fetchedShops.isEmpty
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
                                              items: controller.fetchedShops
                                                  .map((shop) {
                                                return DropdownMenuItem(
                                                  value: shop,
                                                  child: Text(
                                                    shop.name,
                                                    style: GoogleFonts.firaSans(
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
                                                controller.setShop(
                                                  shops: value as Shops,
                                                );
                                              },
                                            ),
                                          ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () async {
                                  if (controller.fetchShop.isFalse) {
                                    await controller.fetchShopWithCpCode(
                                      cpCode: "",
                                    );
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
                                  child: controller.fetchShop.isTrue
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
            Obx(() {
              return controller.shopSelected.isTrue
                  ? Container()
                  : Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Or",
                        style: GoogleFonts.firaSans(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    );
            }),
            Obx(() {
              return controller.shopSelected.isTrue
                  ? Container()
                  : Padding(
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
                                  hintText:
                                      'Search Shop by Name, CP Code or Email',
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
                            controller.shopLoadingWithInput.isTrue
                                ? const SizedBox(
                                    width: 5,
                                  )
                                : Container(),
                            controller.shopLoadingWithInput.isTrue
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
                    );
            }),
            Obx(() {
              return controller.shopSelected.isTrue
                  ? Container()
                  : controller.fetchShopWithInput.isEmpty
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
                                    controller.setShop(
                                      shops:
                                          controller.fetchShopWithInput[index],
                                    );
                                  },
                                  title: Text(
                                    controller.fetchShopWithInput[index].name,
                                    style: GoogleFonts.firaSans(),
                                  ),
                                  subtitle: Text(
                                    controller
                                        .fetchShopWithInput[index].mapAddress,
                                    style: GoogleFonts.firaSans(),
                                  ),
                                );
                              },
                              itemCount: controller.fetchShopWithInput.length,
                            ),
                          ),
                        );
            }),
            Obx(
              () {
                return controller.userSelected.isTrue
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
                                child: const Icon(Icons.person,
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
                                    controller.user!.name.toString(),
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
                                onTap: controller.unSetUser,
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
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              ValueListenableBuilder(
                                  valueListenable: controller
                                      .storageController.meetingUserBox
                                      .listenable(),
                                  builder: (c, v, a) {
                                    return Obx(() {
                                      return Expanded(
                                        child: controller.userLoading.isTrue
                                            ? Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Loading...',
                                                  style: GoogleFonts.firaSans(
                                                    fontSize: 17,
                                                    color: Colors.black
                                                        .withOpacity(0.8),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              )
                                            : controller.storageController
                                                    .meetingUserBox.isEmpty
                                                ? Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      'No Meeting user Found',
                                                      style:
                                                          GoogleFonts.firaSans(
                                                        fontSize: 16,
                                                        color: Colors.black
                                                            .withOpacity(0.8),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                : Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 3,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: AppConfig.lightBG,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: DropdownButton(
                                                      underline: Container(),
                                                      isExpanded: true,
                                                      elevation: 3,
                                                      iconDisabledColor:
                                                          AppConfig
                                                              .primaryColor7,
                                                      iconEnabledColor: Colors
                                                          .blue
                                                          .withOpacity(0.7),
                                                      hint: Text(
                                                        'SELECT MEETING USER',
                                                        style: GoogleFonts
                                                            .firaSans(
                                                          fontSize: 17,
                                                          color: Colors.blue
                                                              .withOpacity(0.7),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      menuMaxHeight:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.5,
                                                      items: controller
                                                          .storageController
                                                          .meetingUserBox
                                                          .values
                                                          .map((user) {
                                                        return DropdownMenuItem(
                                                          value: user,
                                                          child: Text(
                                                            user.name
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .firaSans(
                                                              fontSize: 17,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.8),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        controller.setUser(
                                                          user: value
                                                              as MeetingUser,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                      );
                                    });
                                  }),
                              const SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () async {
                                  if (controller.userLoading.isFalse) {
                                    await controller.getMeetingUsers();
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
                                  child: controller.userLoading.isTrue
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
            Obx(() {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Container(
                  height: 50,
                  width: double.infinity,
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
                        child: const Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            if (controller.meetingDate.value == "N/A") {
                              controller.setMeetingDate();
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please clear the date first");
                            }
                          },
                          child: Text(
                            controller.meetingDate.value != "N/A"
                                ? controller.meetingDate.value
                                : 'Tap Here Pick Meeting Date',
                            style: GoogleFonts.firaSans(
                              fontSize: 17,
                              color: Colors.indigo,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      controller.meetingDate.value != "N/A"
                          ? InkWell(
                              onTap: controller.unsetDate,
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              );
            }),
            Obx(() {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    hint: const Text("SELECT FOOD"),
                    value: controller.food.value,
                    items: const [
                      DropdownMenuItem(
                        value: "SELECT FOOD",
                        child: Text("Select Food"),
                      ),
                      DropdownMenuItem(
                        value: 'Breakfast',
                        child: Text('Breakfast'),
                      ),
                      DropdownMenuItem(
                        value: 'Lunch',
                        child: Text('Lunch'),
                      ),
                    ],
                    onChanged: (value) {
                      controller.food.value = "";
                      controller.food.value = value.toString();
                    },
                  ),
                ),
              );
            }),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(5),
            //     ),
            //     child: TextField(
            //       controller: controller.food,
            //       decoration: InputDecoration(
            //         hintText: 'Enter Food details',
            //         hintStyle: GoogleFonts.firaSans(
            //           fontSize: 17,
            //           color: Colors.black.withOpacity(0.8),
            //           fontWeight: FontWeight.w400,
            //         ),
            //         border: OutlineInputBorder(),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: controller.strength,
                  decoration: InputDecoration(
                    hintText: 'Enter Strength details',
                    hintStyle: GoogleFonts.firaSans(
                      fontSize: 17,
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: controller.remark,
                  decoration: InputDecoration(
                    hintText: 'Add Remark (Optional)',
                    hintStyle: GoogleFonts.firaSans(
                      fontSize: 17,
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: controller.gift,
                  decoration: InputDecoration(
                    hintText: 'Gift Details (Optional)',
                    hintStyle: GoogleFonts.firaSans(
                      fontSize: 17,
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                controller.createMeeting(callBack: () {
                  Fluttertoast.showToast(msg: "Meeting Created Successfully");
                  Get.back();
                });
              },
              icon: const Icon(Icons.check),
              label: const Text("Create Meeting"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/shop_create_controller.dart';
import 'package:marketing/src/user/screens/preview_screen.dart';
import 'package:marketing/src/user/widgets/brands_products.dart';
import 'package:marketing/src/user/widgets/cool_button.dart';
import 'package:marketing/src/user/widgets/shop_create/shop_address.dart';
import 'package:marketing/src/user/widgets/shop_create/shop_email.dart';
import 'package:marketing/src/user/widgets/shop_create/shop_name.dart';
import 'package:marketing/src/user/widgets/shop_create/shop_owner.dart';
import 'package:marketing/src/user/widgets/shop_create/shop_phone.dart';
import 'package:marketing/src/user/widgets/shop_create/shop_pincode.dart';
import 'package:marketing/src/user/widgets/shop_images.dart';

class CreateShopScreen extends StatelessWidget {
  const CreateShopScreen({Key? key}) : super(key: key);

  showSnacebar() {
    Get.snackbar(
      "Error",
      "Please fill all the fields",
      // backgroundColor: Colors.red.withOpacity(0.7),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 2,
      backgroundColor: Colors.red.withOpacity(0.7),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: GetX<ShopCreateController>(
          builder: (controller) {
            return IconButton(
              onPressed: () {
                Get.back();
              },
              icon: controller.preview.isTrue
                  ? const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
            );
          },
        ),
        titleSpacing: 2,
        title: GetX<ShopCreateController>(
          builder: (controller) {
            return Text(
              controller.preview.isTrue ? 'Preview & Create' : 'Create Shop',
              style: GoogleFonts.firaSans(
                  fontSize: 20,
                  color: Colors.black.withOpacity(0.8),
                  fontWeight: FontWeight.w400),
            );
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: GetX<ShopCreateController>(builder: (shop) {
        return WillPopScope(
          onWillPop: () {
            if (shop.isLoading.isFalse) {
              return Future.value(true);
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Are you sure?"),
                    content: const Text(
                        "You will lose all the data you have entered"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("No"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  );
                },
                barrierDismissible: false,
              );

              return Future.value(false);
            }
          },
          child: Stepper(
            steps: [
              Step(
                title: const Text("Shop name & Owner"),
                content: Column(
                  children: [
                    ShopName(
                      nameController: shop.nameController,
                    ),
                    ShopOwner(
                      ownerController: shop.ownerController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Or",
                        style: GoogleFonts.firaSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 5),
                      child: TextField(
                        onChanged: (value) {
                          shop.debouncingFetcher(cpCode: value);
                        },
                        decoration: InputDecoration(
                          hintText: "CP Code",
                          label: Text(
                            "CP Code",
                            style: GoogleFonts.firaSans(),
                          ),
                          hintStyle: GoogleFonts.firaSans(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          shop.cpLoading.isTrue
                              ? 'Loading...'
                              : shop.cpShopFound.isTrue
                                  ? 'Shop found'
                                  : 'Shop not found enter cp_code',
                          style: GoogleFonts.firaSans(
                            color:
                                shop.cpLoading.isTrue || shop.cpShopFound.isTrue
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                subtitle: Text(
                  "Enter shop name and owner name",
                  style: GoogleFonts.firaSans(),
                ),
                isActive: shop.currentIndex.value == 0,
                state: shop.currentIndex.value == 0
                    ? StepState.editing
                    : shop.currentIndex.value > 0
                        ? StepState.complete
                        : StepState.disabled,
              ),
              Step(
                title: const Text("Contact Details"),
                content: Column(
                  children: [
                    ShopEmail(
                      emailController: shop.emailController,
                    ),
                    ShopNumber(
                      phoneController: shop.phoneController,
                    ),
                  ],
                ),
                subtitle: Text(
                  "Enter shop email and phone number",
                  style: GoogleFonts.firaSans(),
                ),
                isActive: shop.currentIndex.value == 1,
                state: shop.currentIndex.value == 1
                    ? StepState.editing
                    : shop.currentIndex.value > 1
                        ? StepState.complete
                        : StepState.disabled,
              ),
              Step(
                title: const Text("Brands & Products"),
                content: BrandProducts(shopCreateController: shop),
                subtitle: Text("Select brands and products",
                    style: GoogleFonts.firaSans()),
                isActive: shop.currentIndex.value == 2,
                state: shop.currentIndex.value == 2
                    ? StepState.editing
                    : shop.currentIndex.value > 2
                        ? StepState.complete
                        : StepState.disabled,
              ),
              Step(
                title: const Text("Address & Images"),
                content: Column(
                  children: [
                    ShopAdress(
                      addressController: shop.addressController,
                    ),
                    ShopPinCode(
                      pinCodecontroller: shop.pinCodeController,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            shop.imagePath.isEmpty
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                      ),
                                      color: Colors.red.withOpacity(0.7),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.photo_camera,
                                      color: Colors.white,
                                    ),
                                  )
                                : Container(),
                            shop.imagePath.isEmpty
                                ? const SizedBox(
                                    width: 10,
                                  )
                                : Container(),
                            ShopImages(shopController: shop),
                            shop.imagePath.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                        ),
                                        color: Colors.blue.withOpacity(0.7),
                                      ),
                                      child: InkWell(
                                        onTap: () async {
                                          SystemChannels.textInput
                                              .invokeMethod('TextInput.hide');

                                          Get.bottomSheet(
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 15,
                                                    spreadRadius: -10,
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Select Image',
                                                          style: GoogleFonts
                                                              .firaSans(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 16,
                                                            color: AppConfig
                                                                .primaryColor7,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.close,
                                                            color: AppConfig
                                                                .primaryColor7,
                                                          ),
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        CoolButton(
                                                          icon: Icons.camera,
                                                          onTap: () async {
                                                            print(
                                                                "===========+++++++++++++++=======++++++++++======+++++");
                                                            final String image =
                                                                await Get.toNamed(
                                                                    AppConfig
                                                                        .CAMERA_SCREEN);
                                                            if (image !=
                                                                "N/A") {
                                                              shop.pushImage(
                                                                  img: image);
                                                            } else {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'No image selected');
                                                            }
                                                            Get.back();
                                                          },
                                                          text: "Camera 1",
                                                          backgroundColor:
                                                              AppConfig
                                                                  .primaryColor5,
                                                          iconColor:
                                                              Colors.white,
                                                          textColor: AppConfig
                                                              .primaryColor5,
                                                        ),
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        CoolButton(
                                                          icon:
                                                              Icons.camera_alt,
                                                          onTap: () async {
                                                            ImagePicker picker =
                                                                ImagePicker();
                                                            final XFile? image =
                                                                await picker
                                                                    .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .camera,
                                                              preferredCameraDevice:
                                                                  CameraDevice
                                                                      .rear,
                                                              imageQuality: 50,
                                                              maxHeight: 640,
                                                              maxWidth: 480,
                                                            );

                                                            if (image != null) {
                                                              shop.pushImage(
                                                                  img: image
                                                                      .path);
                                                              Get.back();
                                                            } else {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'No image selected');
                                                            }
                                                          },
                                                          text: "Camera 2",
                                                          backgroundColor:
                                                              AppConfig
                                                                  .primaryColor5,
                                                          iconColor:
                                                              Colors.white,
                                                          textColor: AppConfig
                                                              .primaryColor5,
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
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                isActive: shop.currentIndex.value == 3,
                state: shop.currentIndex.value == 3
                    ? StepState.editing
                    : shop.currentIndex.value > 3
                        ? StepState.complete
                        : StepState.disabled,
                subtitle: Text(
                  "Enter shop address and upload images",
                  style: GoogleFonts.firaSans(),
                ),
              ),
              Step(
                title: const Text("Preview"),
                content: ShopPreviewScreen(shopCreateController: shop),
                subtitle:
                    Text("Preview your shop", style: GoogleFonts.firaSans()),
                isActive: shop.currentIndex.value == 4,
                state: shop.currentIndex.value == 4
                    ? StepState.editing
                    : shop.currentIndex.value > 4
                        ? StepState.complete
                        : StepState.disabled,
              )
            ],
            currentStep: shop.currentIndex.value,
            controlsBuilder: (context, details) {
              return Obx(() {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      shop.currentIndex.value != 0
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.redAccent),
                                ),
                                onPressed: shop.decreaseCurrentIndex,
                                child: Text(
                                  "PREVIOUS",
                                  style: GoogleFonts.firaSans(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: shop.uploadingImage.isTrue
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.upload,
                                    color: Colors.green,
                                  ),
                                  Text(
                                    "Uploading... ${shop.uploadingImgCount.value}%",
                                    style: GoogleFonts.firaSans(
                                        color: Colors.green),
                                  )
                                ],
                              )
                            : shop.isCreated.isTrue
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      Text(
                                        "Created...",
                                        style: GoogleFonts.firaSans(),
                                      )
                                    ],
                                  )
                                : shop.isLoading.isTrue
                                    ? const CircularProgressIndicator()
                                    : ElevatedButton(
                                        onPressed: shop.increasCurrentIndex,
                                        child: Text(
                                          shop.currentIndex.value == 3
                                              ? "PREVIEW"
                                              : shop.currentIndex.value == 4
                                                  ? "CREATE"
                                                  : "NEXT",
                                          style: GoogleFonts.firaSans(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                      )
                    ],
                  ),
                );
              });
            },
          ),
        );
      }),
    );
  }
}
